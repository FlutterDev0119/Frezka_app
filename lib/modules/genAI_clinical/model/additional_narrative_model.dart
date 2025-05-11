class AdditionalNarrativeRes {
  final String output;
  final String prompt;

  AdditionalNarrativeRes({
    required this.output,
    required this.prompt,
  });

  factory AdditionalNarrativeRes.fromJson(Map<String, dynamic> json) {
    return AdditionalNarrativeRes(
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
