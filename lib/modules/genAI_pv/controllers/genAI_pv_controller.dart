import 'dart:convert';
import 'dart:io';

import 'package:apps/utils/library.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common/common_base.dart';
import '../../../utils/component/app_dialogue_component.dart';
import '../../../utils/shared_prefences.dart';
import '../../genAI_clinical/model/additional_narrative_model.dart';
import '../model/doc_language_model.dart';
import '../model/fetch_last_queries.dart';
import '../model/generate_sql_model.dart';
import '../model/narrative_generation_model.dart';

class GenAIPVController extends GetxController {
  final GlobalKey menuKey = GlobalKey();
  RxList<File> imageFiles = <File>[].obs;
  RxList<String> fileNames = <String>[].obs;
  var genAIDropdownValue = 'Upload File'.obs;
  RxMap<String, List<String>> filteredClassificationMap = <String, List<String>>{}.obs;
  RxMap<String, List<String>> classificationMap = <String, List<String>>{}.obs;
  RxSet<String> selectedChips = <String>{}.obs;
  RxSet<String> selectedTags = <String>{}.obs;
  RxBool isLoading = false.obs;
  RxBool isShowSqlIcon = false.obs;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dataLakeTextController = TextEditingController();
  var fetchLastQueriesData = Rxn<FetchLastQueriesRes>();
  var tags = <String>[].obs;

  // Filtered data for displaying in the UI
  RxMap<String, List<String>> filteredAttributes = <String, List<String>>{}.obs;
  final RxString selectedParentTag = ''.obs;

  var generateSQLQuery = ''.obs;
  var generateDataLanaguageResponse = Rxn<DocLanguage>();
  var errorMessage = ''.obs;
  var dataLakeInput = ''.obs;
  RxString selectedFileName = ''.obs;
  RxList<SqlDataItem> selectedReports = <SqlDataItem>[].obs;
  RxList<SqlDataItem> safetyReports = <SqlDataItem>[].obs;
  RxList<SqlDataItem> selectedXmlContents = <SqlDataItem>[].obs;
  final RxString sqlQuery = ''.obs;
  var additionalNarrativeRes = Rxn<AdditionalNarrativeRes>();
  var narrativeGenerationRes = Rxn<NarrativeGenerationRes>();
  final TextEditingController personalizeController = TextEditingController();
  final isTextNotEmpty = false.obs;
  RxBool isExpanded = false.obs;
  RxBool isAdditionalNarrative = false.obs;
  RxBool isNarrativeGeneration = false.obs;
  RxBool lastQueryTap = false.obs;
  String Fullname = '';
  String id = '';
  final String otput =
      "```\n| Sponsor Name              | Study Name                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Study Phase | Enrollment Count | Dropout Counts | Dropout Reasons |\n| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ---------------- | -------------- | --------------- |\n| Pfizer                    | Safety and Efficacy of (PN-152,243)/PN-196,444 in the Prevention of ThrombocytopeniaPatients must have solid tumors, lymphomas or multiple myeloma who are receiving myelosuppressive treatment regimens requiring platelet transfusion supportPatients must not have active bleeding (exclusions do apply) or history of platelet disorder                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | PHASE3      | 180              | N/A            | N/A             |\n| Massachusetts General Hospital | ELISA in Relapsed/Refractory MM1. This study will enroll patients with relapsed and refractory multiple myeloma who have had at least 2 prior lines of therapy including patients who have had previous treatment with both immunomodulatory drugs (IMiDs) and a proteasome inhibitor (PI). Prior therapy with anti-CD38 and anti-B cell maturation antigen (BCMA) target will be permitted except an anti-BCMA T cell engager. Patients cannot be refractory to an anti-CD38 antibody.2. Measurable disease of multiple myeloma as defined by at least one of the following:  a. Serum monoclonal protein ≥ 0.5 g/dL. Patients with IgD disease and lower amounts of monoclonal protein may be permitted to enroll with PI approval  b. ≥ 200 mg of monoclonal protein in the urine on 24-hour electrophoresis  c. Serum free light chain ≥ 100 mg/L (10 mg/dL) and abnormal serum free kappa to serum free lambda light chain (FLC) ratio (\\\\<0.26 or \\\\>1.65)3. Age ≥18 years.  --a. The effects of elranatamab and isatuximab on the developing human fetus are unknown. For this reason and because anti-BCMA bispecific antibodies are known to be teratogenic, women of child-bearing potential must agree to use adequate contraception (hormonal or barrier method of birth control; abstinence) prior to study entry and for the duration of study participation and 4 months after the last dose of elranatamab and 5 months after the last dose of isatuximab. Should a woman become pregnant or suspect she is pregnant while she or her partner is participating in this study, she should inform her treating physician immediately.4. ECOG performance status ≤2 (Karnofsky ≥60%, see Appendix A).5. Participants must have adequate organ and marrow function as defined below:  a. ANC ≥ 1000/μL. G-CSF is not permitted within 7 days of screening.  b. Platelet count ≥ 50,000/µL. Platelet transfusion is not permitted within 7 days of screening.  c. Hemoglobin ≥ 8 g/dL. Red blood cell transfusions are permitted to meet eligibility criteria.  d. Calculated creatinine clearance of ≥ 30 mL/min by Cockcroft-Gault equation.  e. Patient has adequate hepatic function, as evidenced by each of the following:    Serum bilirubin values \\\\< 2 mg/dL; and    Serum aspartate transaminase (ALT) and/or aspartate transaminase (AST) values\\\\< 2.5 × the upper limit of normal (ULN) of the institutional laboratory reference range. Patients with elevated bilirubin due to Gilbert's syndrome may be permitted with PI approval (i.e., total bilirubin \\\\<3 mg/dL and normal direct bilirubin).6. Participants with a prior or concurrent malignancy whose natural history or treatment does not have the potential to interfere with the safety or efficacy assessment of the investigational regimen are eligible for this trial.7. Participants with known history or current symptoms of cardiac disease, or history of treatment with cardiotoxic agents, should have a clinical risk assessment of cardiac function using the New York Heart Association Functional Classification. To be eligible for this trial, participants should be class 2B or better.8. Ability to understand and the willingness to sign a written informed consent document.Patients with active plasma cell leukemia, POEMS syndrome, or amyloidosis are excluded from this trial.2. Stem cell transplant within 12 weeks prior to enrollment, or active GVHD.3. Ongoing Grade ≥2 peripheral sensory or motor neuropathy.4. History of any grade peripheral sensory or motor neuropathy with prior BCMA directed therapy. History of GBS or GBS variants, or history of any Grade ≥3 peripheral motor polyneuropathy.5. Previous treatment with an anti-BCMA bispecific T cell engager.  --a. Prior treatment with anti-BCMA CAR-T and/or ADC therapy is permitted; however, the participant cannot be refractory to this therapy if it was administered as the last line prior to study enrollment.6. Participants who are receiving any investigational agents currently.7. Participants who have had myeloma therapy or investigational drug within 2 weeks prior to start of treatment or those who have not recovered from adverse events due to agents administered more than 2 weeks earlier.8. Known or suspected hypersensitivity to the study drug or any components of the device (e.g. adhesive which contains acrylic).9. Impaired cardiovascular function or clinically significant cardiovascular diseases, defined as any of the following within 6 months prior to enrollment:  a. Acute myocardial infarction, acute coronary syndromes (e.g., unstable angina, coronary artery bypass graft, coronary angioplasty or stenting, pericardial effusion);  b. Clinically significant cardiac arrhythmias (e.g., uncontrolled atrial fibrillation or uncontrolled paroxysmal supraventricular tachycardia);  c. Thromboembolic or cerebrovascular events (e.g., transient ischemic attack, cerebrovascular accident, deep vein thrombosis \\\\[unless associated with a central venous access complication\\\\] or pulmonary embolism);10. Participants with known active HBV, HCV, HIV, or any active, uncontrolled bacterial, fungal, or viral infection. Active infections must be resolved at least 14 days prior to enrollment. Per institutional protocol, HBV DNA testing by PCR is mandatory for subjects at risk for HBV reactivation.11. Any other active malignancy within 3 years prior to enrollment, except for adequately treated basal cell or squamous cell skin cancer, or carcinoma in situ and or other cancers treated with curative intent.12. Other surgical (including major surgery within past 14 days prior to enrollment) medical or psychiatric condition including recent (within the past year) or active suicidal ideation/behavior or laboratory abnormality that may increase the risk of study participation or, in the investigator's judgment, make the participant inappropriate for the study.13. Live attenuated vaccine within 30 days of the first dose of study intervention. | PHASE2      | 30               | N/A            | N/A             |\n| Pfizer                    | A Study to Learn About the Study Medicine (Maplirpacept) in People With Advanced Non-Hodgkin Lymphoma or Multiple Myeloma in ChinaKey Inclusion Criteria:\\n\\n* Histologically confirmed relapsed/refractory non-Hodgkin lymphoma without other effective therapeutic option. Or relapsed/refractory multiple myeloma exposed to therapies including PI, IMiD and anti-CD38 antibody.\\n* With measurable disease\\n* Eastern Cooperative Oncology Group (ECOG) performance status score of 0, 1, or 2.\\n* Adequate organ functions (including hematologic status, coagulation, hepatic, and renal)\\n\\nKey Exclusion Criteria:\\n\\n* Active plasma cell leukemia, or POEMS syndrome.\\n* Known, current central nervous system disease involvement.\\n* Significant cardiovascular disease.\\n* Chronic use of systemic corticosteroids of more than 20 mg/day of prednisone or equivalent.\\n* Radiation therapy within 14 days of study treatment administration.\\n* Hematopoietic stem cell transplant within 90 days before the planned start of study treatment or participants with active GVHD disease.\\n* Use of any anticancer drug within 14 days before planned start of study treatment.\\n* Prior anti-CD47 or anti-SIRP alpha therapy.\\n* Participation in other studies involving investigational drug(s) or vaccines within 4 weeks from the last dose\\n* Known active, uncontrolled bacterial, fungal, or viral infection. | PHASE1      | 10               | N/A            | N/A             |\n| Pfizer                    | A Study to Learn About the Effects of the Combination of Elranatamab (PF-06863135), Daratumumab, Lenalidomide or Elranatamab and Lenalidomide Compared With Daratumumab, Lenalidomide, and Dexamethasone in Patients With Newly Diagnosed Multiple Myeloma Who Are Not Candidates for TransplantInclusion Criteria:\\n\\n* Diagnosis of multiple myeloma (MM) as defined by IMWG criteria (Rajkumar et al., 2014)\\n* Measurable disease based on IMWG criteria as defined by at least 1 of the following:\\n\\n  * Serum M-protein ≥0.5 g/dL;\\n  * Urinary M-protein excretion ≥200 mg/24 hours;\\n  * Involved FLC ≥10 mg/dL (≥100 mg/L) AND abnormal serum immunoglobulin kappa to lambda FLC ratio (\\\\<0.26 or \\\\>1.65).\\n* Part 1: Participants with relapsed/refractory multiple myeloma (RRMM) who have received 1-2 prior lines of therapy including at least one immunomodulatory drug and one proteasome inhibitor: or participants with newly-diagnosed multiple myeloma (NDMM) that are transplant-ineligible as defined by age ≥65 years or transplant-ineligible as defined by age \\\\<65 years with comorbidities impacting the possibility of transplant.\\n* Part 2: participants with newly-diagnosed multiple myeloma that are transplant-ineligible as defined by age ≥65 years or transplant-ineligible as defined by age \\\\<65 years with comorbidities impacting the possibility of transplant\\n* ECOG performance status ≤2.\\n* Not pregnant and willing to use contraception\\n* For participants with RRMM: Resolved acute effects of any prior therapy to baseline severity or CTCAE Grade ≤1.\\n\\nExclusion Criteria:\\n\\n* Smoldering Multiple Myeloma.\\n* Monoclonal gammopathy of undetermined significance.\\n* Waldenströms Macroglobulinemia\\n* Plasma cell leukemia.\\n* Active, uncontrolled bacterial, fungal, or viral infection, including (but not limited to) COVID-19/SARS-CoV-2, HBV, HCV, and known HIV or AIDS-related illness.\\n* Any other active malignancy within 3 years prior to enrollment, except for adequately treated basal cell or squamous cell skin cancer, carcinoma in situ, or Stage 0/1 with minimal risk of recurrence per investigator.\\n* For participants with RRMM: Previous treatment with a BCMA-directed therapy or anti-CD38-directed therapy within 6 months preceding the first dose of study intervention in this study. Stem cell transplant ≤3 months prior to first dose of study intervention or active GVHD.\\n* For participants with NDMM: Previous systemic treatment for MM except for a short course of corticosteroids (ie, up to 4 days of 40 mg dexamethasone or equivalent before the first dose of study intervention).\\n* Live attenuated vaccine administered within 4 weeks of the first dose of study intervention.\\n* Administration of investigational product (eg, drug or vaccine) concurrent with study intervention or within 30 days (or as determined by the local requirement) preceding the first dose of study intervention used in this study. | PHASE3      | 966              | N/A            | N/A             |\n| Pfizer                    | Korean Post Marketing Surveillance for ELREXFIO (Elranatamab).Patients who have been prescribed ELREXFIO (Elranatamab) by their physician as monotherapy for the treatment of adult patients with relapsed or refractory multiple myeloma, who have received at least three prior therapies, including a proteasome inhibitor, an immunomodulatory agent, and an anti-CD38 monoclonal antibody, and have demonstrated disease progression on the last therapy.\\n* Patients with evidence of a personally signed and dated informed consent/assent document indicating that the patient (or a legally acceptable representative) has been informed of all pertinent aspects of the study.Patients with contraindication according to locally approved label of ELREXFIO (Elranatamab)\\n* Any patients (or a legally acceptable representative) who does not agree that Pfizer and companies working with Pfizer use his/her information | N/A         | 150              | N/A            | N/A             |\n\n**Explanation of Headers:**\n\n*   **Sponsor Name:** The name of the organization or company funding and overseeing the clinical trial.\n*   **Study Name:** A brief title or identifier for the clinical trial, along with a snippet of the inclusion/exclusion criteria as requested.\n*   **Study Phase:** The stage of the clinical trial (e.g., Phase 1, Phase 2, Phase 3). N/A is used for observational studies.\n*   **Enrollment Count:** The total number of participants planned or actual for the study.\n*   **Dropout Counts:** The number of participants who withdrew or were removed from the study.\n*   **Dropout Reasons:** The reasons why participants withdrew or were removed from the study.\n\n```";

  @override
  void onInit() {
    super.onInit();
    String? userJson = getStringAsync(AppSharedPreferenceKeys.userModel);
    if (userJson.isNotEmpty) {
      var userMap = jsonDecode(userJson);
      var userModel = UserModel.fromJson(userMap); // Replace with your actual model
      Fullname = "${userModel.firstName} ${userModel.lastName}";
      id = userModel.id.toString();
    }
    init();
  }
init()async{
await fetchGenAIDocs();
 await fetchLast5Queries();
  searchController.addListener(() {
    filterAttributes(searchController.text);
  });
  isAdditionalNarrative.value = false;
isNarrativeGeneration.value = false;
  lastQueryTap.value =false;
}

  void updateTextState(String text) {
    isTextNotEmpty.value = text.trim().isNotEmpty;
  }

  void addTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  // Method to toggle selection for both chips and attributes (unified logic)
  void toggleSelection(String label) {
    if (selectedChips.contains(label)) {
      selectedChips.remove(label);
    } else {
      selectedChips.add(label);
    }

    if (selectedTags.contains(label)) {
      selectedTags.remove(label);
    } else {
      selectedTags.add(label);
    }
  }

  Future<void> fetchLast5Queries() async {
    try {
      isLoading.value = true;
      final response = await GenAIPVServiceApis.fetchLast5Queries(userName: Fullname, userId: id);
      fetchLastQueriesData.value = response;
      selectedReports..clear();
      selectedXmlContents.clear();
    } catch (e) {
      print('Error fetching  Last Queries Data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch clinical document data (populate classificationMap and selectable attributes)
  Future<void> fetchGenAIDocs() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final data = await GenAIPVServiceApis.fetchGenAIDocs();
      if (data != null && data.output != null) {
        classificationMap.assignAll(data.output!);
        filteredClassificationMap.assignAll(data.output!);
        // tags.assignAll(data.output!.keys.toList());
        tags.assignAll(data.output!.values.expand((list) => list).toList());
        log("data.output!.keys.toList()----------------${data.output!.keys.toList()}");
        log("data.output!.value.toList()----------------${data.output!.values.toList()}");
      }
    } catch (e) {
      toast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  // Future<String> decodeExcel(File file) async {
  //   var bytes = file.readAsBytesSync();
  //   var excel = Excel.decodeBytes(bytes);
  //   StringBuffer buffer = StringBuffer();
  //
  //   for (var table in excel.tables.keys) {
  //     var rows = excel.tables[table]!.rows;
  //     for (var row in rows) {
  //       buffer.writeln(row.map((cell) => cell?.value.toString() ?? '').join(','));
  //     }
  //     break;
  //   }
  //
  //   return buffer.toString();
  // }
  // void onSourceSelected(File file) async {
  //   final fileName = file.path.split('/').last;
  //   final ext = fileName.split('.').last.toLowerCase();
  //
  //   String? content;
  //
  //   try {
  //     if (['txt', 'csv', 'json'].contains(ext)) {
  //       content = await file.readAsString();
  //     } else if (['xlsx', 'xls'].contains(ext)) {
  //       content = await decodeExcel(file);
  //     } else {
  //       toast('Unsupported file format: .$ext');
  //       return;
  //     }
  //   } catch (e) {
  //     toast('Error decoding file: $e');
  //     return;
  //   }
  //
  //   if (fileNames.contains(fileName)) {
  //     toast("File '$fileName' already selected.");
  //     return;
  //   }
  //
  //   final confirmed = await Get.bottomSheet<bool>(
  //     AppDialogueComponent(
  //       titleText: "Do you want to upload this attachment?",
  //       confirmText: "Upload",
  //       onConfirm: () {},
  //     ),
  //     isScrollControlled: true,
  //   );
  //   print("content-------------------$content");
  //   if (confirmed == true) {
  //     fileNames.clear();
  //     imageFiles.clear();
  //     imageFiles.add(file);
  //     fileNames.add(fileName);
  //   }
  // }
  void onSourceSelected(dynamic imageSource) async {
    if (imageSource is File) {
      String fileName = imageSource.path.split('/').last;
      bool isDuplicate = fileNames.contains(fileName);

      if (isDuplicate) {
        toast("File already added");
        return;
      }

      Get.bottomSheet(
        AppDialogueComponent(
          titleText: "Do you want to upload this attachment?",
          confirmText: "Upload",
          onConfirm: () {
            imageFiles.add(imageSource);
            fileNames.add(fileName);
          },
        ),
        isScrollControlled: true,
      );
    }
  }

  // Toggle the selection of attributes (now unified with chips)
  void toggleAttribute(String attribute) {
    toggleSelection(attribute);
  }

  // Remove selected attribute (if needed, this can be the same as toggle)
  void removeAttribute(String attribute) {
    selectedTags.remove(attribute);
  }

  // Method to filter attributes based on the search query
  void filterAttributes(String query) {
    final trimmed = query.trim().toLowerCase();

    if (trimmed.isEmpty) {
      filteredClassificationMap.assignAll(classificationMap);
      return;
    }

    final newFiltered = <String, List<String>>{};
    classificationMap.forEach((category, attributes) {
      final matches = attributes.where((attr) => attr.toLowerCase().contains(trimmed)).toList();
      if (matches.isNotEmpty) {
        newFiltered[category] = matches;
      }
    });

    filteredClassificationMap.assignAll(newFiltered);
  }

  // Future<void> fetchGenerateSQL(String query, {String? userId, required String userName}) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     final request = {
  //       "query": query,
  //       "userId": userId,
  //       "user_name": userName,
  //     };
  //
  //     final response = await GenAIPVServiceApis.getGenerateSQL(request: request);
  //     generateSQLResponse.value = response;
  //     final List<dynamic> rawData = response.data;
  //     safetyReports.value = rawData
  //         .map((item) => Map<String, String>.from(item))
  //         .toList();
  //       } catch (e) {
  //     print('Error fetching GenerateSQL: $e');
  //     errorMessage.value = 'Error occurred while fetching data.';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  // ✅ Controller Method
  Future<void> fetchGenerateSQL(String query, {String? userId, required String userName}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = {
        "query": query,
        "userId": userId,
        "user_name": userName,
      };

      final response = await GenAIPVServiceApis.getGenerateSQL(request: request);
      generateSQLQuery.value = response.sqlQuery;

      // if (response.data.isNotEmpty) {
      //   generateSQLResponse.value = response.data.first; // if you want to use it
      // }
      // generateSQLResponse.value = response.sqlQuery;
      // Set the SQL query text
      sqlQuery.value = response.sqlQuery;

      // Extract safety report list from the response
      safetyReports.value = response.data;
    } catch (e) {
      print('Error fetching GenerateSQL: $e');
      errorMessage.value = 'Error occurred while fetching data.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> additionalNarrative({
    required String query,
    required List<String> SafetyReport,
    required List<String> checkbox,
    required String narrative,
  }) async {
    try {
      isLoading.value = true;

      final request = {
        "query": query,
        "SafetyReport": SafetyReport,
        "checkbox": checkbox,
        "narrative": "null",
        "userId": null,
        "user_name": Fullname,
      };
      log('----------------------------------------------adddit--------------');
      log(request);
      final response = await GenAIPVServiceApis.fetchAdditionalNarrative(request: request);
      additionalNarrativeRes.value = response;
    } catch (e) {
      print('Error fetching Additional Narrative: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> narrativeGeneration({
    // required String query,
    required List<String> safetyReport,
    required String prompt,
    required List<String> checkbox,
  }) async {
    try {
      isLoading.value = true;

      final request = {
        // "query": query,
        "SafetyReport": safetyReport,
        "checkbox": checkbox,
        "prompt": "",
        "userId": id,
        "user_name": Fullname,
      };

      log('--------------narrativeGeneration------------------------');
      _logLongString(request.toString());

      final response = await GenAIPVServiceApis.fetchNarrativeGeneration(request: request);
      narrativeGenerationRes.value = response;
    } catch (e) {
      Get.snackbar('Error', e.toString()); // or log or alert
    } finally {
      isLoading.value = false;
    }
  }

  void _logLongString(String message, {int chunkSize = 800}) {
    final pattern = RegExp('.{1,$chunkSize}');
    for (final match in pattern.allMatches(message)) {
      log(match.group(0)!);
    }
  }

  // Future<void> narrativeGeneration(
  //     {required String query,
  //     required List<String> safetyReport,
  //     required String prompt,
  //     required List<String> checkbox,}) async {
  //   try {
  //     isLoading.value = true;
  //
  //     final request = {
  //       "query": query,
  //       "SafetyReport": safetyReport,
  //       "checkbox": checkbox,
  //       "prompt": "",
  //       "userId": id,
  //       "user_name": Fullname,
  //     };
  //     log(request);
  //     void logLongString(String message, {int chunkSize = 800}) {
  //       final pattern = RegExp('.{1,$chunkSize}'); // chunk size
  //       pattern.allMatches(message).forEach((match) => log(match.group(0)!));
  //     }
  //
  //     log('--------------narrativeGeneration------------------------');
  //     logLongString(request.toString());
  //     final response = await GenAIPVServiceApis.fetchNarrativeGeneration(request: request);
  //     narrativeGenerationRes.value = response;
  //   } catch (e) {
  //     log('Error fetching Narrative Generation: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> getDocsLanguage({required String language}) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     final request = {
  //       "language": language
  //     };
  //
  //     final response = await GenAIPVServiceApis.getDocsLanguage(request: request);
  //     generateDataLanaguageResponse.value = response;
  //   } catch (e) {
  //     print('Error fetching GenerateSQL: $e');
  //     errorMessage.value = 'Error occurred while fetching data.';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> getDocsLanguage({required String language}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = {"language": language};

      final response = await GenAIPVServiceApis.getDocsLanguage(request: request);
      generateDataLanaguageResponse.value = response;

      /// Update tags from response
      if (response?.output != null && response!.output.isNotEmpty) {
        tags.assignAll(response.output);
      }
    } catch (e) {
      print('Error fetching language data: $e');
      errorMessage.value = 'Error occurred while fetching data.';
    } finally {
      isLoading.value = false;
    }
  }

  bool isTableData(String output) {
    // Basic check for markdown-style table
    return output.contains('|') && output.contains('\n');
  }

  List<List<String>> parseMarkdownTable(String output) {
    final lines = output.trim().split('\n');
    final rows = <List<String>>[];

    for (var line in lines) {
      if (line.trim().startsWith('|')) {
        final cells = line.split('|').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        rows.add(cells);
      }
    }
    return rows;
  }
}
