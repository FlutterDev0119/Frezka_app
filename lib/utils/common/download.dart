import 'dart:io';

import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart'as http;

Future<bool> requestStoragePermission() async {
  if (await Permission.manageExternalStorage.isGranted || await Permission.storage.isGranted) {
    return true;
  }

  // Request permission
  var manageStatus = await Permission.manageExternalStorage.request();
  var storageStatus = await Permission.storage.request();

  // 🔁 Recheck after requesting
  if (manageStatus.isGranted || storageStatus.isGranted) {
    return true;
  }

  // 🔒 Permanently denied
  if (manageStatus.isPermanentlyDenied || storageStatus.isPermanentlyDenied) {
    await openAppSettings();
  }

  return false;
}
Future<void> downloadPdf(String link) async {
  try {
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      toast("Please enable storage permission in settings to download the invoice.");
      return;
    }

    final pdfResponse = await http.get(Uri.parse(link));

    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String downloadPath = "/storage/emulated/0/Download/invoice_$timestamp.pdf";

      File file = File(downloadPath);
      await file.writeAsBytes(pdfResponse.bodyBytes);

      OpenFile.open(downloadPath);
    } else {
      toast("failed To Access External Storage");
    }
  } catch (e) {
    print(e);
    toast('error : $e');
  } finally {
  }
}
