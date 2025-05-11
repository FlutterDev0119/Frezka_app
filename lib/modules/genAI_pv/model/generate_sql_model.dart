// class GenerateSQL {
//   final String sqlQuery;
//   final List<List<dynamic>> data;
//
//   GenerateSQL({required this.sqlQuery, required this.data});
//
//   factory GenerateSQL.fromJson(Map<String, dynamic> json) {
//     return GenerateSQL(
//       sqlQuery: json['sql_query'],
//       data: (json['data'] as List)
//           .map((innerList) => (innerList as List).map((item) {
//         if (item is Map<String, dynamic>) {
//           return SafetyReport.fromJson(item);
//         }
//         return item; // Keep as string (the XML string)
//       }).toList())
//           .toList(),
//     );
//   }
// }
//
// class SafetyReport {
//   final String safetyReportId;
//   final String initialReceiptDate;
//   final String awarenessDate;
//   final String study;
//   final String primaryProduct;
//   final String primaryEvent;
//   final String occurCountry;
//   final String seriousness;
//
//   SafetyReport({
//     required this.safetyReportId,
//     required this.initialReceiptDate,
//     required this.awarenessDate,
//     required this.study,
//     required this.primaryProduct,
//     required this.primaryEvent,
//     required this.occurCountry,
//     required this.seriousness,
//   });
//
//   factory SafetyReport.fromJson(Map<String, dynamic> json) {
//     return SafetyReport(
//       safetyReportId: json['Safety Report ID'] ?? '',
//       initialReceiptDate: json['Initial Receipt Date'] ?? '',
//       awarenessDate: json['Awareness Date'] ?? '',
//       study: json['Study'] ?? '',
//       primaryProduct: json['Primary Product'] ?? '',
//       primaryEvent: json['Primary Event'] ?? '',
//       occurCountry: json['Occur Country'] ?? '',
//       seriousness: json['Seriousness'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'Safety Report ID': safetyReportId,
//     'Initial Receipt Date': initialReceiptDate,
//     'Awareness Date': awarenessDate,
//     'Study': study,
//     'Primary Product': primaryProduct,
//     'Primary Event': primaryEvent,
//     'Occur Country': occurCountry,
//     'Seriousness': seriousness,
//   };
// }
// // class SafetyReportApiResponse {
// //   final String sqlQuery;
// //   final List<SafetyReport> reports;
// //
// //   SafetyReportApiResponse({
// //     required this.sqlQuery,
// //     required this.reports,
// //   });
// //
// //   factory SafetyReportApiResponse.fromJson(Map<String, dynamic> json) {
// //     return SafetyReportApiResponse(
// //       sqlQuery: json['sql_query'] ?? '',
// //       reports: (json['data'] as List)
// //           .map((item) => SafetyReport.fromList(item as List))
// //           .toList(),
// //     );
// //   }
// // }
// // class SafetyReport {
// //   final Map<String, String> details;
// //   final String rawXml;
// //
// //   SafetyReport({
// //     required this.details,
// //     required this.rawXml,
// //   });
// //
// //   factory SafetyReport.fromList(List<dynamic> list) {
// //     if (list.length != 2) {
// //       throw FormatException('Expected a list of length 2 for SafetyReport');
// //     }
// //
// //     final Map<String, dynamic> rawMap = list[0] as Map<String, dynamic>;
// //     final Map<String, String> details = rawMap.map(
// //           (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
// //     );
// //
// //     final String xml = list[1] as String;
// //
// //     return SafetyReport(details: details, rawXml: xml);
// //   }
// // }
class GenerateSQLRes {
  final String sqlQuery;
  final List<SqlDataItem> data;

  GenerateSQLRes({required this.sqlQuery, required this.data});

  factory GenerateSQLRes.fromJson(Map<String, dynamic> json) {
    return GenerateSQLRes(
      sqlQuery: json['sql_query'],
      data: (json['data'] as List)
          .map((item) => SqlDataItem.fromJson(item))
          .toList(),
    );
  }
}

class SqlDataItem {
  final Map<String, dynamic> reportMeta;
  final String xmlContent;

  SqlDataItem({required this.reportMeta, required this.xmlContent});

  factory SqlDataItem.fromJson(List<dynamic> json) {
    return SqlDataItem(
      reportMeta: Map<String, dynamic>.from(json[0]),
      xmlContent: json[1],
    );
  }
}
