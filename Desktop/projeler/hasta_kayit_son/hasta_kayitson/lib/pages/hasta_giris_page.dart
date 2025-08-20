import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/hasta_controller.dart';
import 'hasta_kayit_page.dart';
import 'hasta_randevu_page.dart';

class HastaGirisPage extends StatelessWidget {
  HastaGirisPage({super.key});

  final HastaController controller = Get.find();

  // Şifre görünürlüğü için
  final RxBool sifreGizli = true.obs;

  @override
  Widget build(BuildContext context) {
    final TextEditingController tcController = TextEditingController();
    final TextEditingController sifreController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasta Girişi',
          style: TextStyle(color: Color.fromARGB(255, 65, 28, 214)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),

            // TC Kimlik No alanı
            TextField(
              controller: tcController,
              decoration: const InputDecoration(
                labelText: 'TC Kimlik No',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              keyboardType: TextInputType.number,
              maxLength: 11,
            ),
            const SizedBox(height: 16),

            // Şifre alanı
            Obx(
              () => TextField(
                controller: sifreController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      sifreGizli.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      sifreGizli.value = !sifreGizli.value;
                    },
                  ),
                ),
                obscureText: sifreGizli.value,
              ),
            ),
            const SizedBox(height: 24),

            // Giriş Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final tc = tcController.text.trim();
                  final sifre = sifreController.text.trim();

                  if (tc.length != 11) {
                    Get.snackbar('Hata', 'TC Kimlik No 11 haneli olmalıdır');
                    return;
                  }

                  if (sifre.isEmpty) {
                    Get.snackbar('Hata', 'Şifre boş bırakılamaz');
                    return;
                  }

                  final hasta = await controller.hastaGiris(tc, sifre);
                  if (hasta != null) {
                    Get.snackbar(
                      'Başarılı',
                      'Hoş geldiniz ${hasta['adSoyad']}',
                    );
                    Get.to(() => HastaRandevuPage(hasta: hasta));
                  } else {
                    Get.snackbar('Hata', 'TC Kimlik No veya şifre hatalı');
                  }
                },
                icon: const Icon(Icons.login),
                label: const Text('Giriş Yap', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kayıt ol linki
            TextButton(
              onPressed: () {
                Get.to(() => HastaKayitPage());
              },
              child: const Text('Henüz kaydınız yok mu? Kayıt olun'),
            ),

            const SizedBox(height: 20),

            // Şifremi unuttum linki (isteğe bağlı)
            TextButton(
              onPressed: () {
                _sifremiUnuttumDialog();
              },
              child: const Text(
                'Şifremi Unuttum',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Şifremi unuttum dialog'u
  void _sifremiUnuttumDialog() {
    final TextEditingController tcSifreController = TextEditingController();

    Get.defaultDialog(
      title: 'Şifremi Unuttum',
      content: Column(
        children: [
          const Text(
            'TC Kimlik numaranızı girin, şifrenizi gösterelim:',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: tcSifreController,
            decoration: const InputDecoration(
              labelText: 'TC Kimlik No',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            maxLength: 11,
          ),
        ],
      ),
      textCancel: 'İptal',
      textConfirm: 'Şifreyi Göster',
      onConfirm: () async {
        final tc = tcSifreController.text.trim();

        if (tc.length != 11) {
          Get.snackbar('Hata', 'TC Kimlik No 11 haneli olmalıdır');
          return;
        }

        final hasta = await controller.hastaAra(tc);
        if (hasta != null) {
          Get.back(); // Dialog'u kapat
          Get.defaultDialog(
            title: 'Şifreniz',
            middleText: 'Şifreniz: ${hasta['sifre']}',
            textConfirm: 'Tamam',
            onConfirm: () => Get.back(),
          );
        } else {
          Get.snackbar('Hata', 'Bu TC ile kayıtlı hasta bulunamadı');
        }
      },
    );
  }
}
