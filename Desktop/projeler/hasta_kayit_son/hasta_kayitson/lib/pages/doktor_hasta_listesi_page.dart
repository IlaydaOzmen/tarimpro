import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/hasta_controller.dart';
import '../controller/doktor_controller.dart';

class DoktorHastaListesiPage extends StatefulWidget {
  const DoktorHastaListesiPage({super.key});

  @override
  State<DoktorHastaListesiPage> createState() => _DoktorHastaListesiPageState();
}

class _DoktorHastaListesiPageState extends State<DoktorHastaListesiPage> {
  final HastaController hastaController = Get.find();
  final DoktorController doktorController = Get.find();

  @override
  void initState() {
    super.initState();
    hastaController.hastalariYukle();
    _loadRandevular();
  }

  Future<void> _loadRandevular() async {
    await doktorController.randevulariYukle();
  }

  @override
  Widget build(BuildContext context) {
    final currentDoktor = doktorController.currentDoktor.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dr. ${currentDoktor?['adSoyad'] ?? 'Doktor'} Paneli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              doktorController.cikisYap();
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Randevularım'),
                Tab(text: 'Tüm Hastalar'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_buildRandevularTab(), _buildHastalarTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandevularTab() {
    return Obx(() {
      final doktorRandevular = doktorController.doktorRandevulari;

      if (doktorRandevular.isEmpty) {
        return const Center(child: Text('Henüz randevunuz bulunmuyor'));
      }

      return ListView.builder(
        itemCount: doktorRandevular.length,
        itemBuilder: (context, index) {
          final randevu = doktorRandevular[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(randevu['hastaAd'] ?? 'İsimsiz'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TC: ${randevu['hastaTc']}'),
                  Text('Tarih: ${randevu['tarih']}'),
                  Text('Saat: ${randevu['saat']}'),
                  Text('Poliklinik: ${randevu['poliklinik']}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.info),
                onPressed: () => _showHastaDetay(randevu['hastaTc']),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildHastalarTab() {
    return Obx(() {
      final hastalar = hastaController.hastalar;
      if (hastalar.isEmpty) {
        return const Center(child: Text('Kayıtlı hasta yok'));
      }

      return ListView.builder(
        itemCount: hastalar.length,
        itemBuilder: (context, index) {
          final hasta = hastalar[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(hasta['adSoyad'] ?? 'İsimsiz'),
              subtitle: Text(
                'TC: ${hasta['tc'] ?? '-'}\n'
                'Doğum: ${hasta['dogumTarihi'] ?? '-'}\n'
                'Cinsiyet: ${hasta['cinsiyet'] ?? '-'}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () => _showHastaDetay(hasta['tc']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Sil',
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Silinsin mi?',
                        middleText: 'Bu hastayı silmek istiyor musunuz?',
                        textCancel: 'İptal',
                        textConfirm: 'Sil',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          hastaController.hastaSil(index);
                          Get.back();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _showHastaDetay(String tc) async {
    final hasta = await hastaController.hastaAra(tc);
    if (hasta == null) return;

    final randevular = await hastaController.hastaRandevulari(tc);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hasta Detayları'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ad Soyad: ${hasta['adSoyad'] ?? '-'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('TC: ${hasta['tc'] ?? '-'}'),
              Text('Doğum Tarihi: ${hasta['dogumTarihi'] ?? '-'}'),
              Text('Cinsiyet: ${hasta['cinsiyet'] ?? '-'}'),
              Text('Adres: ${hasta['adres'] ?? '-'}'),
              const SizedBox(height: 16),
              const Text(
                'Randevular:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (randevular.isEmpty)
                const Text('Henüz randevu yok')
              else
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: randevular.length,
                    itemBuilder: (context, index) {
                      final randevu = randevular[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            '${randevu['tarih']} - ${randevu['saat']}',
                          ),
                          subtitle: Text(
                            '${randevu['poliklinik']} - ${randevu['doktorAd']}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
}
