class FetchLastQueriesRes {
  final List<String> queries;

  FetchLastQueriesRes({required this.queries});

  factory FetchLastQueriesRes.fromJson(List<dynamic> json) {
    return FetchLastQueriesRes(
      queries: json.map((e) => e.toString()).toList(),
    );
  }

  List<dynamic> toJson() {
    return queries;
  }
}
