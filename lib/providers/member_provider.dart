import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/member.dart';
import '../models/deposit.dart';
import '../models/loan.dart';

class MemberProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Member? _member;
  List<Deposit> _deposits = [];
  List<Loan> _loans = [];
  bool _isLoading = false;
  String? _error;

  Member? get member => _member;
  List<Deposit> get deposits => _deposits;
  List<Loan> get loans => _loans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalDeposits {
    return _deposits.fold(0, (sum, deposit) => sum + deposit.amount);
  }

  double get totalLoans {
    return _loans.fold(0, (sum, loan) => sum + loan.amount);
  }

  double get totalRemaining {
    return _loans.fold(0, (sum, loan) => sum + loan.remainingAmount);
  }

  List<Loan> get activeLoans {
    return _loans.where((loan) => loan.status == 'active').toList();
  }

 // Dans member_provider.dart

void setSessionCookie(String cookie) {
  _apiService.saveSessionCookie(cookie);
}

// Compatibilité : méthode utilisée ailleurs `setToken`
void setToken(String token) {
  setSessionCookie(token);
}

// Charger le profil par memberId
Future<void> loadProfile(String memberId) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    _member = await _apiService.getMemberById(memberId);
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _error = e.toString();
    _isLoading = false;
    notifyListeners();
  }
}

  // Charger les dépôts
  Future<void> loadDeposits(String memberId) async {
    try {
      _deposits = await _apiService.getDeposits(memberId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Charger les prêts
  Future<void> loadLoans(String memberId) async {
    try {
      _loans = await _apiService.getLoans(memberId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Charger toutes les données
  Future<void> loadAllData(String memberId) async {
    await loadProfile(memberId);
    await loadDeposits(memberId);
    await loadLoans(memberId);
  }

  // Rafraîchir les données
  Future<void> refresh(String memberId) async {
    await loadAllData(memberId);
  }
}