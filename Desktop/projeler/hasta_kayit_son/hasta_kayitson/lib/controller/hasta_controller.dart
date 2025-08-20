import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../file_helper.dart';
import '../controller/doktor_controller.dart'; // ← dosya konumuna göre ayarla

class HastaController extends GetxController {
  final TextEditingController adSoyadController = TextEditingController();
  final TextEditingController tcController = TextEditingController();
  final TextEditingController kimlikSeriController =
      TextEditingController(); // YENİ ALAN
  final TextEditingController adresController = TextEditingController();

  // YENİ ALANLAR: Şifre için
  final TextEditingController sifreController = TextEditingController();
  final TextEditingController sifreTekrarController = TextEditingController();
  var sifreGizli = true.obs;
  var sifreTekrarGizli = true.obs;

  final formKey = GlobalKey<FormState>();

  var cinsiyet = ''.obs;
  final List<String> cinsiyetler = ['Erkek', 'Kadın'];

  var gun = ''.obs;
  final List<String> gunler = List.generate(31, (index) => '${index + 1}');

  var ay = ''.obs;
  final List<String> aylar = List.generate(12, (index) => '${index + 1}');

  var yil = ''.obs;
  final List<String> yillar = List.generate(
    100,
    (index) => '${DateTime.now().year - index}',
  );

  var hastalar = <Map<String, dynamic>>[].obs;

  // Randevu için değişkenler
  var selectedPoliklinik = ''.obs;
  var selectedDoktor = ''.obs;
  var selectedTarih = ''.obs;
  var selectedSaat = ''.obs;

  final List<String> poliklinikler = [
    'Kardiyoloji',
    'Dahiliye',
    'Ortopedi',
    'Göz Hastalıkları',
  ];

  // Çalışma saatleri
  final List<String> calismaZamanlari = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
  ];

  List<String> get uygunTarihler {
    List<String> tarihler = [];
    DateTime now = DateTime.now();
    for (int i = 1; i <= 30; i++) {
      DateTime tarih = now.add(Duration(days: i));
      // Haftasonu kontrolü (isteğe bağlı)
      if (tarih.weekday == DateTime.saturday ||
          tarih.weekday == DateTime.sunday) {
        continue; // Haftasonları atla
      }
      String tarihStr =
          '${tarih.day.toString().padLeft(2, '0')}.${tarih.month.toString().padLeft(2, '0')}.${tarih.year}';
      tarihler.add(tarihStr);
    }
    return tarihler;
  }

  // Seçilen tarih ve doktor için uygun saatleri getir
  Future<List<String>> getUygunSaatler() async {
    if (selectedDoktor.value.isEmpty || selectedTarih.value.isEmpty) {
      return calismaZamanlari;
    }

    try {
      final mevcutRandevular = await FileHelper.readRandevuData();
      final doluSaatler = <String>[];

      for (var randevu in mevcutRandevular) {
        if (randevu['doktor'] == selectedDoktor.value &&
            randevu['tarih'] == selectedTarih.value &&
            randevu['durum'] == 'Aktif') {
          doluSaatler.add(randevu['saat']);
        }
      }

      return calismaZamanlari
          .where((saat) => !doluSaatler.contains(saat))
          .toList();
    } catch (e) {
      return calismaZamanlari;
    }
  }

  @override
  void onInit() {
    super.onInit();
    hastalariYukle();
  }

  Future<void> hastalariYukle() async {
    try {
      final veri = await FileHelper.readHastaData();
      hastalar.value = List<Map<String, dynamic>>.from(veri);
    } catch (e) {
      Get.snackbar('Hata', 'Veriler yüklenemedi: $e');
    }
  }

  Future<Map<String, dynamic>?> hastaAra(String tc) async {
    try {
      final veri = await FileHelper.readHastaData();
      for (var hasta in veri) {
        if (hasta['tc'] == tc) {
          return Map<String, dynamic>.from(hasta);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // YENİ FONKSİYON: TC ve şifre ile giriş kontrolü
  Future<Map<String, dynamic>?> hastaGiris(String tc, String sifre) async {
    try {
      final veri = await FileHelper.readHastaData();
      for (var hasta in veri) {
        if (hasta['tc'] == tc && hasta['sifre'] == sifre) {
          return Map<String, dynamic>.from(hasta);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // YENİ FONKSİYON: Kimlik seri no kontrolü
  Future<Map<String, dynamic>?> kimlikSeriAra(String seri) async {
    try {
      final veri = await FileHelper.readHastaData();
      for (var hasta in veri) {
        if (hasta['kimlikSeri'] == seri) {
          return Map<String, dynamic>.from(hasta);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveFormData() async {
    if (!formKey.currentState!.validate()) return;

    // TC kontrol et
    final mevcutHasta = await hastaAra(tcController.text.trim());
    if (mevcutHasta != null) {
      Get.snackbar('Hata', 'Bu TC ile zaten kayıtlı bir hasta bulunmaktadır');
      return;
    }

    // Kimlik seri no kontrol et
    final mevcutSeri = await kimlikSeriAra(kimlikSeriController.text.trim());
    if (mevcutSeri != null) {
      Get.snackbar(
        'Hata',
        'Bu kimlik seri numarası ile zaten kayıtlı bir hasta bulunmaktadır',
      );
      return;
    }

    final newHasta = {
      "adSoyad": adSoyadController.text.trim(),
      "tc": tcController.text.trim(),
      "kimlikSeri": kimlikSeriController.text.trim(), // YENİ ALAN
      "sifre": sifreController.text.trim(), // YENİ ALAN: Şifre
      "cinsiyet": cinsiyet.value,
      "adres": adresController.text.trim(),
      "dogumTarihi": '${gun.value}.${ay.value}.${yil.value}',
      "poliklinik": selectedPoliklinik.value,
      "doktor": selectedDoktor.value,
    };

    try {
      final mevcutHastalar = await FileHelper.readHastaData();
      mevcutHastalar.add(newHasta);
      await FileHelper.writeHastaData(mevcutHastalar);
      hastalariYukle();
      Get.snackbar('Başarılı', 'Hasta kaydı başarıyla eklendi');
      clearForm();
    } catch (e) {
      Get.snackbar('Hata', 'Kayıt sırasında hata oluştu: $e');
    }
  }

  Future<void> hastaSil(int index) async {
    try {
      hastalar.removeAt(index);
      await FileHelper.writeHastaData(hastalar);
      Get.snackbar('Silindi', 'Hasta başarıyla silindi');
    } catch (e) {
      Get.snackbar('Hata', 'Silme işlemi başarısız: $e');
    }
  }

  // GELİŞTİRİLMİŞ RANDEVU ALMA FONKSİYONU
  Future<void> randevuAl(Map<String, dynamic> hasta) async {
    if (selectedPoliklinik.value.isEmpty ||
        selectedDoktor.value.isEmpty ||
        selectedTarih.value.isEmpty ||
        selectedSaat.value.isEmpty) {
      Get.snackbar('Hata', 'Lütfen tüm alanları doldurun');
      return;
    }

    // Çakışma kontrolü - aynı doktor, tarih ve saatte randevu var mı?
    final mevcutRandevular = await FileHelper.readRandevuData();

    // Aynı zaman diliminde çakışma kontrolü
    for (var randevu in mevcutRandevular) {
      if (randevu['doktor'] == selectedDoktor.value &&
          randevu['tarih'] == selectedTarih.value &&
          randevu['saat'] == selectedSaat.value &&
          randevu['durum'] == 'Aktif') {
        Get.snackbar(
          'Hata',
          'Bu saat dilimine zaten randevu verilmiş. Lütfen başka saat seçiniz.',
        );
        return;
      }
    }

    // Aynı hasta aynı doktorda aynı günde randevu var mı kontrol et
    for (var randevu in mevcutRandevular) {
      if (randevu['hastaTc'] == hasta['tc'] &&
          randevu['doktor'] == selectedDoktor.value &&
          randevu['tarih'] == selectedTarih.value &&
          randevu['durum'] == 'Aktif') {
        Get.snackbar(
          'Hata',
          'Bu tarihte bu doktorda zaten randevunuz bulunmaktadır.',
        );
        return;
      }
    }

    final doktorController = Get.find<DoktorController>();
    await doktorController.doktorlariYukle();
    final doktor = doktorController.doktorlar.firstWhere(
      (d) => d['id'].toString() == selectedDoktor.value,
      orElse: () => {'adSoyad': 'Bilinmeyen Doktor'},
    );

    final yeniRandevu = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "hastaTc": hasta['tc'],
      "hastaAd": hasta['adSoyad'],
      "doktor": selectedDoktor.value,
      "doktorAd": doktor['adSoyad'],
      "poliklinik": selectedPoliklinik.value,
      "tarih": selectedTarih.value,
      "saat": selectedSaat.value,
      "durum": "Aktif",
      "randevuTarihi": DateTime.now().toIso8601String(),
    };

    try {
      mevcutRandevular.add(yeniRandevu);
      await FileHelper.writeRandevuData(mevcutRandevular);
      Get.snackbar(
        'Başarılı',
        'Randevunuz başarıyla alındı\n'
            'Doktor: ${doktor['adSoyad']}\n'
            'Tarih: ${selectedTarih.value}\n'
            'Saat: ${selectedSaat.value}',
        duration: const Duration(seconds: 4),
      );

      // Seçimleri temizle
      selectedPoliklinik.value = '';
      selectedDoktor.value = '';
      selectedTarih.value = '';
      selectedSaat.value = '';
    } catch (e) {
      Get.snackbar('Hata', 'Randevu alınırken hata oluştu: $e');
    }
  }

  Future<List<Map<String, dynamic>>> hastaRandevulari(String tc) async {
    try {
      final randevular = await FileHelper.readRandevuData();
      return randevular
          .where((r) => r['hastaTc'] == tc && r['durum'] == 'Aktif')
          .map((r) => Map<String, dynamic>.from(r))
          .toList()
        ..sort((a, b) {
          // Tarihe göre sırala
          DateTime tarihA = _parseDate(a['tarih']);
          DateTime tarihB = _parseDate(b['tarih']);
          return tarihA.compareTo(tarihB);
        });
    } catch (e) {
      return [];
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('.');
      return DateTime(
        int.parse(parts[2]), // yıl
        int.parse(parts[1]), // ay
        int.parse(parts[0]), // gün
      );
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> randevuIptal(String randevuId) async {
    try {
      final randevular = await FileHelper.readRandevuData();
      randevular.removeWhere((r) => r['id'] == randevuId);
      await FileHelper.writeRandevuData(randevular);
      Get.snackbar('Başarılı', 'Randevu iptal edildi');
    } catch (e) {
      Get.snackbar('Hata', 'Randevu iptal edilemedi: $e');
    }
  }

  void clearForm() {
    adSoyadController.clear();
    tcController.clear();
    kimlikSeriController.clear();
    sifreController.clear(); // YENİ ALAN: Şifre temizle
    sifreTekrarController.clear(); // YENİ ALAN: Şifre tekrar temizle
    adresController.clear();
    cinsiyet.value = '';
    gun.value = '';
    ay.value = '';
    yil.value = '';
    selectedPoliklinik.value = '';
    selectedDoktor.value = '';
    selectedTarih.value = '';
    selectedSaat.value = '';
    // Şifre görünürlük durumlarını sıfırla
    sifreGizli.value = true;
    sifreTekrarGizli.value = true;
  }
}
