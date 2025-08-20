import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/doktor_controller.dart';

class DoktorGirisPage extends StatelessWidget {
  DoktorGirisPage({super.key});

  final DoktorController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doktor Girişi',
          style: TextStyle(color: Color.fromARGB(255, 65, 28, 214)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.sifreController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.girisYap,
                icon: const Icon(Icons.login),
                label: const Text('Giriş Yap', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Doktor Bilgileri:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Dr. Ahmet Yılmaz (Kardiyoloji)'),
                    Text('Email: ahmet.yilmaz@hastane.com'),
                    Text('Şifre: 123456'),
                    SizedBox(height: 8),
                    Text('Dr. Ayşe Demir (Dahiliye)'),
                    Text('Email: ayse.demir@hastane.com'),
                    Text('Şifre: 123456'),
                    SizedBox(height: 8),
                    Text('Dr. Mehmet Kaya (Ortopedi)'),
                    Text('Email: mehmet.kaya@hastane.com'),
                    Text('Şifre: 123456'),
                    SizedBox(height: 8),
                    Text("Dr.Elif Arslan (Göz Hastalıkları)"),
                    Text('Email:elif.arslan@hastane.com'),
                    Text('Şifre: 123456'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
