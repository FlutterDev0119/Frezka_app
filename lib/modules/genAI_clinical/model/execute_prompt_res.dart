class ExecutePromptRes {
  final String output;
  final String prompt;
  final String traceId;

  ExecutePromptRes({
    required this.output,
    required this.prompt,
    required this.traceId,
  });

  factory ExecutePromptRes.fromJson(Map<String, dynamic> json) {
    return ExecutePromptRes(
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
