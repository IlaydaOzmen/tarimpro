import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/hasta_controller.dart';
import '../controller/doktor_controller.dart';

class HastaKayitPage extends StatelessWidget {
  HastaKayitPage({super.key});

  final HastaController controller = Get.find();
  final DoktorController doktorController = Get.find();

  @override
  Widget build(BuildContext context) {
    // doktor listesini bir kez yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      doktorController.doktorlariYukle();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasta Kayıt',
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 65, 28, 214),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              // Ad Soyad
              TextFormField(
                controller: controller.adSoyadController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Ad soyad boş olamaz'
                    : null,
              ),
              const SizedBox(height: 10),

              // TC Kimlik
              TextFormField(
                controller: controller.tcController,
                decoration: const InputDecoration(
                  labelText: 'TC Kimlik No',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                maxLength: 11,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'TC boş bırakılamaz';
                  }
                  if (val.trim().length != 11) {
                    return 'TC 11 hane olmalı';
                  }
                  if (!RegExp(r'^[0-9]{11}$').hasMatch(val.trim())) {
                    return 'TC sadece rakamlardan oluşmalı';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // YENİ ALAN: Kimlik Seri No
              TextFormField(
                controller: controller.kimlikSeriController,
                decoration: const InputDecoration(
                  labelText: 'Kimlik Seri No (9 karakter)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                  hintText: 'Örnek: A12B34567',
                ),
                maxLength: 9,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Kimlik seri no boş bırakılamaz';
                  }
                  String input = val.trim();

                  if (input.length != 9) {
                    return 'Kimlik seri no 9 karakter olmalı';
                  }

                  if (!RegExp(r'^[A-Za-z0-9]{9}$').hasMatch(input)) {
                    return 'Sadece harf ve rakamlardan oluşmalı';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),

              // YENİ ALAN: Şifre
              Obx(
                () => TextFormField(
                  controller: controller.sifreController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.sifreGizli.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        controller.sifreGizli.value =
                            !controller.sifreGizli.value;
                      },
                    ),
                  ),
                  obscureText: controller.sifreGizli.value,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Şifre boş bırakılamaz';
                    }
                    if (val.trim().length < 6) {
                      return 'Şifre en az 6 karakter olmalı';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),

              // YENİ ALAN: Şifre Tekrar
              Obx(
                () => TextFormField(
                  controller: controller.sifreTekrarController,
                  decoration: InputDecoration(
                    labelText: 'Şifre Tekrar',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.sifreTekrarGizli.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        controller.sifreTekrarGizli.value =
                            !controller.sifreTekrarGizli.value;
                      },
                    ),
                  ),
                  obscureText: controller.sifreTekrarGizli.value,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Şifre tekrar boş bırakılamaz';
                    }
                    if (val.trim() != controller.sifreController.text.trim()) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Cinsiyet
              Obx(
                () => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Cinsiyet',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.wc),
                  ),
                  value: controller.cinsiyet.value.isEmpty
                      ? null
                      : controller.cinsiyet.value,
                  items: controller.cinsiyetler
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    controller.cinsiyet.value = val ?? '';
                  },
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Cinsiyet seçiniz' : null,
                ),
              ),
              const SizedBox(height: 10),

              // Adres
              TextFormField(
                controller: controller.adresController,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                maxLines: 2,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Adres boş bırakılamaz'
                    : null,
              ),
              const SizedBox(height: 20),

              // Doğum Tarihi Başlığı
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.cake, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        'Doğum Tarihi',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Doğum Tarihi - Gün / Ay / Yıl
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Gün',
                          border: OutlineInputBorder(),
                        ),
                        value: controller.gun.value.isEmpty
                            ? null
                            : controller.gun.value,
                        items: controller.gunler
                            .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)),
                            )
                            .toList(),
                        onChanged: (val) => controller.gun.value = val ?? '',
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Gün seçiniz' : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Ay',
                          border: OutlineInputBorder(),
                        ),
                        value: controller.ay.value.isEmpty
                            ? null
                            : controller.ay.value,
                        items: controller.aylar
                            .map(
                              (a) => DropdownMenuItem(value: a, child: Text(a)),
                            )
                            .toList(),
                        onChanged: (val) => controller.ay.value = val ?? '',
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Ay seçiniz' : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Yıl',
                          border: OutlineInputBorder(),
                        ),
                        value: controller.yil.value.isEmpty
                            ? null
                            : controller.yil.value,
                        items: controller.yillar
                            .map(
                              (y) => DropdownMenuItem(value: y, child: Text(y)),
                            )
                            .toList(),
                        onChanged: (val) => controller.yil.value = val ?? '',
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Yıl seçiniz' : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Kaydet Butonu
              ElevatedButton.icon(
                onPressed: controller.saveFormData,
                icon: const Icon(Icons.save, size: 20),
                label: const Text(
                  'Hasta Kaydını Tamamla',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
              ),
              const SizedBox(height: 10),

              // Bilgilendirme Kartı
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Önemli Bilgiler',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('• TC Kimlik No 11 haneli olmalıdır'),
                      const Text(
                        '• Kimlik Seri No 9 karakter olmalıdır (Örnek: A12B34567)',
                      ),
                      const Text('• Şifre en az 6 karakter olmalıdır'),
                      const Text('• Tüm alanlar zorunludur'),
                      const Text('• Kayıt sonrası randevu alabilirsiniz'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
