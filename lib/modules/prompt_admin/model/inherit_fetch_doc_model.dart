class PromptInherit {
  final List<String> adverseEventReporting;
  final List<String> aggregateReporting;
  final List<String> miscellaneous;
  final List<String> pvAgreements;
  final List<String> reconciliation;
  final List<String> riskManagement;

  PromptInherit({
    required this.adverseEventReporting,
    required this.aggregateReporting,
    required this.miscellaneous,
    required this.pvAgreements,
    required this.reconciliation,
    required this.riskManagement,
  });

  factory PromptInherit.fromJson(Map<String, dynamic> json) {
    final output = json['output'];
    return PromptInherit(
      adverseEventReporting: List<String>.from(output['Adverse Event Reporting']),
      aggregateReporting: List<String>.from(output['Aggregate Reporting']),
      miscellaneous: List<String>.from(output['Miscellaneous']),
      pvAgreements: List<String>.from(output['PV Agreements']),
      reconciliation: List<String>.from(output['Reconciliation']),
      riskManagement: List<String>.from(output['Risk Management']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': {
        'Adverse Event Reporting': adverseEventReporting,
        'Aggregate Reporting': aggregateReporting,
        'Miscellaneous': miscellaneous,
        'PV Agreements': pvAgreements,
        'Reconciliation': reconciliation,
        'Risk Management': riskManagement,
      },
    };
  }
}
