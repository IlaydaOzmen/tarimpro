import 'package:get/get.dart';
import '../file_helper.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      final data = await FileHelper.readThemeData();
      isDarkMode.value = data['isDarkMode'] ?? false;
    } catch (e) {
      isDarkMode.value = false;
    }
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    try {
      await FileHelper.writeThemeData({'isDarkMode': isDarkMode.value});
    } catch (e) {
      print('Tema kaydedilemedi: $e');
    }
  }
}
