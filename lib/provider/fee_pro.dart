// lib/provider/fee_provider.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/token_expired_dialoge.dart';
import 'package:school_management_demo/models/fee_model.dart';
import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';

enum FeeStatus { initial, loading, loaded, error }

class FeeProvider extends ChangeNotifier {
  // State
  FeeStatus _status = FeeStatus.initial;
  String? _errorMessage;

  // Data
  List<FeeStructure>? _feeStructures;
  List<Invoice>? _invoices;
  InvoiceWithDetails? _selectedInvoice;
  StudentFeeDetails? _studentFeeDetails;
  PaymentHistoryResponse? _paymentHistory;
  FeeDashboardStats? _dashboardStats;
  Payment? _selectedPayment;

  // Getters - State
  FeeStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == FeeStatus.loading;
  bool get isLoaded => _status == FeeStatus.loaded;
  bool get hasError => _status == FeeStatus.error;

  // Getters - Data
  List<FeeStructure>? get feeStructures => _feeStructures;
  List<Invoice>? get invoices => _invoices;
  InvoiceWithDetails? get selectedInvoice => _selectedInvoice;
  StudentFeeDetails? get studentFeeDetails => _studentFeeDetails;
  PaymentHistoryResponse? get paymentHistory => _paymentHistory;
  FeeDashboardStats? get dashboardStats => _dashboardStats;
  Payment? get selectedPayment => _selectedPayment;

  
  Future<String> fetchFeeStructures({
    required BuildContext context,
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        _feeStructures = null;
      }

      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

     
      final response = await getFunction(
        '${Api().base}payments/fees/structures',
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to load fee structures';
      }

      final structuresResponse = FeeStructuresResponse.fromJson(response);
      _feeStructures = structuresResponse.data;

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== INVOICE MANAGEMENT ====================

  /// Create monthly invoice
  Future<String> createMonthlyInvoice({
    required String studentId,
    required String feeStructureId,
    required int month,
    required int year,
    required String dueDate,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = {
        'studentId': studentId,
        'feeStructureId': feeStructureId,
        'month': month,
        'year': year,
        'dueDate': dueDate,
      };

      log('CREATE MONTHLY INVOICE BODY => $body');

      final response = await postFunction(
        body,
        Api.fees.createMonthlyInvoice,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to create invoice';
      }

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Create annual invoice
  Future<String> createAnnualInvoice({
    required String studentId,
    required String feeStructureId,
    required String academicYear,
    required String dueDate,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = {
        'studentId': studentId,
        'feeStructureId': feeStructureId,
        'academicYear': academicYear,
        'dueDate': dueDate,
      };

      log('CREATE ANNUAL INVOICE BODY => $body');

      final response = await postFunction(
        body,
        Api.fees.createAnnualInvoice,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to create invoice';
      }

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Get invoice by ID with full details
  Future<String> getInvoiceById({
    required String invoiceId,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.fees.getInvoiceById(invoiceId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to load invoice';
      }

      _selectedInvoice = InvoiceWithDetails.fromJson(response['data']);

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Cancel invoice
  Future<String> cancelInvoice({
    required String invoiceId,
    required String reason,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = {'reason': reason};

      log('CANCEL INVOICE BODY => $body');

      final response = await putFunction(
        body: body,
        api: Api.fees.cancelInvoice(invoiceId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to cancel invoice';
      }

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== DISCOUNTS & FINES ====================

  /// Apply discount to invoice
  Future<String> applyDiscount({
    required String invoiceId,
    required String discountType, // 'percentage' or 'flat'
    required double value,
    required String reason,
    String? notes,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = {
        'invoiceId': invoiceId,
        'discountType': discountType,
        'value': value,
        'reason': reason,
        if (notes != null) 'notes': notes,
      };

      log('APPLY DISCOUNT BODY => $body');

      final response = await postFunction(
        body,
        Api.fees.applyDiscount,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to apply discount';
      }

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Apply fine to invoice
  Future<String> applyFine({
    required String invoiceId,
    required String fineType, // 'late_fee', 'penalty', 'other'
    required double amount,
    required String reason,
    String? notes,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = {
        'invoiceId': invoiceId,
        'fineType': fineType,
        'amount': amount,
        'reason': reason,
        if (notes != null) 'notes': notes,
      };

      log('APPLY FINE BODY => $body');

      final response = await postFunction(
        body,
        Api.fees.applyFine,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to apply fine';
      }

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== PAYMENT ====================

  /// Record payment (FULL PAYMENT ONLY)
  Future<String> recordPayment({
    required String invoiceId,
    required double amount,
    required String paymentMethod, // 'cash', 'card', 'bank_transfer', 'cheque', 'online'
    String? referenceNumber,
    String? notes,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = {
        'invoiceId': invoiceId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        if (referenceNumber != null) 'referenceNumber': referenceNumber,
        if (notes != null) 'notes': notes,
      };

      log('RECORD PAYMENT BODY => $body');

      final response = await postFunction(
        body,
        Api.fees.recordPayment,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to record payment';
      }

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Get payment history
  Future<String> getPaymentHistory({
    int page = 1,
    int limit = 20,
    String? startDate,
    String? endDate,
    String? studentId,
    String? paymentMethod,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final uri = Uri.parse(Api.fees.getPaymentHistory);
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;
      if (studentId != null) queryParams['studentId'] = studentId;
      if (paymentMethod != null) queryParams['paymentMethod'] = paymentMethod;

      final finalUri = uri.replace(queryParameters: queryParams);

      log('GET PAYMENT HISTORY URL => ${finalUri.toString()}');

      final response = await getFunction(
        finalUri.toString(),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to load payment history';
      }

      _paymentHistory = PaymentHistoryResponse.fromJson(response);

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Get payment details
  Future<String> getPaymentDetails({
    required String paymentId,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.fees.getPaymentDetails(paymentId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to load payment details';
      }

      _selectedPayment = Payment.fromJson(response['data']['payment']);

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== STUDENT QUERIES ====================

  /// Get student fee details
  Future<String> getStudentFeeDetails({
    required String studentId,
    String? academicYear,
    String? status,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.fees.getStudentFeeDetails(
          studentId,
          academicYear: academicYear,
          status: status,
        ),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to load student fee details';
      }

      _studentFeeDetails = StudentFeeDetails.fromJson(response['data']);

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== DASHBOARD ====================

  /// Get dashboard statistics
  Future<String> getDashboardStats({
    String? academicYear,
    int? month,
    int? year,
    required BuildContext context,
  }) async {
    try {
      _status = FeeStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final uri = Uri.parse(Api.fees.getDashboardStats);
      final queryParams = <String, String>{};

      if (academicYear != null) queryParams['academicYear'] = academicYear;
      if (month != null) queryParams['month'] = month.toString();
      if (year != null) queryParams['year'] = year.toString();

      final finalUri = uri.replace(queryParameters: queryParams);

      log('GET DASHBOARD STATS URL => ${finalUri.toString()}');

      final response = await getFunction(
        finalUri.toString(),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'Failed to load dashboard stats';
      }

      _dashboardStats = FeeDashboardStats.fromJson(response['data']);

      _errorMessage = null;
      _status = FeeStatus.loaded;
      notifyListeners();

      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== HELPER METHODS ====================

  /// Filter invoices by status
  List<Invoice> filterInvoicesByStatus(InvoiceStatus status) {
    if (_studentFeeDetails == null) return [];
    return _studentFeeDetails!.invoices
        .where((i) => i.status == status)
        .toList();
  }

  /// Get pending invoices
  List<Invoice> getPendingInvoices() {
    if (_studentFeeDetails == null) return [];
    return _studentFeeDetails!.invoices
        .where((i) => i.status == InvoiceStatus.pending)
        .toList();
  }

  /// Get overdue invoices
  List<Invoice> getOverdueInvoices() {
    if (_studentFeeDetails == null) return [];
    return _studentFeeDetails!.invoices
        .where((i) => i.status == InvoiceStatus.overdue)
        .toList();
  }

  /// Get paid invoices
  List<Invoice> getPaidInvoices() {
    if (_studentFeeDetails == null) return [];
    return _studentFeeDetails!.invoices
        .where((i) => i.status == InvoiceStatus.paid)
        .toList();
  }

  // ==================== RESET METHODS ====================

  void resetFeeStructures() {
    _feeStructures = null;
    notifyListeners();
  }

  void resetInvoices() {
    _invoices = null;
    notifyListeners();
  }

  void resetSelectedInvoice() {
    _selectedInvoice = null;
    notifyListeners();
  }

  void resetStudentFeeDetails() {
    _studentFeeDetails = null;
    notifyListeners();
  }

  void resetPaymentHistory() {
    _paymentHistory = null;
    notifyListeners();
  }

  void resetDashboardStats() {
    _dashboardStats = null;
    notifyListeners();
  }

  void resetAll() {
    _status = FeeStatus.initial;
    _errorMessage = null;
    _feeStructures = null;
    _invoices = null;
    _selectedInvoice = null;
    _studentFeeDetails = null;
    _paymentHistory = null;
    _dashboardStats = null;
    _selectedPayment = null;
    notifyListeners();
  }

  // ==================== UTILITY METHODS ====================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool _isSuccessResponse(Map<String, dynamic> response) {
    return response['success'] == true;
  }

  bool _isTokenExpired(Map<String, dynamic> response, BuildContext context) {
    if (response['msg'] == 'User not found' ||
        response['msg'] == 'Token Expired' ||
        response['msg'] == 'Invalid token') {
      _status = FeeStatus.loaded;
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
    _status = FeeStatus.error;
    notifyListeners();
  }

  void _handleException(dynamic e) {
    _status = FeeStatus.error;
    _errorMessage = getFriendlyErrorMessage(e);
    notifyListeners();
  }
}