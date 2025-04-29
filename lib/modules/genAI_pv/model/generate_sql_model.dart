class GenerateSQL {
  final String sqlQuery;
  final List<List<dynamic>> data;

  GenerateSQL({required this.sqlQuery, required this.data});

  factory GenerateSQL.fromJson(Map<String, dynamic> json) {
    return GenerateSQL(
      sqlQuery: json['sql_query'],
      data: (json['data'] as List)
          .map((innerList) => (innerList as List).map((item) {
        if (item is Map<String, dynamic>) {
          return SafetyReport.fromJson(item);
        }
        return item; // Keep as string (the XML string)
      }).toList())
          .toList(),
    );
  }
}

class SafetyReport {
  final String safetyReportId;
  final String initialReceiptDate;
  final String awarenessDate;
  final String study;
  final String primaryProduct;
  final String primaryEvent;
  final String occurCountry;
  final String seriousness;

  SafetyReport({
    required this.safetyReportId,
    required this.initialReceiptDate,
    required this.awarenessDate,
    required this.study,
    required this.primaryProduct,
    required this.primaryEvent,
    required this.occurCountry,
    required this.seriousness,
  });

  factory SafetyReport.fromJson(Map<String, dynamic> json) {
    return SafetyReport(
      safetyReportId: json['Safety Report ID'] ?? '',
      initialReceiptDate: json['Initial Receipt Date'] ?? '',
      awarenessDate: json['Awareness Date'] ?? '',
      study: json['Study'] ?? '',
      primaryProduct: json['Primary Product'] ?? '',
      primaryEvent: json['Primary Event'] ?? '',
      occurCountry: json['Occur Country'] ?? '',
      seriousness: json['Seriousness'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'Safety Report ID': safetyReportId,
    'Initial Receipt Date': initialReceiptDate,
    'Awareness Date': awarenessDate,
    'Study': study,
    'Primary Product': primaryProduct,
    'Primary Event': primaryEvent,
    'Occur Country': occurCountry,
    'Seriousness': seriousness,
  };
}
