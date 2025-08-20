import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hasta_kayitson/file_helper.dart';

class DoktorController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  var doktorlar = <Map<String, dynamic>>[].obs;
  var filtrelenmisDoktorlar = <Map<String, dynamic>>[].obs;
  var currentDoktor = Rxn<Map<String, dynamic>>();
  var doktorRandevulari = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    doktorlariYukle();
  }

  Future<void> doktorlariYukle() async {
    try {
      final veri = await FileHelper.readDoktorData();
      doktorlar.value = List<Map<String, dynamic>>.from(veri);
      filtrelenmisDoktorlar.value = doktorlar;
    } catch (e) {
      Get.snackbar('Hata', 'Doktor verileri yüklenemedi: $e');
    }
  }

  void poliklinikDoktorlari(String poliklinik) {
    if (poliklinik.isEmpty) {
      filtrelenmisDoktorlar.value = doktorlar;
    } else {
      filtrelenmisDoktorlar.value = doktorlar
          .where((d) => d['poliklinik'] == poliklinik)
          .toList();
    }
  }

  Future<void> girisYap() async {
    final email = emailController.text.trim();
    final sifre = sifreController.text;

    if (email.isEmpty || sifre.isEmpty) {
      Get.snackbar('Hata', 'Email ve şifre boş olamaz');
      return;
    }

    // Doktor bilgilerini kontrol et
    final doktor = doktorlar.firstWhere(
      (d) => d['email'] == email && d['sifre'] == sifre,
      orElse: () => {},
    );

    if (doktor.isNotEmpty) {
      currentDoktor.value = doktor;
      await randevulariYukle();
      Get.offNamed('/doktor_hasta_listesi');
      emailController.clear();
      sifreController.clear();
    } else {
      Get.snackbar(
        "Hata",
        "E-posta veya şifre yanlış",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> randevulariYukle() async {
    if (currentDoktor.value == null) return;

    try {
      final randevular = await FileHelper.readRandevuData();
      doktorRandevulari.value = randevular
          .where(
            (r) =>
                r['doktor'] == currentDoktor.value!['id'].toString() &&
                r['durum'] == 'Aktif',
          )
          .map((r) => Map<String, dynamic>.from(r))
          .toList();
    } catch (e) {
      Get.snackbar('Hata', 'Randevular yüklenemedi: $e');
    }
  }

  void cikisYap() {
    currentDoktor.value = null;
    doktorRandevulari.clear();
    emailController.clear();
    sifreController.clear();
    Get.offAllNamed('/');
  }
}
