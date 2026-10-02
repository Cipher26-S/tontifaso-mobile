import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/member.dart';
import '../models/deposit.dart';
import '../models/loan.dart';
import 'demo_data.dart';

class ApiService {
  final String baseUrl;
  String? _sessionCookie;

  ApiService({this.baseUrl = AppConfig.baseUrl});

  // ==================== INSCRIPTION ====================
  // ==================== INSCRIPTION ====================
  Future<Map<String, dynamic>> register(String fullname, String email, String password) async {
    if (AppConfig.demoMode) {
      return {
        'success': true,
        'message': 'Mode démo : utilisez ${DemoData.email} / ${DemoData.password} pour vous connecter',
      };
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${AppConfig.registerEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': fullname,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': data['success'] == true,
          'message': data['message'],
        };
      }
      
      return {
        'success': false,
        'message': data['message'] ?? 'Erreur serveur (${response.statusCode})',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion : $e',
      };
    }
  }

  // Charger le cookie de session depuis le stockage local
  Future<void> loadSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    _sessionCookie = prefs.getString(AppConfig.sessionCookieKey);
  }

  // Sauvegarder le cookie de session
  Future<void> saveSessionCookie(String cookie) async {
    _sessionCookie = cookie;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.sessionCookieKey, cookie);
  }

  // Headers avec le cookie de session
  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_sessionCookie != null) {
      headers['Cookie'] = _sessionCookie!;
    }
    return headers;
  }

  // Extraire le cookie Set-Cookie de la réponse
  String? _extractSessionCookie(http.Response response) {
    final setCookie = response.headers['set-cookie'];
    if (setCookie != null) {
      // Extraire uniquement PHPSESSID=...
      final regex = RegExp(r'PHPSESSID=([^;]+)');
      final match = regex.firstMatch(setCookie);
      if (match != null) {
        return 'PHPSESSID=${match.group(1)}';
      }
    }
    return null;
  }

  // ==================== AUTHENTIFICATION ====================

  // Connexion (retourne les données utilisateur)
  Future<Map<String, dynamic>> login(String email, String password) async {
    if (AppConfig.demoMode) {
      if (email != DemoData.email || password != DemoData.password) {
        throw Exception('Identifiants de démo : ${DemoData.email} / ${DemoData.password}');
      }
      await saveSessionCookie('PHPSESSID=demo');
      return {
        'success': true,
        'user_id': DemoData.memberId,
        'user_name': DemoData.memberName,
        'user_role': 'member',
      };
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${AppConfig.loginEndpoint}'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          // Sauvegarder le cookie de session
          final cookie = _extractSessionCookie(response);
          if (cookie != null) {
            await saveSessionCookie(cookie);
          }
          
          return {
            'success': true,
            'user_id': data['user']['id']?.toString(),
            'user_name': data['user']['fullname'],
            'user_role': data['user']['role'],
          };
        } else {
          throw Exception(data['message'] ?? 'Échec de connexion');
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    if (AppConfig.demoMode) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConfig.sessionCookieKey);
      _sessionCookie = null;
      return;
    }
    try {
      await http.get(
        Uri.parse('$baseUrl${AppConfig.logoutEndpoint}'),
        headers: _headers,
      );
      
      // Supprimer le cookie local
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConfig.sessionCookieKey);
      _sessionCookie = null;
    } catch (e) {
      // Ignorer les erreurs de déconnexion
    }
  }

  // ==================== DONNÉES GLOBALES ====================

  // Récupérer toutes les données (membres, dépôts, prêts)
  Future<Map<String, dynamic>> getAllData() async {
    if (AppConfig.demoMode) return DemoData.allData();
    try {
      await loadSessionCookie(); // Charger le cookie si pas déjà fait
      
      final response = await http.get(
        Uri.parse('$baseUrl${AppConfig.getDataEndpoint}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          return data['data'];
        } else {
          throw Exception('Échec de récupération des données');
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // ==================== MEMBRES ====================

  Future<List<Member>> getMembers() async {
    try {
      final allData = await getAllData();
      final membersList = allData['members'] as List? ?? [];
      
      return membersList.map((json) => Member.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur récupération membres: $e');
    }
  }

  Future<Member?> getMemberById(String memberId) async {
    try {
      final members = await getMembers();
      return members.firstWhere(
        (m) => m.id == memberId,
        orElse: () => throw Exception('Membre non trouvé'),
      );
    } catch (e) {
      return null;
    }
  }

  // ==================== DÉPÔTS ====================

  Future<List<Deposit>> getDeposits(String memberId) async {
    try {
      final allData = await getAllData();
      final depositsList = allData['deposits'] as List? ?? [];
      
      // Filtrer par membre
      return depositsList
          .where((json) => json['memberId']?.toString() == memberId)
          .map((json) => Deposit.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur récupération dépôts: $e');
    }
  }

  // Ajouter un dépôt
  Future<bool> addDeposit(String memberId, double amount, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${AppConfig.addContributionEndpoint}'),
        headers: _headers,
        body: jsonEncode({
          'member_id': memberId,
          'amount': amount,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ==================== PRÊTS ====================

  Future<List<Loan>> getLoans(String memberId) async {
    try {
      final allData = await getAllData();
      final loansList = allData['loans'] as List? ?? [];
      
      // Filtrer par membre
      return loansList
          .where((json) => json['memberId']?.toString() == memberId)
          .map((json) => Loan.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur récupération prêts: $e');
    }
  }

  // Ajouter un prêt
  Future<bool> addLoan(Map<String, dynamic> loanData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${AppConfig.addLoanEndpoint}'),
        headers: _headers,
        body: jsonEncode(loanData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Ajouter un paiement
  Future<bool> addPayment(String loanId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${AppConfig.addPaymentEndpoint}'),
        headers: _headers,
        body: jsonEncode({
          'loan_id': loanId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}