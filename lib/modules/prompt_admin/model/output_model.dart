class NewPromptInherit {
  final String output;

  NewPromptInherit({required this.output});

  factory NewPromptInherit.fromJson(Map<String, dynamic> json) {
    return NewPromptInherit(
      output: json['output'] ?? '',
    );
  }
}
