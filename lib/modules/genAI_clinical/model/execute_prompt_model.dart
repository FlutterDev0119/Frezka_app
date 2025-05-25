class ExecutePromptRes {
  final String output;
  final String traceId;
  final String prompt;

  ExecutePromptRes({
    required this.output,
    required this.traceId,
    required this.prompt,
  });

  factory ExecutePromptRes.fromJson(Map<String, dynamic> json) {
    return ExecutePromptRes(
      output: json['output'] ?? '',
      traceId: json['trace_id'] ?? '',
      prompt: json['prompt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': output,
      'trace_id': traceId,
      'prompt': prompt,
    };
  }
}
