import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../config/app_config.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  String? _userId;
  String? _userName;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get error => _error;
  String? get token => _token;

  // Vérifier si l'utilisateur est déjà connecté
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConfig.sessionCookieKey);
    _userId = prefs.getString(AppConfig.userIdKey);
    _userName = prefs.getString('user_name');
    
    if (_token != null && _userId != null) {
      _isAuthenticated = true;
      await _apiService.loadSessionCookie();
      await _apiService.saveSessionCookie(_token!);
    }
    notifyListeners();
  }

// Connexion
Future<bool> login(String email, String password) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    final response = await _apiService.login(email, password);
    
    if (response['success'] == true) {
      _userId = response['user_id']?.toString();
      _userName = response['user_name'];
      
      // Sauvegarder les données
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.userIdKey, _userId!);
      await prefs.setString(AppConfig.userNameKey, _userName ?? '');
      // Cookie de session enregistré par ApiService.login
      _token = prefs.getString(AppConfig.sessionCookieKey);
      
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    _error = 'Identifiants invalides';
    _isLoading = false;
    notifyListeners();
    return false;
  } catch (e) {
    _error = 'Erreur: ${e.toString()}';
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

  // Déconnexion
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _isAuthenticated = false;
    _token = null;
    _userId = null;
    _userName = null;
    notifyListeners();
  }
}