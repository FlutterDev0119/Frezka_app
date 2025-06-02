class AdditionalNarrativeRes {
  final String output;
  final String prompt;
  final String traceId;

  AdditionalNarrativeRes({
    required this.output,
    required this.prompt,
    required this.traceId,
  });

  factory AdditionalNarrativeRes.fromJson(Map<String, dynamic> json) {
    return AdditionalNarrativeRes(
      output: json['output'] as String,
      prompt: json['prompt'] as String,
      traceId: json['trace_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': output,
      'prompt': prompt,
      'trace_id': traceId,
    };
  }
}
