class NarrativeGenerationRes {
  final String output;
  final String prompt;

  NarrativeGenerationRes({
    required this.output,
    required this.prompt,
  });

  factory NarrativeGenerationRes.fromJson(Map<String, dynamic> json) {
    return NarrativeGenerationRes(
      output: json['output'] as String,
      prompt: json['prompt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': output,
      'prompt': prompt,
    };
  }
}
