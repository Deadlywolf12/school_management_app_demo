// lib/models/salary_models.dart

// Generate Monthly Salary Request
class GenerateMonthlySalaryRequest {
  final int month;
  final int year;
  final String employeeType; // 'teacher' or 'staff'

  GenerateMonthlySalaryRequest({
    required this.month,
    required this.year,
    required this.employeeType,
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'employeeType': employeeType,
    };
  }
}

// Add Bonus Request
class AddBonusRequest {
  final String employeeId;
  final String employeeType;
  final String bonusType;
  final double amount;
  final String description;
  final int month;
  final int year;

  AddBonusRequest({
    required this.employeeId,
    required this.employeeType,
    required this.bonusType,
    required this.amount,
    required this.description,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'employeeType': employeeType,
      'bonusType': bonusType,
      'amount': amount,
      'description': description,
      'month': month,
      'year': year,
    };
  }
}

// Add Deduction Request
class AddDeductionRequest {
  final String employeeId;
  final String employeeType;
  final String deductionType;
  final double amount;
  final String description;
  final int month;
  final int year;

  AddDeductionRequest({
    required this.employeeId,
    required this.employeeType,
    required this.deductionType,
    required this.amount,
    required this.description,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'employeeType': employeeType,
      'deductionType': deductionType,
      'amount': amount,
      'description': description,
      'month': month,
      'year': year,
    };
  }
}

// Adjust Salary Request
class AdjustSalaryRequest {
  final String employeeId;
  final String employeeType;
  final double newSalary;
  final String effectiveFrom; // Date string 'YYYY-MM-DD'
  final String reason;

  AdjustSalaryRequest({
    required this.employeeId,
    required this.employeeType,
    required this.newSalary,
    required this.effectiveFrom,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'employeeType': employeeType,
      'newSalary': newSalary,
      'effectiveFrom': effectiveFrom,
      'reason': reason,
    };
  }
}

// Process Payment Request
class ProcessPaymentRequest {
  final String paymentMethod; // 'bank_transfer', 'cash', 'cheque'
  final String? remarks;
  final String? transactionId;
  final String? paymentDate;

  ProcessPaymentRequest({
    required this.paymentMethod,
    this.remarks,
    this.transactionId,
    this.paymentDate,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'paymentMethod': paymentMethod,
    };
    
    if (remarks != null) map['remarks'] = remarks ?? '';
    if (transactionId != null) map['transactionId'] = transactionId?? '';
    if (paymentDate != null) map['paymentDate'] = paymentDate?? '';
    
    return map;
  }
}

// Update Salary Record Request
class UpdateSalaryRecordRequest {
  final double? bonus;
  final double? deductions;
  final String? remarks;

  UpdateSalaryRecordRequest({
    this.bonus,
    this.deductions,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bonus != null) map['bonus'] = bonus;
    if (deductions != null) map['deductions'] = deductions;
    if (remarks != null) map['remarks'] = remarks;
    return map;
  }
}

// Cancel Payment Request
class CancelPaymentRequest {
  final String reason;

  CancelPaymentRequest({required this.reason});

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
    };
  }
}

// Salary Record Model
class SalaryRecord {
  final String id;
  final String employeeId;
  final String employeeType;
  final String employeeName;
  final int month;
  final int year;
  final double baseSalary;
  final double bonus;
  final double deductions;
  final double netSalary;
  final String paymentStatus; // 'pending', 'paid', 'cancelled'
  final DateTime? paymentDate;
  final String? paymentMethod;
  final String? transactionId;
  final String? remarks;
  final String? approvedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  SalaryRecord({
    required this.id,
    required this.employeeId,
    required this.employeeType,
    required this.employeeName,
    required this.month,
    required this.year,
    required this.baseSalary,
    required this.bonus,
    required this.deductions,
    required this.netSalary,
    required this.paymentStatus,
    this.paymentDate,
    this.paymentMethod,
    this.transactionId,
    this.remarks,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SalaryRecord.fromJson(Map<String, dynamic> json) {
    return SalaryRecord(
      id: json['id']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      employeeType: json['employeeType']?.toString() ?? '',
      employeeName: json['employeeName']?.toString() ?? '',
      month: json['month'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
      baseSalary: double.tryParse(json['baseSalary']?.toString() ?? '0') ?? 0,
      bonus: double.tryParse(json['bonus']?.toString() ?? '0') ?? 0,
      deductions: double.tryParse(json['deductions']?.toString() ?? '0') ?? 0,
      netSalary: double.tryParse(json['netSalary']?.toString() ?? '0') ?? 0,
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      paymentDate: json['paymentDate'] != null 
          ? DateTime.tryParse(json['paymentDate'].toString()) 
          : null,
      paymentMethod: json['paymentMethod']?.toString(),
      transactionId: json['transactionId']?.toString(),
      remarks: json['remarks']?.toString(),
      approvedBy: json['approvedBy']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

// Bonus Record Model
class BonusRecord {
  final String id;
  final String employeeId;
  final String employeeType;
  final String bonusType;
  final double amount;
  final String description;
  final int month;
  final int year;
  final String approvedBy;
  final String status;
  final DateTime createdAt;

  BonusRecord({
    required this.id,
    required this.employeeId,
    required this.employeeType,
    required this.bonusType,
    required this.amount,
    required this.description,
    required this.month,
    required this.year,
    required this.approvedBy,
    required this.status,
    required this.createdAt,
  });

  factory BonusRecord.fromJson(Map<String, dynamic> json) {
    return BonusRecord(
      id: json['id']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      employeeType: json['employeeType']?.toString() ?? '',
      bonusType: json['bonusType']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? '',
      month: json['month'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
      approvedBy: json['approvedBy']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

// Deduction Record Model
class DeductionRecord {
  final String id;
  final String employeeId;
  final String employeeType;
  final String deductionType;
  final double amount;
  final String description;
  final int month;
  final int year;
  final String approvedBy;
  final String status;
  final DateTime createdAt;

  DeductionRecord({
    required this.id,
    required this.employeeId,
    required this.employeeType,
    required this.deductionType,
    required this.amount,
    required this.description,
    required this.month,
    required this.year,
    required this.approvedBy,
    required this.status,
    required this.createdAt,
  });

  factory DeductionRecord.fromJson(Map<String, dynamic> json) {
    return DeductionRecord(
      id: json['id']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      employeeType: json['employeeType']?.toString() ?? '',
      deductionType: json['deductionType']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? '',
      month: json['month'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
      approvedBy: json['approvedBy']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

// Salary Adjustment Model
class SalaryAdjustment {
  final String id;
  final String employeeId;
  final String employeeType;
  final double previousSalary;
  final double newSalary;
  final String adjustmentPercentage;
  final DateTime effectiveFrom;
  final String reason;
  final String approvedBy;
  final DateTime createdAt;

  SalaryAdjustment({
    required this.id,
    required this.employeeId,
    required this.employeeType,
    required this.previousSalary,
    required this.newSalary,
    required this.adjustmentPercentage,
    required this.effectiveFrom,
    required this.reason,
    required this.approvedBy,
    required this.createdAt,
  });

  factory SalaryAdjustment.fromJson(Map<String, dynamic> json) {
    return SalaryAdjustment(
      id: json['id']?.toString() ?? '',
      employeeId: json['employeeId']?.toString() ?? '',
      employeeType: json['employeeType']?.toString() ?? '',
      previousSalary: double.tryParse(json['previousSalary']?.toString() ?? '0') ?? 0,
      newSalary: double.tryParse(json['newSalary']?.toString() ?? '0') ?? 0,
      adjustmentPercentage: json['adjustmentPercentage']?.toString() ?? '0.00%',
      effectiveFrom: DateTime.tryParse(json['effectiveFrom']?.toString() ?? '') ?? DateTime.now(),
      reason: json['reason']?.toString() ?? '',
      approvedBy: json['approvedBy']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

// Salary Summary Model
class SalarySummary {
  final int totalEmployees;
  final double totalBaseSalary;
  final double totalBonus;
  final double totalDeductions;
  final double totalNetSalary;
  final double totalPaid;
  final double totalPending;
  final Map<String, int> byStatus;
  final Map<String, int> byType;

  SalarySummary({
    required this.totalEmployees,
    required this.totalBaseSalary,
    required this.totalBonus,
    required this.totalDeductions,
    required this.totalNetSalary,
    required this.totalPaid,
    required this.totalPending,
    required this.byStatus,
    required this.byType,
  });

  factory SalarySummary.fromJson(Map<String, dynamic> json) {
    return SalarySummary(
      totalEmployees: json['totalEmployees'] as int? ?? 0,
      totalBaseSalary: double.tryParse(json['totalBaseSalary']?.toString() ?? '0') ?? 0,
      totalBonus: double.tryParse(json['totalBonus']?.toString() ?? '0') ?? 0,
      totalDeductions: double.tryParse(json['totalDeductions']?.toString() ?? '0') ?? 0,
      totalNetSalary: double.tryParse(json['totalNetSalary']?.toString() ?? '0') ?? 0,
      totalPaid: double.tryParse(json['totalPaid']?.toString() ?? '0') ?? 0,
      totalPending: double.tryParse(json['totalPending']?.toString() ?? '0') ?? 0,
      byStatus: Map<String, int>.from(json['byStatus'] ?? {}),
      byType: Map<String, int>.from(json['byType'] ?? {}),
    );
  }
}

// Employee Salary History Model
class EmployeeSalaryHistory {
  final List<SalaryRecord> records;
  final List<BonusRecord> bonuses;
  final List<DeductionRecord> deductions;
  final Map<String, dynamic> summary;

  EmployeeSalaryHistory({
    required this.records,
    required this.bonuses,
    required this.deductions,
    required this.summary,
  });

  factory EmployeeSalaryHistory.fromJson(Map<String, dynamic> json) {
    return EmployeeSalaryHistory(
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => SalaryRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      bonuses: (json['bonuses'] as List<dynamic>?)
          ?.map((e) => BonusRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      deductions: (json['deductions'] as List<dynamic>?)
          ?.map((e) => DeductionRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      summary: Map<String, dynamic>.from(json['summary'] ?? {}),
    );
  }
}

// Pending Payments Response
class PendingPaymentsResponse {
  final bool success;
  final int count;
  final double totalAmount;
  final List<SalaryRecord> data;

  PendingPaymentsResponse({
    required this.success,
    required this.count,
    required this.totalAmount,
    required this.data,
  });

  factory PendingPaymentsResponse.fromJson(Map<String, dynamic> json) {
    return PendingPaymentsResponse(
      success: json['success'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      totalAmount: double.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SalaryRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

// Salary Records Response
class SalaryRecordsResponse {
  final bool success;
  final int count;
  final List<SalaryRecord> data;

  SalaryRecordsResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory SalaryRecordsResponse.fromJson(Map<String, dynamic> json) {
    return SalaryRecordsResponse(
      success: json['success'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SalaryRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

// Salary Summary Response
class SalarySummaryResponse {
  final bool success;
  final SalarySummary data;

  SalarySummaryResponse({
    required this.success,
    required this.data,
  });

  factory SalarySummaryResponse.fromJson(Map<String, dynamic> json) {
    return SalarySummaryResponse(
      success: json['success'] as bool? ?? false,
      data: SalarySummary.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

// Salary Adjustments Response
class SalaryAdjustmentsResponse {
  final bool success;
  final int count;
  final List<SalaryAdjustment> data;

  SalaryAdjustmentsResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory SalaryAdjustmentsResponse.fromJson(Map<String, dynamic> json) {
    return SalaryAdjustmentsResponse(
      success: json['success'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SalaryAdjustment.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}