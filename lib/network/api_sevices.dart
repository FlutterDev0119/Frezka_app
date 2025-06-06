import 'dart:convert';

import 'package:apps/modules/translation_memory/model/translation_model.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:apps/utils/library.dart';

import '../modules/genAI_clinical/model/additional_narrative_model.dart';
import '../modules/genAI_clinical/model/execute_prompt_model.dart';
import '../modules/genAI_clinical/model/fetch_clinical_data.dart';
import '../modules/genAI_clinical/model/fetch_docs_clinical.dart';
import '../modules/genAI_pv/model/doc_language_model.dart';
import '../modules/genAI_pv/model/fetch_last_queries.dart';
import '../modules/genAI_pv/model/generate_sql_model.dart';
import '../modules/genAI_pv/model/narrative_generation_model.dart';
import '../modules/governAI/model/count_traces_model.dart';
import '../modules/governAI/model/fetch_traces_model.dart';
import '../modules/login/model/google_social_login_model.dart';
import '../modules/meta_phrase_pv/model/open_worklist_model.dart';
import '../modules/meta_phrase_pv/model/put_justification_data_res.dart';
import '../modules/meta_phrase_pv/model/reverse_translate_model.dart';
import '../modules/meta_phrase_pv/model/transalted_model.dart';
import '../modules/prompt_admin/model/inherit_fetch_doc_model.dart';
import '../modules/prompt_admin/model/new_prompt_response_model.dart';
import '../modules/prompt_admin/model/output_model.dart';
import '../modules/prompt_admin/model/role_model.dart';
import '../modules/reconAI/model/reconAI_model.dart';
import '../modules/translation_memory/model/ai_translation_memory_model.dart';
import '../modules/translation_memory/model/save_annotations.dart';
import '../modules/translation_memory/model/staging_translation_memory.dart';
import '../modules/translation_memory/model/view_annotation.dart';
import '../utils/common/base_response_model.dart';
import '../utils/common/common.dart';
import '../utils/constants.dart';
import '../utils/shared_prefences.dart';

class AuthServiceApis {
  // static Future<String?> login({
  //   required Map<String, dynamic> request,
  // }) async {
  //   UserDataResponseModel userDataResponse = await UserDataResponseModel.fromJson(
  //     await buildHttpResponse(
  //       endPoint: APIEndPoints.login,
  //       request: request,
  //       method: MethodType.post,
  //     ),
  //   );
  //
  //   isLoggedIn(true);
  //   loggedInUser(userDataResponse);
  //   apiToken = userDataResponse.access!;
  //
  //   setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
  //   setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
  //   setValue(AppSharedPreferenceKeys.apiToken, loggedInUser.value.access);
  //   setValue(AppSharedPreferenceKeys.userEmail, request['email'].toString()); //userDataResponse.userModel?.email
  //   setValue(AppSharedPreferenceKeys.userModel, jsonEncode(userDataResponse.userModel)); //userDataResponse.userModel?.email
  //   setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
  //   return userDataResponse.refresh;
  // }
  static Future<String?> login({
    required Map<String, dynamic> request,
  }) async {
    UserDataResponseModel userDataResponse = await UserDataResponseModel.fromJson(
      await buildHttpResponse(
        endPoint: APIEndPoints.login,
        request: request,
        method: MethodType.post,
      ),
    );

    isLoggedIn(true);
    loggedInUser(userDataResponse);

    // Set API tokens
    apiToken = userDataResponse.access!;
    final refreshToken = userDataResponse.refresh!;
    final accessToken = userDataResponse.access!;
    final userModel = userDataResponse.userModel;

    // Save to shared preferences
    await setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
    await setValue(AppSharedPreferenceKeys.apiToken, accessToken);
    await setValue(AppSharedPreferenceKeys.refreshToken, refreshToken);
    await setValue(AppSharedPreferenceKeys.userEmail, request['email'].toString());
    await setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);

    // Save user model
    if (userModel != null) {
      await setValue(AppSharedPreferenceKeys.userModel, jsonEncode(userModel));
    }

    // Save entire loggedInUser model if needed (optional)
    await setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());

    return refreshToken;
  }

  // static Future<BaseResponseModel> forgotPassword({required Map<String, dynamic> request}) async {
  //   return await BaseResponseModel.fromJson(
  //     await buildHttpResponse(
  //       endPoint: APIEndPoints.forgotPassword,
  //       request: request,
  //       method: MethodType.post,
  //     ),
  //   );
  // }
  static Future<BaseResponseModel> forgotPassword({required Map<String, dynamic> request}) async {
    try {
      final responseJson = await buildHttpResponse(
        endPoint: APIEndPoints.forgotPassword,
        request: request,
        method: MethodType.post,
      );

      if (responseJson == null || responseJson is! Map<String, dynamic>) {
        throw Exception("Unexpected response from server");
      }

      return BaseResponseModel.fromJson(responseJson);
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
        statusCode: 500,
        data: null,
      );
    }
  }

  static Future<SocialLoginResponse> googleSocialLogin({required Map request}) async {
    return SocialLoginResponse.fromJson(
        await handleResponse(await buildHttpResponse(endPoint: APIEndPoints.socialLogin, request: request, method: MethodType.post)));
  }

  // Clear  Data
  static Future<void> clearData({bool isFromDeleteAcc = false}) async {}
}

//---------------------------------------------------------------------------------------------------------------
/// PROMPT ADMIN
class PromptAdminServiceApis {
  static Future<PromptInherit?> getPromptInherit() async {
    List<String> params = [];

    try {
      final response = await buildHttpResponse(
        endPoint: getEndPoint(
          endPoint: APIEndPoints.fetchDoc,
          params: params,
        ),
      );

      return PromptInherit.fromJson(response);
    } catch (e) {
      toast(e.toString());
      print("Error fetching prompt inherit: $e");
      return null;
    }
  }

  static Future<RoleResponse> getRolePromptResponse({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.rolePromptResponse,
      request: request,
      method: MethodType.post,
    );
    return RoleResponse.fromJson(response);
  }

  static Future<NewPromptInherit> createNewPrompt({required Map<String, dynamic> request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.newPrompt,
      request: request,
      method: MethodType.post,
    );
    return NewPromptInherit.fromJson(response);
  }
}

//---------------------------------------------------------------------------------------------------------------
/// META PHRASE PV
class MetaPhrasePVServiceApis {
  static Future<List<TranslationWork>> fetchMetaPhraseList() async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.openWorklist,
      method: MethodType.get,
    );

    // Ensure response is a List and map it properly
    if (response is List) {
      return response.map((e) => TranslationWork.fromMap(e)).toList();
    } else {
      throw Exception('Unexpected response format: ${response.runtimeType}');
    }
  }

  static Future<List<TranslationReport>> fetchMetaPhraseListById(String id) async {
    try {
      // Make the API call
      final response = await buildHttpResponse(
        endPoint: "${APIEndPoints.openWorklist}?Id=$id",
        method: MethodType.get,
      );

      // Check if the response is a List of TranslationReport objects
      if (response is List) {
        // If the response is already a list, map it directly to TranslationReport
        return response.map((e) => TranslationReport.fromJson(e as Map<String, dynamic>)).toList();
      } else if (response is Map<String, dynamic>) {
        // If the response is a Map, handle it accordingly
        return [TranslationReport.fromJson(response)];
      } else {
        throw FormatException('Unexpected response type: ${response.runtimeType}');
      }
    } catch (e) {
      print('Error fetching translation report for id $id: $e');
      throw Exception('Failed to fetch translation report for id $id: $e');
    }
  }

  static Future<ReverseTranslateResponse> reverseTranslate({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.reverseTranslate,
      request: request,
      method: MethodType.post,
    );
    return ReverseTranslateResponse.fromJson(response);
  }

  static Future<SaveJustificationRes> putJustificationData({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.putJustification,
      request: request,
      method: MethodType.post,
    );
    return SaveJustificationRes.fromJson(response);
  }
}

//---------------------------------------------------------------------------------------------------------------
/// Translation Memory PV
class TranslationMemoryServiceApis {

  // ==========================================================================
  ///Staging Fetch
  static Future<List<TranslationMemory>> fetchTranslationMemoryList() async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.translationMemory,
      method: MethodType.get,
    );
    if (response is List) {
      return response.map((e) => TranslationMemory.fromJson(e)).toList();
    } else {
      throw Exception('Unexpected response format: ${response.runtimeType}');
    }
  }
  static Future<List<StagingTranslationRes>> fetchStagingTranslationMemoryList() async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.stagingTranslationMemory,
      method: MethodType.get,
    );
    if (response is List) {
      return response.map((e) => StagingTranslationRes.fromJson(e)).toList();
    } else {
      throw Exception('Unexpected response format: ${response.runtimeType}');
    }
  }
  static Future<Map<String, dynamic>> updateStagingMemory({required int id, required String en, required String es}) async {
    final response = await buildHttpResponse(
      endPoint: '${APIEndPoints.translationMemory}/$id',
      method: MethodType.post,
      request: {'en': en, 'es': es},
    );

    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception('Unexpected response format');
    }
  }
  static Future<Map<String, dynamic>> saveStagingMemory({required int id, required String en, required String es}) async {
    final response = await buildHttpResponse(
      endPoint: '${APIEndPoints.translationMemory}/$id',
      method: MethodType.post,
      request: {'en': en, 'es': es},
    );

    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception('Unexpected response format');
    }
  }

  // ==========================================================================
  static Future<Map<String, dynamic>> updateTranslationMemory({required int id, required String en, required String es}) async {
    final response = await buildHttpResponse(
      endPoint: '${APIEndPoints.translationMemory}/$id',
      method: MethodType.put,
      request: {'en': en, 'es': es},
    );

    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception('Unexpected response format');
    }
  }

  // DELETE method to remove a translation memory entry
  static Future<Map<String, dynamic>> deleteTranslationMemory({required int id}) async {
    final response = await buildHttpResponse(
      endPoint: '${APIEndPoints.translationMemory}/$id',
      method: MethodType.delete,
    );

    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception('Unexpected response format');
    }
  }



  static Future<List<StagingTranslationRes>> fetchStagingTranslationMemoryListDelete(int id) async {
    final response = await buildHttpResponse(
      endPoint: '${APIEndPoints.stagingTranslationMemory}/$id',
      method: MethodType.delete,
    );
    if (response is List) {
      return response.map((e) => StagingTranslationRes.fromJson(e)).toList();
    } else {
      throw Exception('Unexpected response format: ${response.runtimeType}');
    }
  }

  static Future<List<AiTranslationMemoryRes>> fetchAITranslationMemoryList() async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.aiTranslationMemory,
      method: MethodType.get,
    );
    if (response is List) {
      return response.map((e) => AiTranslationMemoryRes.fromJson(e)).toList();
    } else {
      throw Exception('Unexpected response format: ${response.runtimeType}');
    }
  }

  static Future<SaveAnnotationRes> saveAnnotation({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.saveAnnotation,
      request: request,
      method: MethodType.post,
    );
    return SaveAnnotationRes.fromJson(response);
  }

  static Future<List<ViewAnnotationRes>> getAnnotation({required int id}) async {
    final response = await buildHttpResponse(
      endPoint: '${APIEndPoints.getAnnotation}?translation_edits_id=$id',
      method: MethodType.get,
    );

    // Parse list of maps into list of ViewAnnotationRes
    return (response as List)
        .map((item) => ViewAnnotationRes.fromJson(item as Map<String, dynamic>))
        .toList();
  }

//---------------------------------------------------------------------------------------------------------------
  static Future<List<TranslationReport>> fetchMetaPhraseListById(String id) async {
    try {
      // Make the API call
      final response = await buildHttpResponse(
        endPoint: "${APIEndPoints.openWorklist}?Id=$id",
        method: MethodType.get,
      );

      // Check if the response is a List of TranslationReport objects
      if (response is List) {
        // If the response is already a list, map it directly to TranslationReport
        return response.map((e) => TranslationReport.fromJson(e as Map<String, dynamic>)).toList();
      } else if (response is Map<String, dynamic>) {
        // If the response is a Map, handle it accordingly
        return [TranslationReport.fromJson(response)];
      } else {
        throw FormatException('Unexpected response type: ${response.runtimeType}');
      }
    } catch (e) {
      print('Error fetching translation report for id $id: $e');
      throw Exception('Failed to fetch translation report for id $id: $e');
    }
  }

  static Future<ReverseTranslateResponse> reverseTranslate({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.reverseTranslate,
      request: request,
      method: MethodType.post,
    );
    return ReverseTranslateResponse.fromJson(response);
  }
}

//---------------------------------------------------------------------------------------------------------------
/// GOVERN AI
class GovernAIServiceApis {
  static Future<List<CountTracesModel>> fetchCountTracesList() async {
    try {
      final response = await buildHttpResponse(
        endPoint: APIEndPoints.countTraces,
        method: MethodType.get,
      );

      print('Response: $response'); // See structure during dev

      if (response is Map<String, dynamic>) {
        return response.entries.map((entry) {
          return CountTracesModel.fromMap(entry.key, Map<String, dynamic>.from(entry.value));
        }).toList();
      } else {
        throw Exception('Failed to load CountTraces');
      }
    } catch (e) {
      throw Exception('Error fetching CountTracesList: $e');
    }
  }

  // static Future<List<TraceData>> fetchTracesList(String key,String date) async {
  //   try {
  //     final response = await buildHttpResponse(
  //       endPoint: "${APIEndPoints.fetchTrace}?key=$key&date=$date",//GenAI%20PV 01-04-2025
  //       method: MethodType.get,
  //     );
  //
  //     print("API Response: $response");
  //
  //     if (response is Map && response['traces'] is List) {
  //       return (response['traces'] as List).map((data) => TraceData.fromJson(Map<String, dynamic>.from(data))).toList();
  //     } else {
  //       throw Exception('Failed to load Traces');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching TracesList:----------- $e');
  //   }
  // }

  static Future<List<TraceData>> fetchTracesList(String key, String date, int page) async {
    try {
      final response = await buildHttpResponse(
        endPoint: "${APIEndPoints.fetchTrace}?key=$key&date=$date&page=$page",
        method: MethodType.get,
      );

      print("API Response: ${jsonEncode(response)}");

      // ✅ Correctly parse 'traces' list
      if (response is Map && response['traces'] is List) {
        return (response['traces'] as List)
            .map((data) => TraceData.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      } else {
        throw Exception('Failed to load Traces — Expected "traces" key with List.');
      }
    } catch (e) {
      throw Exception('Error fetching TracesList:----------- $e');
    }
  }

  // static Future<List<TraceData>> fetchTracesList(String key, String date,int page) async {
  //   try {
  //     final response = await buildHttpResponse(
  //       endPoint: "${APIEndPoints.fetchTrace}?key=$key&date=$date&page=$page",
  //       method: MethodType.get,
  //     );
  //
  //     print("API Response: $response");
  //
  //     // ✅ Correct key is "data", not "traces"
  //     if (response is Map && response['data'] is List) {
  //       return (response['data'] as List)
  //           .map((data) => TraceData.fromJson(Map<String, dynamic>.from(data)))
  //           .toList();
  //     } else {
  //       throw Exception('Failed to load Traces — Expected "data" key with List.');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching TracesList:----------- $e');
  //   }
  // }

}

//---------------------------------------------------------------------------------------------------------------
/// GenAI PV
class GenAIPVServiceApis {
  static Future<FetchLastQueriesRes> fetchLast5Queries({required String userName, required String userId}) async {
    final response = await buildHttpResponse(
      endPoint: "${APIEndPoints.fetchLastQueries}?userId=$userId&user_name=$userName&key=datalake",
      method: MethodType.get,
    );
    return FetchLastQueriesRes.fromJson(response);
  }


  static Future<FetchDocsClinical?> fetchGenAIDocs() async {
    List<String> params = [];

    try {
      final response = await buildHttpResponse(
        endPoint: getEndPoint(
          endPoint: APIEndPoints.fetchGenAIDocs,
          params: params,
        ),
      );

      return FetchDocsClinical.fromJson(response);
    } catch (e) {
      toast(e.toString());
      print("Error fetching clinical documents: $e");
      return null;
    }
  }

  static Future<GenerateSQLRes> getGenerateSQL({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.fetchGenerateSQL,
      request: request,
      method: MethodType.post,
    );

    return GenerateSQLRes.fromJson(response);
  }


  static Future<DocLanguage> getDocsLanguage({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.fetchDocsLanguage,
      request: request,
      method: MethodType.put,
    );
    return DocLanguage.fromJson(response);
  }
  /// Additional Narrative
  static Future<AdditionalNarrativeRes> fetchAdditionalNarrative({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.fetchAdditionalNarrative,
      request: request,
      method: MethodType.post,
    );
    return AdditionalNarrativeRes.fromJson(response);
  }
  /// Narrative Generation
  // static Future<NarrativeGenerationRes> fetchNarrativeGeneration({required Map request}) async {
  //   final response = await buildHttpResponse(
  //     endPoint: APIEndPoints.fetchNarrativeGeneration,
  //     request: request,
  //     method: MethodType.post,
  //   );
  //   return NarrativeGenerationRes.fromJson(response);
  // }
  static Future<NarrativeGenerationRes> fetchNarrativeGeneration({
    required Map request,
  }) async {
    try {
      final response = await buildHttpResponse(
        endPoint: APIEndPoints.fetchNarrativeGeneration,
        request: request,
        method: MethodType.post,
      );

      // Check type safety
      if (response is! Map<String, dynamic>) {
        log("⚠️ Unexpected response type: ${response.runtimeType}");
        throw Exception("Unexpected response format from server.");
      }

      // Handle server error
      if (response['error'] != null) {
        throw Exception(response['error']);
      }

      return NarrativeGenerationRes.fromJson(response);
    } catch (e) {
      log('❌ Narrative Generation error: $e');
      rethrow;
    }
  }

  // static Future<NarrativeGenerationRes> fetchNarrativeGeneration({
  //   required Map request,
  // }) async {
  //   final response = await buildHttpResponse(
  //     endPoint: APIEndPoints.fetchNarrativeGeneration,
  //     request: request,
  //     method: MethodType.post,
  //   );
  //
  //   if (response is Map<String, dynamic> && response['error'] != null) {
  //     throw Exception(response['error']);
  //   }
  //
  //
  //   return NarrativeGenerationRes.fromJson(response);
  // }
}

//---------------------------------------------------------------------------------------------------------------
/// GenAI Clinical
class ClinicalPromptServiceApis {
  static Future<FetchDocsClinical?> getDocsClinical() async {
    List<String> params = [];

    try {
      final response = await buildHttpResponse(
        endPoint: getEndPoint(
          endPoint: APIEndPoints.fetchDocClinical,
          params: params,
        ),
      );

      return FetchDocsClinical.fromJson(response);
    } catch (e) {
      toast(e.toString());
      print("Error fetching clinical documents: $e");
      return null;
    }
  }
  /// Fetch clinical Data
  static Future<FetchClinicalDataRes> fetchClinicalData({required String query, required String userName, required String userId}) async {
    final response = await buildHttpResponse(
      endPoint: "${APIEndPoints.fetchClinicalData}?query=$query&user_name=$userName&userId=$userId",
      method: MethodType.get,
    );
    return FetchClinicalDataRes.fromJson(response);
  }

  /// Additional Narrative
  static Future<AdditionalNarrativeRes> fetchAdditionalNarrative({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.fetchAdditionalNarrative,
      request: request,
      method: MethodType.post,
    );
    return AdditionalNarrativeRes.fromJson(response);
  }

  /// Execute Prompt
  static Future<ExecutePromptRes> executePrompt({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.executePrompt,
      request: request,
      method: MethodType.post,
    );
    return ExecutePromptRes.fromJson(response);
  }
}

//---------------------------------------------------------------------------------------------------------------
/// Engage AI
class ChatServiceApi {
  static Future<String?> sendMessage({required String message, required String userName, required String userId}) async {
    try {
      final response = await buildHttpResponse(
        endPoint: "${APIEndPoints.chat}?message=$message&user_name=$userName&userId=$userId",
        method: MethodType.get,
      );

      return response['response'];
    } catch (e) {
      toast(e.toString());
      print("Error sending message: $e");
      return null;
    }
  }
}
//---------------------------------------------------------------------------------------------------------------
/// Recon AI
class ReconServiceApi {
  static Future<ReconRes> reconReconciliation({required Map request}) async {
    final response = await buildHttpResponse(
      endPoint: APIEndPoints.reconciliation,
      request: request,
      method: MethodType.post,
    );
    return ReconRes.fromJson(response);
  }
}