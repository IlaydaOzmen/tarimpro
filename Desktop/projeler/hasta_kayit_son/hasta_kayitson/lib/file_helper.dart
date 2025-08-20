import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  // === Dosya Yolları ===
  static Future<String> getHastaFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/hastalar.json';
  }

  static Future<String> getDoktorFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/doktorlar.json';
  }

  static Future<String> getRandevuFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/randevular.json';
  }

  static Future<String> getThemeFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/theme.json';
  }

  // === Dosya Nesneleri ===
  static Future<File> getHastaFile() async {
    final path = await getHastaFilePath();
    return File(path);
  }

  static Future<File> getDoktorFile() async {
    final path = await getDoktorFilePath();
    return File(path);
  }

  static Future<File> getRandevuFile() async {
    final path = await getRandevuFilePath();
    return File(path);
  }

  static Future<File> getThemeFile() async {
    final path = await getThemeFilePath();
    return File(path);
  }

  // === Yazma İşlemleri ===
  static Future<void> writeHastaData(List<dynamic> data) async {
    final file = await getHastaFile();
    await file.writeAsString(jsonEncode(data));
  }

  static Future<void> writeDoktorData(List<dynamic> data) async {
    final file = await getDoktorFile();
    await file.writeAsString(jsonEncode(data));
  }

  static Future<void> writeRandevuData(List<dynamic> data) async {
    final file = await getRandevuFile();
    await file.writeAsString(jsonEncode(data));
  }

  static Future<void> writeThemeData(Map<String, dynamic> data) async {
    final file = await getThemeFile();
    await file.writeAsString(jsonEncode(data));
  }

  // === Okuma İşlemleri ===
  static Future<List<dynamic>> readHastaData() async {
    try {
      final file = await getHastaFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          return jsonDecode(content);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Bu method'u güncelliyoruz - mevcut veriler varsa da yeni doktoru ekliyor
  static Future<List<dynamic>> readDoktorData() async {
    try {
      final file = await getDoktorFile();

      // Varsayılan doktor verilerini tanımla
      final defaultData = [
        {
          "id": "1",
          "adSoyad": "Dr. Ahmet Yılmaz",
          "email": "ahmet.yilmaz@hastane.com",
          "sifre": "123456",
          "poliklinik": "Kardiyoloji",
          "telefon": "0532 123 45 67",
        },
        {
          "id": "2",
          "adSoyad": "Dr. Ayşe Demir",
          "email": "ayse.demir@hastane.com",
          "sifre": "123456",
          "poliklinik": "Dahiliye",
          "telefon": "0532 234 56 78",
        },
        {
          "id": "3",
          "adSoyad": "Dr. Mehmet Kaya",
          "email": "mehmet.kaya@hastane.com",
          "sifre": "123456",
          "poliklinik": "Ortopedi",
          "telefon": "0532 345 67 89",
        },
        {
          "id": "4",
          "adSoyad": "Dr. Elif Arslan",
          "email": "elif.arslan@hastane.com",
          "sifre": "123456",
          "poliklinik": "Göz Hastalıkları",
          "telefon": "0532 456 78 90",
        },
      ];

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final currentData = jsonDecode(content) as List;

          // Eğer mevcut veriler varsayılan verilerden azsa, güncelle
          if (currentData.length < defaultData.length) {
            await writeDoktorData(defaultData);
            return defaultData;
          }

          return currentData;
        } else {
          // Dosya boşsa varsayılan verileri yaz
          await writeDoktorData(defaultData);
          return defaultData;
        }
      } else {
        // Dosya yoksa varsayılan verileri oluştur
        await writeDoktorData(defaultData);
        return defaultData;
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> readRandevuData() async {
    try {
      final file = await getRandevuFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          return jsonDecode(content);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> readThemeData() async {
    try {
      final file = await getThemeFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          return jsonDecode(content);
        }
      }
      return {"isDarkMode": false};
    } catch (e) {
      return {"isDarkMode": false};
    }
  }

  // Opsiyonel: Doktor verilerini sıfırlamak için yardımcı method
  static Future<void> resetDoktorData() async {
    final file = await getDoktorFile();
    if (await file.exists()) {
      await file.delete();
    }
    // readDoktorData çağrıldığında varsayılan veriler yeniden oluşturulacak
    await readDoktorData();
  }
}
