class FetchClinicalDataRes {
  final List<ClinicalData> data;

  FetchClinicalDataRes({required this.data});

  factory FetchClinicalDataRes.fromJson(List<dynamic> json) {
    return FetchClinicalDataRes(
      data: json.map((e) => ClinicalData.fromJson(e)).toList(),
    );
  }
}

class ClinicalData {
  final String id;
  final String title;
  final String abstractText;
  final String journal;
  final List<String> authors;

  ClinicalData({
    required this.id,
    required this.title,
    required this.abstractText,
    required this.journal,
    required this.authors,
  });

  factory ClinicalData.fromJson(Map<String, dynamic> json) {
    return ClinicalData(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      abstractText: json['abstract'] ?? '',
      journal: json['journal'] ?? '',
      authors: List<String>.from(json['authors'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'abstract': abstractText,
      'journal': journal,
      'authors': authors,
    };
  }
}


// class FetchClinicalDataRes {
//   final List<ClinicalStudy> studies;
//
//   FetchClinicalDataRes({required this.studies});
//
//   factory FetchClinicalDataRes.fromJson(List<dynamic> json) {
//     return FetchClinicalDataRes(
//       studies: json.map((e) => ClinicalStudy.fromJson(e)).toList(),
//     );
//   }
// }
//
// class ClinicalStudy {
//   final ProtocolSection protocolSection;
//   final ResultsSection resultsSection;
//
//   ClinicalStudy({
//     required this.protocolSection,
//     required this.resultsSection,
//   });
//
//   factory ClinicalStudy.fromJson(Map<String, dynamic> json) {
//     return ClinicalStudy(
//       protocolSection: ProtocolSection.fromJson(json['protocolSection']),
//       resultsSection: ResultsSection.fromJson(json['resultsSection']),
//     );
//   }
// }
//
// class ProtocolSection {
//   final SponsorCollaboratorsModule sponsorCollaboratorsModule;
//   final DesignModule designModule;
//   final ArmsInterventionsModule armsInterventionsModule;
//   final OutcomesModule outcomesModule;
//   final EligibilityModule eligibilityModule;
//   final ContactsLocationsModule contactsLocationsModule;
//   final IdentificationModule identificationModule;
//
//   ProtocolSection({
//     required this.sponsorCollaboratorsModule,
//     required this.designModule,
//     required this.armsInterventionsModule,
//     required this.outcomesModule,
//     required this.eligibilityModule,
//     required this.contactsLocationsModule,
//     required this.identificationModule,
//   });
//
//   factory ProtocolSection.fromJson(Map<String, dynamic> json) {
//     return ProtocolSection(
//       sponsorCollaboratorsModule: SponsorCollaboratorsModule.fromJson(json['sponsorCollaboratorsModule']),
//       designModule: DesignModule.fromJson(json['designModule']),
//       armsInterventionsModule: ArmsInterventionsModule.fromJson(json['armsInterventionsModule']),
//       outcomesModule: OutcomesModule.fromJson(json['outcomesModule']),
//       eligibilityModule: EligibilityModule.fromJson(json['eligibilityModule']),
//       contactsLocationsModule: ContactsLocationsModule.fromJson(json['contactsLocationsModule']),
//       identificationModule: IdentificationModule.fromJson(json['identificationModule']),
//     );
//   }
// }
//
// class SponsorCollaboratorsModule {
//   final LeadSponsor leadSponsor;
//   final ResponsibleParty responsibleParty;
//
//   SponsorCollaboratorsModule({
//     required this.leadSponsor,
//     required this.responsibleParty,
//   });
//
//   factory SponsorCollaboratorsModule.fromJson(Map<String, dynamic> json) {
//     return SponsorCollaboratorsModule(
//       leadSponsor: LeadSponsor.fromJson(json['leadSponsor']),
//       responsibleParty: ResponsibleParty.fromJson(json['responsibleParty']),
//     );
//   }
// }
//
// class LeadSponsor {
//   final String name;
//   final String classType;
//
//   LeadSponsor({required this.name, required this.classType});
//
//   factory LeadSponsor.fromJson(Map<String, dynamic> json) {
//     return LeadSponsor(
//       name: json['name'],
//       classType: json['class'],
//     );
//   }
// }
//
// class ResponsibleParty {
//   final String type;
//
//   ResponsibleParty({required this.type});
//
//   factory ResponsibleParty.fromJson(Map<String, dynamic> json) {
//     return ResponsibleParty(type: json['type']);
//   }
// }
//
// class DesignModule {
//   final String studyType;
//   final List<String> phases;
//   final DesignInfo designInfo;
//   final EnrollmentInfo enrollmentInfo;
//
//   DesignModule({
//     required this.studyType,
//     required this.phases,
//     required this.designInfo,
//     required this.enrollmentInfo,
//   });
//
//   factory DesignModule.fromJson(Map<String, dynamic> json) {
//     return DesignModule(
//       studyType: json['studyType'],
//       phases: List<String>.from(json['phases']),
//       designInfo: DesignInfo.fromJson(json['designInfo']),
//       enrollmentInfo: EnrollmentInfo.fromJson(json['enrollmentInfo']),
//     );
//   }
// }
//
// class DesignInfo {
//   final String allocation;
//   final String interventionModel;
//   final String primaryPurpose;
//   final MaskingInfo maskingInfo;
//
//   DesignInfo({
//     required this.allocation,
//     required this.interventionModel,
//     required this.primaryPurpose,
//     required this.maskingInfo,
//   });
//
//   factory DesignInfo.fromJson(Map<String, dynamic> json) {
//     return DesignInfo(
//       allocation: json['allocation'],
//       interventionModel: json['interventionModel'],
//       primaryPurpose: json['primaryPurpose'],
//       maskingInfo: MaskingInfo.fromJson(json['maskingInfo']),
//     );
//   }
// }
//
// class MaskingInfo {
//   final String masking;
//
//   MaskingInfo({required this.masking});
//
//   factory MaskingInfo.fromJson(Map<String, dynamic> json) {
//     return MaskingInfo(masking: json['masking']);
//   }
// }
//
// class EnrollmentInfo {
//   final int count;
//   final String type;
//
//   EnrollmentInfo({required this.count, required this.type});
//
//   factory EnrollmentInfo.fromJson(Map<String, dynamic> json) {
//     return EnrollmentInfo(
//       count: json['count'],
//       type: json['type'],
//     );
//   }
// }
//
// class ArmsInterventionsModule {
//   final List<String> interventions;
//
//   ArmsInterventionsModule({required this.interventions});
//
//   factory ArmsInterventionsModule.fromJson(Map<String, dynamic> json) {
//     return ArmsInterventionsModule(
//       interventions: List<String>.from(json['interventions']),
//     );
//   }
// }
//
// class OutcomesModule {
//   final PrimaryOutcomes primaryOutcomes;
//
//   OutcomesModule({required this.primaryOutcomes});
//
//   factory OutcomesModule.fromJson(Map<String, dynamic> json) {
//     return OutcomesModule(
//       primaryOutcomes: PrimaryOutcomes.fromJson(json['primaryOutcomes']),
//     );
//   }
// }
//
// class PrimaryOutcomes {
//   final List<String> measure;
//
//   PrimaryOutcomes({required this.measure});
//
//   factory PrimaryOutcomes.fromJson(Map<String, dynamic> json) {
//     return PrimaryOutcomes(
//       measure: List<String>.from(json['measure']),
//     );
//   }
// }
//
// class EligibilityModule {
//   final String eligibilityCriteria;
//
//   EligibilityModule({required this.eligibilityCriteria});
//
//   factory EligibilityModule.fromJson(Map<String, dynamic> json) {
//     return EligibilityModule(
//       eligibilityCriteria: json['eligibilityCriteria'],
//     );
//   }
// }
//
// class ContactsLocationsModule {
//   final List<dynamic> locations;
//
//   ContactsLocationsModule({required this.locations});
//
//   factory ContactsLocationsModule.fromJson(Map<String, dynamic> json) {
//     return ContactsLocationsModule(
//       locations: json['locations'] ?? [],
//     );
//   }
// }
//
// class IdentificationModule {
//   final String briefTitle;
//
//   IdentificationModule({required this.briefTitle});
//
//   factory IdentificationModule.fromJson(Map<String, dynamic> json) {
//     return IdentificationModule(
//       briefTitle: json['briefTitle'],
//     );
//   }
// }
//
// class ResultsSection {
//   final ParticipantFlowModule participantFlowModule;
//
//   ResultsSection({required this.participantFlowModule});
//
//   factory ResultsSection.fromJson(Map<String, dynamic> json) {
//     return ResultsSection(
//       participantFlowModule: ParticipantFlowModule.fromJson(json['participantFlowModule']),
//     );
//   }
// }
//
// class ParticipantFlowModule {
//   final List<dynamic> periods;
//
//   ParticipantFlowModule({required this.periods});
//
//   factory ParticipantFlowModule.fromJson(Map<String, dynamic> json) {
//     return ParticipantFlowModule(
//       periods: json['periods'] ?? [],
//     );
//   }
// }