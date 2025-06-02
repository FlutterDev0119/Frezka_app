class NarrativeGenerationRes {
  final String output;
  final String prompt;

  NarrativeGenerationRes({
    required this.output,
    required this.prompt,
  });

  factory NarrativeGenerationRes.fromJson(Map<String, dynamic> json) {
    return NarrativeGenerationRes(
      output: json['output']?.toString() ?? '',
      prompt: json['prompt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': output,
      'prompt': prompt,
    };
  }
}
