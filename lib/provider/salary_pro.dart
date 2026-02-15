// lib/provider/salary_pro.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/helper/token_expired_dialoge.dart';
import 'package:school_management_demo/models/salary_model.dart';
import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';

enum SalaryStatus { initial, loading, loaded, error, loadingMore }

class SalaryProvider extends ChangeNotifier {
  // State
  SalaryStatus _status = SalaryStatus.initial;
  String? _errorMessage;

  // Data
  List<SalaryRecord>? _salaryRecords;
  SalarySummary? _salarySummary;
  PendingPaymentsResponse? _pendingPaymentsResponse;
  EmployeeSalaryHistory? _employeeSalaryHistory;
  List<SalaryAdjustment>? _salaryAdjustments;
  
  // Pagination
  int _currentPage = 0;
  bool _hasMore = true;
  static const int _itemsPerPage = 20;

  // Getters - State
  SalaryStatus get status => _status;
  String? get errorMessage => _errorMessage;

  // Getters - Data
  List<SalaryRecord>? get getSalaryRecords => _salaryRecords;
  SalarySummary? get getSalarySummary => _salarySummary;
  PendingPaymentsResponse? get getPendingPayments => _pendingPaymentsResponse;
  EmployeeSalaryHistory? get getEmployeeSalaryHistory => _employeeSalaryHistory;
  List<SalaryAdjustment>? get getSalaryAdjustments => _salaryAdjustments;

  // Getters - Pagination
  bool get isLoading => _status == SalaryStatus.loading;
  bool get isLoadingMore => _status == SalaryStatus.loadingMore;
  bool get isLoaded => _status == SalaryStatus.loaded;
  bool get hasError => _status == SalaryStatus.error;
  bool get hasMore => _hasMore;

  /// ============== GENERATE MONTHLY SALARY ==============
  Future<String> generateMonthlySalary({
    required int month,
    required int year,
    required String employeeType, // 'teacher' or 'staff'
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = GenerateMonthlySalaryRequest(
        month: month,
        year: year,
        employeeType: employeeType,
      );

      final response = await postFunction(
        body.toJson(),
        Api.salary.generateMonthlySalary,
        authorization: true,
        tokenKey: token,
      );

      // Check token expired
      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== ADD BONUS ==============
  Future<String> addBonus({
    required String employeeId,
    required String employeeType,
    required String bonusType,
    required double amount,
    required String description,
    required int month,
    required int year,
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = AddBonusRequest(
        employeeId: employeeId,
        employeeType: employeeType,
        bonusType: bonusType,
        amount: amount,
        description: description,
        month: month,
        year: year,
      );

      final response = await postFunction(
        body.toJson(),
        Api.salary.addBonus,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== ADD DEDUCTION ==============
  Future<String> addDeduction({
    required String employeeId,
    required String employeeType,
    required String deductionType,
    required double amount,
    required String description,
    required int month,
    required int year,
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = AddDeductionRequest(
        employeeId: employeeId,
        employeeType: employeeType,
        deductionType: deductionType,
        amount: amount,
        description: description,
        month: month,
        year: year,
      );

      final response = await postFunction(
        body.toJson(),
        Api.salary.addDeduction,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== ADJUST SALARY ==============
  Future<String> adjustSalary({
    required String employeeId,
    required String employeeType,
    required double newSalary,
    required String effectiveFrom,
    required String reason,
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = AdjustSalaryRequest(
        employeeId: employeeId,
        employeeType: employeeType,
        newSalary: newSalary,
        effectiveFrom: effectiveFrom,
        reason: reason,
      );

      final response = await postFunction(
        body.toJson(),
        Api.salary.adjustSalary,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== GET SALARY RECORDS ==============
  Future<String> fetchSalaryRecords({
    required int month,
    required int year,
    String? employeeType,
    String? employeeId,
    String? paymentStatus, // 'pending', 'paid', 'cancelled'
    bool refresh = false,
    required BuildContext context,
  }) async {
    try {
      if (refresh) {
        _salaryRecords = null;
        _currentPage = 0;
        _hasMore = true;
      }

      if (!refresh && !_hasMore) {
        return 'true';
      }

      _status = _currentPage == 0 ? SalaryStatus.loading : SalaryStatus.loadingMore;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      // Build query parameters
      final queryParams = <String, String>{
        'month': month.toString(),
        'year': year.toString(),
      };
      
      if (employeeType != null && employeeType.isNotEmpty) {
        queryParams['employeeType'] = employeeType;
      }
      
      if (employeeId != null && employeeId.isNotEmpty) {
        queryParams['employeeId'] = employeeId;
      }
      
      if (paymentStatus != null && paymentStatus.isNotEmpty) {
        queryParams['paymentStatus'] = paymentStatus;
      }

      final response = await getFunction(
        Api.salary.getSalaryRecords,
        queryParams: queryParams,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      final recordsResponse = SalaryRecordsResponse.fromJson(response);
      
      if (refresh) {
        _salaryRecords = recordsResponse.data;
      } else {
        _salaryRecords ??= [];
        _salaryRecords!.addAll(recordsResponse.data);
      }

      _hasMore = recordsResponse.data.length >= _itemsPerPage;
      _currentPage++;
      
      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== GET SALARY SUMMARY ==============
  Future<String> fetchSalarySummary({
    required int month,
    required int year,
    required String employeeType, // 'teacher' or 'staff'
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final queryParams = {
        'month': month.toString(),
        'year': year.toString(),
        'employeeType': employeeType,
      };

      final response = await getFunction(
        Api.salary.getSalarySummary,
        queryParams: queryParams,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      final summaryResponse = SalarySummaryResponse.fromJson(response);
      _salarySummary = summaryResponse.data;
      
      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== GET PENDING PAYMENTS ==============
  Future<String> fetchPendingPayments({
    required String employeeType,
    required int month,
    required int year,
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final queryParams = {
        'employeeType': employeeType,
        'month': month.toString(),
        'year': year.toString(),
      };

      final response = await getFunction(
        Api.salary.getPendingPayments,
        queryParams: queryParams,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _pendingPaymentsResponse = PendingPaymentsResponse.fromJson(response);
      
      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== PROCESS SALARY PAYMENT ==============
  Future<String> processSalaryPayment({
    required String salaryId,
    required String paymentMethod, // 'bank_transfer', 'cash', 'cheque'
    String? remarks,
    String? transactionId,
    String? paymentDate,
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = ProcessPaymentRequest(
        paymentMethod: paymentMethod,
        remarks: remarks,
        transactionId: transactionId,
        paymentDate: paymentDate,
      );

      final response = await putFunction(
        body: body.toJson(),
        api:Api.salary.processSalaryPayment(salaryId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== GET EMPLOYEE SALARY HISTORY ==============
  Future<String> fetchEmployeeSalaryHistory({
    required String employeeId,
    required String employeeType,
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final queryParams = {
        'employeeType': employeeType,
      };

      final response = await getFunction(
        Api.salary.getEmployeeSalaryHistory(employeeId),
        queryParams: queryParams,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _employeeSalaryHistory = EmployeeSalaryHistory.fromJson(response['data'] as Map<String, dynamic>? ?? {});
      
      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== UPDATE SALARY RECORD ==============
  Future<String> updateSalaryRecord({
    required String salaryId,
    double? bonus,
    double? deductions,
    String? remarks,
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = UpdateSalaryRecordRequest(
        bonus: bonus,
        deductions: deductions,
        remarks: remarks,
      );

      final response = await putFunction(
        body: body.toJson(),
        api: Api.salary.updateSalaryRecord(salaryId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== CANCEL SALARY PAYMENT ==============
  Future<String> cancelSalaryPayment({
    required String salaryId,
    required String reason,
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = CancelPaymentRequest(reason: reason);

      final response = await putFunction(
        body: body.toJson(),
        api: Api.salary.cancelSalaryPayment(salaryId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== GET SALARY ADJUSTMENTS ==============
  Future<String> fetchSalaryAdjustments({
    required String employeeId,
    required String employeeType,
    required BuildContext context,
  }) async {
    try {
      _status = SalaryStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final queryParams = {
        'employeeType': employeeType,
      };

      final response = await getFunction(
        Api.salary.getSalaryAdjustments(employeeId),
        queryParams: queryParams,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      final adjustmentsResponse = SalaryAdjustmentsResponse.fromJson(response);
      _salaryAdjustments = adjustmentsResponse.data;
      
      _errorMessage = null;
      _status = SalaryStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== RESET METHODS ==============
  void resetSalaryRecords() {
    _salaryRecords = null;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  void resetSalarySummary() {
    _salarySummary = null;
    notifyListeners();
  }

  void resetPendingPayments() {
    _pendingPaymentsResponse = null;
    notifyListeners();
  }

  void resetEmployeeSalaryHistory() {
    _employeeSalaryHistory = null;
    notifyListeners();
  }

  void resetSalaryAdjustments() {
    _salaryAdjustments = null;
    notifyListeners();
  }

  void resetAll() {
    _status = SalaryStatus.initial;
    _errorMessage = null;
    _salaryRecords = null;
    _salarySummary = null;
    _pendingPaymentsResponse = null;
    _employeeSalaryHistory = null;
    _salaryAdjustments = null;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  /// ============== UTILITY METHODS ==============
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  List<SalaryRecord> searchSalaryRecords(String query) {
    if (query.isEmpty || _salaryRecords == null) {
      return _salaryRecords ?? [];
    }

    final searchQuery = query.toLowerCase();
    return _salaryRecords!.where((record) {
      return record.employeeName.toLowerCase().contains(searchQuery) ||
             record.employeeId.toLowerCase().contains(searchQuery);
    }).toList();
  }

  List<SalaryRecord> filterByPaymentStatus(String status) {
    if (_salaryRecords == null) return [];
    return _salaryRecords!.where((record) => record.paymentStatus == status).toList();
  }

  bool _isSuccessResponse(Map<String, dynamic> response) {
    return response['success'] == true;
  }

  bool _isTokenExpired(Map<String, dynamic> response, BuildContext context) {
    if (response['msg'] == 'User not found' ||
        response['msg'] == 'Token Expired' ||
        response['msg'] == 'Invalid token') {
      _status = SalaryStatus.loaded;
      _errorMessage = 'session expired';
      notifyListeners();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const TokenExpiredDialoge(),
        );
      });
      return true;
    }
    return false;
  }

  void _handleError(Map<String, dynamic> response) {
    final errors = response['errors'] as List<dynamic>?;
    _errorMessage = errors != null && errors.isNotEmpty
        ? errors.join('\n')
        : response['message'] ?? 'Failed to load data';
    _status = SalaryStatus.error;
    notifyListeners();
  }

  void _handleException(dynamic e) {
    _status = SalaryStatus.error;
    _errorMessage = getFriendlyErrorMessage(e);
    notifyListeners();
  }
}