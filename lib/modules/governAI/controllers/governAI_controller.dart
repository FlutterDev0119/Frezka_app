import 'package:apps/utils/library.dart';
import '../model/count_traces_model.dart';
import '../model/fetch_traces_model.dart';

class GovernAIController extends GetxController {
  var traceList = <Trace>[].obs;
  var countTracesList = <CountTracesModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTraces();
    fetchCountTraces();
  }

  // Fetch Traces list from API
  void fetchTraces() async {
    try {
      isLoading(true);
      final result = await GovernAIServiceApis.fetchTracesList();
      traceList.assignAll(result);  // Add the fetched traces to the observable list
    } catch (e) {
      print('Error fetching traces: $e');
    } finally {
      isLoading(false);
    }
  }

  // Fetch CountTraces list from API
  void fetchCountTraces() async {
    try {
      isLoading(true);
      final result = await GovernAIServiceApis.fetchCountTracesList();
      countTracesList.assignAll(result);  // Add the fetched count traces to the observable list
    } catch (e) {
      print('Error fetching CountTraces: $e');  // This will help debug the error
    } finally {
      isLoading(false);
    }
  }
}
