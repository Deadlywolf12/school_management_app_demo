// lib/models/fee_model.dart

// ============================================
// ENUMS
// ============================================

enum FeeType { monthly, annual }

enum InvoiceStatus { pending, paid, overdue, cancelled }

enum PaymentStatus { completed, failed, refunded }

enum DiscountType { percentage, flat }

enum FineType { lateFee, penalty, other }

enum PaymentMethod { cash, card, bankTransfer, cheque, online }

enum TransactionType {
  invoiceCreated,
  discountApplied,
  fineApplied,
  paymentReceived,
  paymentFailed,
  invoiceCancelled,
  refundProcessed
}

// ============================================
// FEE STRUCTURE
// ============================================

class FeeStructure {
  final String id;
  final String name;
  final String? description;
  final FeeType feeType;
  final double baseAmount;
  final String? classLevel;
  final String academicYear;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeeStructure({
    required this.id,
    required this.name,
    this.description,
    required this.feeType,
    required this.baseAmount,
    this.classLevel,
    required this.academicYear,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeeStructure.fromJson(Map<String, dynamic> json) {
    return FeeStructure(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      feeType: json['feeType'] == 'monthly' ? FeeType.monthly : FeeType.annual,
      baseAmount: double.tryParse(json['baseAmount']?.toString() ?? '0') ?? 0,
      classLevel: json['classLevel'],
      academicYear: json['academicYear'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'feeType': feeType == FeeType.monthly ? 'monthly' : 'annual',
      'baseAmount': baseAmount.toString(),
      'classLevel': classLevel,
      'academicYear': academicYear,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// ============================================
// INVOICE
// ============================================

class Invoice {
  final String id;
  final String studentId;
  final String feeStructureId;
  final String invoiceNumber;
  final FeeType feeType;
  final String academicYear;
  final int? month;
  final int year;
  final double baseAmount;
  final double discountAmount;
  final double fineAmount;
  final double totalAmount;
  final double paidAmount;
  final InvoiceStatus status;
  final DateTime dueDate;
  final DateTime? paidDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Invoice({
    required this.id,
    required this.studentId,
    required this.feeStructureId,
    required this.invoiceNumber,
    required this.feeType,
    required this.academicYear,
    this.month,
    required this.year,
    required this.baseAmount,
    required this.discountAmount,
    required this.fineAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
    required this.dueDate,
    this.paidDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      feeStructureId: json['feeStructureId'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      feeType: json['feeType'] == 'monthly' ? FeeType.monthly : FeeType.annual,
      academicYear: json['academicYear'] ?? '',
      month: json['month'],
      year: json['year'] ?? 0,
      baseAmount: double.tryParse(json['baseAmount']?.toString() ?? '0') ?? 0,
      discountAmount: double.tryParse(json['discountAmount']?.toString() ?? '0') ?? 0,
      fineAmount: double.tryParse(json['fineAmount']?.toString() ?? '0') ?? 0,
      totalAmount: double.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0,
      paidAmount: double.tryParse(json['paidAmount']?.toString() ?? '0') ?? 0,
      status: _parseInvoiceStatus(json['status']),
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      paidDate: json['paidDate'] != null ? DateTime.tryParse(json['paidDate']) : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  static InvoiceStatus _parseInvoiceStatus(String? status) {
    switch (status) {
      case 'paid':
        return InvoiceStatus.paid;
      case 'overdue':
        return InvoiceStatus.overdue;
      case 'cancelled':
        return InvoiceStatus.cancelled;
      default:
        return InvoiceStatus.pending;
    }
  }
}

// ============================================
// DISCOUNT
// ============================================

class Discount {
  final String id;
  final String invoiceId;
  final DiscountType discountType;
  final double value;
  final double amount;
  final String reason;
  final String appliedBy;
  final DateTime appliedAt;
  final String? notes;

  Discount({
    required this.id,
    required this.invoiceId,
    required this.discountType,
    required this.value,
    required this.amount,
    required this.reason,
    required this.appliedBy,
    required this.appliedAt,
    this.notes,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] ?? '',
      invoiceId: json['invoiceId'] ?? '',
      discountType: json['discountType'] == 'percentage' ? DiscountType.percentage : DiscountType.flat,
      value: double.tryParse(json['value']?.toString() ?? '0') ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      reason: json['reason'] ?? '',
      appliedBy: json['appliedBy'] ?? '',
      appliedAt: DateTime.tryParse(json['appliedAt'] ?? '') ?? DateTime.now(),
      notes: json['notes'],
    );
  }
}

// ============================================
// FINE
// ============================================

class Fine {
  final String id;
  final String invoiceId;
  final FineType fineType;
  final double amount;
  final String reason;
  final String appliedBy;
  final DateTime appliedAt;
  final String? notes;

  Fine({
    required this.id,
    required this.invoiceId,
    required this.fineType,
    required this.amount,
    required this.reason,
    required this.appliedBy,
    required this.appliedAt,
    this.notes,
  });

  factory Fine.fromJson(Map<String, dynamic> json) {
    return Fine(
      id: json['id'] ?? '',
      invoiceId: json['invoiceId'] ?? '',
      fineType: _parseFineType(json['fineType']),
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      reason: json['reason'] ?? '',
      appliedBy: json['appliedBy'] ?? '',
      appliedAt: DateTime.tryParse(json['appliedAt'] ?? '') ?? DateTime.now(),
      notes: json['notes'],
    );
  }

  static FineType _parseFineType(String? type) {
    switch (type) {
      case 'late_fee':
        return FineType.lateFee;
      case 'penalty':
        return FineType.penalty;
      default:
        return FineType.other;
    }
  }
}

// ============================================
// PAYMENT
// ============================================

class Payment {
  final String id;
  final String invoiceId;
  final String studentId;
  final String paymentNumber;
  final double amount;
  final PaymentMethod paymentMethod;
  final String? referenceNumber;
  final PaymentStatus status;
  final String receivedBy;
  final DateTime receivedAt;
  final String? notes;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.invoiceId,
    required this.studentId,
    required this.paymentNumber,
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    required this.status,
    required this.receivedBy,
    required this.receivedAt,
    this.notes,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? '',
      invoiceId: json['invoiceId'] ?? '',
      studentId: json['studentId'] ?? '',
      paymentNumber: json['paymentNumber'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      paymentMethod: _parsePaymentMethod(json['paymentMethod']),
      referenceNumber: json['referenceNumber'],
      status: _parsePaymentStatus(json['status']),
      receivedBy: json['receivedBy'] ?? '',
      receivedAt: DateTime.tryParse(json['receivedAt'] ?? '') ?? DateTime.now(),
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  static PaymentMethod _parsePaymentMethod(String? method) {
    switch (method) {
      case 'card':
        return PaymentMethod.card;
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      case 'cheque':
        return PaymentMethod.cheque;
      case 'online':
        return PaymentMethod.online;
      default:
        return PaymentMethod.cash;
    }
  }

  static PaymentStatus _parsePaymentStatus(String? status) {
    switch (status) {
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.completed;
    }
  }
}

// ============================================
// INVOICE WITH DETAILS
// ============================================

class InvoiceWithDetails {
  final Invoice invoice;
  final StudentInfo student;
  final List<Discount> discounts;
  final List<Fine> fines;
  final Payment? payment;

  InvoiceWithDetails({
    required this.invoice,
    required this.student,
    required this.discounts,
    required this.fines,
    this.payment,
  });

  factory InvoiceWithDetails.fromJson(Map<String, dynamic> json) {
    return InvoiceWithDetails(
      invoice: Invoice.fromJson(json),
      student: StudentInfo.fromJson(json['student'] ?? {}),
      discounts: (json['discounts'] as List<dynamic>?)
          ?.map((d) => Discount.fromJson(d))
          .toList() ?? [],
      fines: (json['fines'] as List<dynamic>?)
          ?.map((f) => Fine.fromJson(f))
          .toList() ?? [],
      payment: json['payment'] != null ? Payment.fromJson(json['payment']) : null,
    );
  }
}

// ============================================
// STUDENT INFO (for fee context)
// ============================================

class StudentInfo {
  final String id;
  final String name;
  final String? classId;
  final int? classNumber;
  final String? section;

  StudentInfo({
    required this.id,
    required this.name,
    this.classId,
    this.classNumber,
    this.section,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      classId: json['classId'],
      classNumber: json['classNumber'],
      section: json['section'],
    );
  }
}

// ============================================
// STUDENT FEE DETAILS
// ============================================

class StudentFeeDetails {
  final StudentInfo student;
  final FeeSummary summary;
  final List<Invoice> invoices;
  final int totalInvoices;

  StudentFeeDetails({
    required this.student,
    required this.summary,
    required this.invoices,
    required this.totalInvoices,
  });

  factory StudentFeeDetails.fromJson(Map<String, dynamic> json) {
    return StudentFeeDetails(
      student: StudentInfo.fromJson(json['student'] ?? {}),
      summary: FeeSummary.fromJson(json['summary'] ?? {}),
      invoices: (json['invoices'] as List<dynamic>?)
          ?.map((i) => Invoice.fromJson(i))
          .toList() ?? [],
      totalInvoices: json['totalInvoices'] ?? 0,
    );
  }
}

// ============================================
// FEE SUMMARY
// ============================================

class FeeSummary {
  final double totalInvoiced;
  final double totalPaid;
  final double totalPending;
  final String collectionRate;

  FeeSummary({
    required this.totalInvoiced,
    required this.totalPaid,
    required this.totalPending,
    required this.collectionRate,
  });

  factory FeeSummary.fromJson(Map<String, dynamic> json) {
    return FeeSummary(
      totalInvoiced: double.tryParse(json['totalInvoiced']?.toString() ?? '0') ?? 0,
      totalPaid: double.tryParse(json['totalPaid']?.toString() ?? '0') ?? 0,
      totalPending: double.tryParse(json['totalPending']?.toString() ?? '0') ?? 0,
      collectionRate: json['collectionRate'] ?? '0%',
    );
  }
}

// ============================================
// DASHBOARD STATS
// ============================================

class FeeDashboardStats {
  final InvoiceStats invoices;
  final AmountStats amounts;
  final String collectionRate;
  final PaymentStats payments;

  FeeDashboardStats({
    required this.invoices,
    required this.amounts,
    required this.collectionRate,
    required this.payments,
  });

  factory FeeDashboardStats.fromJson(Map<String, dynamic> json) {
    return FeeDashboardStats(
      invoices: InvoiceStats.fromJson(json['invoices'] ?? {}),
      amounts: AmountStats.fromJson(json['amounts'] ?? {}),
      collectionRate: json['collectionRate'] ?? '0%',
      payments: PaymentStats.fromJson(json['payments'] ?? {}),
    );
  }
}

class InvoiceStats {
  final int total;
  final int pending;
  final int paid;
  final int overdue;

  InvoiceStats({
    required this.total,
    required this.pending,
    required this.paid,
    required this.overdue,
  });

  factory InvoiceStats.fromJson(Map<String, dynamic> json) {
    return InvoiceStats(
      total: json['total'] ?? 0,
      pending: json['pending'] ?? 0,
      paid: json['paid'] ?? 0,
      overdue: json['overdue'] ?? 0,
    );
  }
}

class AmountStats {
  final double totalInvoiced;
  final double totalPaid;
  final double totalPending;
  final double totalOverdue;

  AmountStats({
    required this.totalInvoiced,
    required this.totalPaid,
    required this.totalPending,
    required this.totalOverdue,
  });

  factory AmountStats.fromJson(Map<String, dynamic> json) {
    return AmountStats(
      totalInvoiced: double.tryParse(json['totalInvoiced']?.toString() ?? '0') ?? 0,
      totalPaid: double.tryParse(json['totalPaid']?.toString() ?? '0') ?? 0,
      totalPending: double.tryParse(json['totalPending']?.toString() ?? '0') ?? 0,
      totalOverdue: double.tryParse(json['totalOverdue']?.toString() ?? '0') ?? 0,
    );
  }
}

class PaymentStats {
  final int total;

  PaymentStats({required this.total});

  factory PaymentStats.fromJson(Map<String, dynamic> json) {
    return PaymentStats(
      total: json['total'] ?? 0,
    );
  }
}

// ============================================
// PAYMENT HISTORY SUMMARY
// ============================================

class PaymentHistorySummary {
  final String id;
  final String studentId;
  final String studentName;
  final String studentClass;
  final String paymentId;
  final String invoiceId;
  final double amount;
  final FeeType feeType;
  final String academicYear;
  final int? month;
  final int year;
  final String paymentMethod;
  final DateTime paymentDate;

  PaymentHistorySummary({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentClass,
    required this.paymentId,
    required this.invoiceId,
    required this.amount,
    required this.feeType,
    required this.academicYear,
    this.month,
    required this.year,
    required this.paymentMethod,
    required this.paymentDate,
  });

  factory PaymentHistorySummary.fromJson(Map<String, dynamic> json) {
    return PaymentHistorySummary(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      studentClass: json['studentClass'] ?? '',
      paymentId: json['paymentId'] ?? '',
      invoiceId: json['invoiceId'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      feeType: json['feeType'] == 'monthly' ? FeeType.monthly : FeeType.annual,
      academicYear: json['academicYear'] ?? '',
      month: json['month'],
      year: json['year'] ?? 0,
      paymentMethod: json['paymentMethod'] ?? '',
      paymentDate: DateTime.tryParse(json['paymentDate'] ?? '') ?? DateTime.now(),
    );
  }
}

// ============================================
// RESPONSE WRAPPERS
// ============================================

class FeeStructuresResponse {
  final bool success;
  final List<FeeStructure> data;

  FeeStructuresResponse({
    required this.success,
    required this.data,
  });

  factory FeeStructuresResponse.fromJson(Map<String, dynamic> json) {
    return FeeStructuresResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => FeeStructure.fromJson(item))
          .toList() ?? [],
    );
  }
}

class InvoicesResponse {
  final bool success;
  final List<Invoice> data;

  InvoicesResponse({
    required this.success,
    required this.data,
  });

  factory InvoicesResponse.fromJson(Map<String, dynamic> json) {
    return InvoicesResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Invoice.fromJson(item))
          .toList() ?? [],
    );
  }
}

class PaymentHistoryResponse {
  final bool success;
  final List<PaymentHistorySummary> payments;
  final PaymentSummary summary;
  final Pagination pagination;

  PaymentHistoryResponse({
    required this.success,
    required this.payments,
    required this.summary,
    required this.pagination,
  });

  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return PaymentHistoryResponse(
      success: json['success'] ?? false,
      payments: (data['payments'] as List<dynamic>?)
          ?.map((item) => PaymentHistorySummary.fromJson(item))
          .toList() ?? [],
      summary: PaymentSummary.fromJson(data['summary'] ?? {}),
      pagination: Pagination.fromJson(data['pagination'] ?? {}),
    );
  }
}

class PaymentSummary {
  final double totalAmount;
  final int totalPayments;

  PaymentSummary({
    required this.totalAmount,
    required this.totalPayments,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      totalAmount: double.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0,
      totalPayments: json['totalPayments'] ?? 0,
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}