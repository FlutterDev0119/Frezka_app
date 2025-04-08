class PromptInherit {
  final Map<String, List<String>> output;

  PromptInherit({required this.output});

  factory PromptInherit.fromJson(Map<String, dynamic> json) {
    return PromptInherit(
      output: Map<String, List<String>>.from(
        json['output'].map((key, value) => MapEntry(key, List<String>.from(value))),
      ),
    );
  }

  Map<String, dynamic> toJson() => {'output': output};
}
