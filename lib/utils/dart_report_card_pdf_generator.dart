import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:school_management_demo/models/exam_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class DartReportCardPDFGenerator {
  /// Generate PDF report card using pure Dart (no Python required)
  static Future<String> generateReportCard({
    required StudentExamReport report,
    required String studentName,
  }) async {
    try {
      // Request storage permission for Android
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }
      }

      // Create PDF document
      final pdf = pw.Document();

      // Get current date
      final dateFormat = DateFormat('MMMM dd, yyyy');
      final currentDate = dateFormat.format(DateTime.now());

      // Add pages to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
            // Header
            _buildHeader(studentName, report.studentId, currentDate),
            pw.SizedBox(height: 30),

            // Overall Summary
            _buildSummarySection(report.summary),
            pw.SizedBox(height: 30),

            // Subject Results Table
            _buildResultsTable(report.results),
            pw.SizedBox(height: 30),

            // Remarks Section
            if (_hasRemarks(report.results)) ...[
              _buildRemarksSection(report.results),
              pw.SizedBox(height: 30),
            ],

            // Spacer to push signatures to bottom
            pw.Spacer(),

            // Signature Section
            _buildSignatureSection(),
          ],
          footer: (context) => _buildFooter(context),
        ),
      );

      // Save PDF
      final outputDir = await _getOutputDirectory();
      final sanitizedName = studentName.replaceAll(RegExp(r'[^\w\s-]'), '');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final pdfPath = '${outputDir.path}/ReportCard_${sanitizedName}_$timestamp.pdf';

      final file = File(pdfPath);
      await file.writeAsBytes(await pdf.save());

      return pdfPath;
    } catch (e) {
      throw Exception('Failed to generate PDF: ${e.toString()}');
    }
  }

  static pw.Widget _buildHeader(
    String studentName,
    String studentId,
    String date,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue700,
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                'STUDENT REPORT CARD',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Generated on: $date',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Container(
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.blue700, width: 2),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Student Name:',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    studentName,
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Student ID:',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    studentId,
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSummarySection(StudentSummary summary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'OVERALL PERFORMANCE SUMMARY',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey600),
          children: [
            // Header row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue700),
              children: [
                _buildTableCell('Metric', isHeader: true),
                _buildTableCell('Value', isHeader: true),
              ],
            ),
            // Data rows
            _buildSummaryRow('Total Subjects', summary.totalSubjects.toString()),
            _buildSummaryRow('Passed Subjects', summary.passedSubjects.toString(), 
                color: PdfColors.green100),
            _buildSummaryRow('Failed Subjects', summary.failedSubjects.toString(),
                color: PdfColors.red100),
            _buildSummaryRow('Absent Subjects', summary.absentSubjects.toString(),
                color: PdfColors.orange100),
            _buildSummaryRow('Total Marks Obtained', 
                '${summary.totalObtained.toStringAsFixed(0)}'),
            _buildSummaryRow('Total Marks', 
                '${summary.totalMarks.toStringAsFixed(0)}'),
            _buildSummaryRow('Overall Percentage', 
                '${summary.overallPercentage.toStringAsFixed(2)}%',
                color: PdfColors.blue100),
            _buildSummaryRow('Overall Grade', summary.overallGrade,
                color: PdfColors.blue100),
          ],
        ),
      ],
    );
  }

  static pw.TableRow _buildSummaryRow(
    String label,
    String value, {
    PdfColor? color,
  }) {
    return pw.TableRow(
      decoration: color != null ? pw.BoxDecoration(color: color) : null,
      children: [
        _buildTableCell(label),
        _buildTableCell(value),
      ],
    );
  }

  static pw.Widget _buildResultsTable(List<ExamResult> results) {
    if (results.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(20),
        child: pw.Center(
          child: pw.Text(
            'No exam results available',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey,
            ),
          ),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'SUBJECT-WISE PERFORMANCE',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey600),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1.5),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(1.5),
            4: const pw.FlexColumnWidth(1),
            5: const pw.FlexColumnWidth(1.2),
          },
          children: [
            // Header row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue700),
              children: [
                _buildTableCell('Subject ID', isHeader: true),
                _buildTableCell('Obtained', isHeader: true),
                _buildTableCell('Total', isHeader: true),
                _buildTableCell('Percentage', isHeader: true),
                _buildTableCell('Grade', isHeader: true),
                _buildTableCell('Status', isHeader: true),
              ],
            ),
            // Data rows
            ...results.map((result) => _buildResultRow(result)),
          ],
        ),
      ],
    );
  }

  static pw.TableRow _buildResultRow(ExamResult result) {
    PdfColor bgColor;
    PdfColor textColor;

    switch (result.status.toLowerCase()) {
      case 'pass':
        bgColor = PdfColors.green50;
        textColor = PdfColors.green900;
        break;
      case 'fail':
        bgColor = PdfColors.red50;
        textColor = PdfColors.red900;
        break;
      case 'absent':
        bgColor = PdfColors.orange50;
        textColor = PdfColors.orange900;
        break;
      default:
        bgColor = PdfColors.white;
        textColor = PdfColors.black;
    }

    return pw.TableRow(
      decoration: pw.BoxDecoration(color: bgColor),
      children: [
        _buildTableCell(result.subjectId),
        _buildTableCell(result.obtainedMarks.toStringAsFixed(0)),
        _buildTableCell(result.totalMarks.toStringAsFixed(0)),
        _buildTableCell('${result.percentage.toStringAsFixed(1)}%'),
        _buildTableCell(result.grade.isNotEmpty ? result.grade : 'N/A'),
        _buildTableCell(
          result.status.toUpperCase(),
          textColor: textColor,
          fontWeight: pw.FontWeight.bold,
        ),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    PdfColor? textColor,
    pw.FontWeight? fontWeight,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : fontWeight,
          color: isHeader ? PdfColors.white : (textColor ?? PdfColors.black),
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static bool _hasRemarks(List<ExamResult> results) {
    return results.any((result) => 
        result.remarks != null && result.remarks!.isNotEmpty);
  }

  static pw.Widget _buildRemarksSection(List<ExamResult> results) {
    final remarksResults = results
        .where((r) => r.remarks != null && r.remarks!.isNotEmpty)
        .toList();

    if (remarksResults.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'REMARKS',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        ...remarksResults.map((result) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 100,
                child: pw.Text(
                  '${result.subjectId}:',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  result.remarks!,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  static pw.Widget _buildSignatureSection() {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 40),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSignatureBox('Class Teacher'),
          _buildSignatureBox('Principal'),
          _buildSignatureBox('Parent Signature'),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatureBox(String label) {
    return pw.Column(
      children: [
        pw.Container(
          width: 150,
          height: 1,
          color: PdfColors.black,
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
          ),
          pw.Text(
            'School Management System',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
          ),
        ],
      ),
    );
  }

  static Future<Directory> _getOutputDirectory() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory;
      }
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        return externalDir;
      }
    }
    return await getApplicationDocumentsDirectory();
  }
}
