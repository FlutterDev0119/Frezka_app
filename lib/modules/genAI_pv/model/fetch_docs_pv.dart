class FetchDocsClinical {
  final Map<String, List<String>>? output;

  FetchDocsClinical({this.output});
  factory FetchDocsClinical.fromJson(Map<String, dynamic> json) {
    final rawOutput = json['output'] as Map<String, dynamic>?;
    return FetchDocsClinical(
      output: rawOutput?.map(
        (key, value) => MapEntry(key, List<String>.from(value ?? [])),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': output != null
          ? {
              'Investigator Analysis': output!['Investigator Analysis'],
              'Site Analysis': output!['Site Analysis'],
              'Trial Analysis': output!['Trial Analysis'],
            }
          : null,
    };
  }
}
