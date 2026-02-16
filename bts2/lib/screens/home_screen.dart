import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/report_provider.dart';
import '../models/islem_turu.dart';
import 'cover_page.dart';

/// Ana Sayfa
/// Yeni rapor oluşturma ve mevcut raporları listeleme
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Form kontrolleri
  final _formKey = GlobalKey<FormState>();
  final _firmaAdiController = TextEditingController();
  final _trafoAdiController = TextEditingController();
  final _seriNoController = TextEditingController();
  final _gucController = TextEditingController();
  final _lokasyonController = TextEditingController();
  final _bakimMetniController = TextEditingController();
  final _sonucMetniController = TextEditingController();
  
  DateTime _secilenTarih = DateTime.now();
  IslemTuru _secilenIslemTuru = IslemTuru.bakim;

  @override
  void initState() {
    super.initState();
    // Yeni rapor oluştur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().yeniRaporOlustur();
    });
  }

  @override
  void dispose() {
    _firmaAdiController.dispose();
    _trafoAdiController.dispose();
    _seriNoController.dispose();
    _gucController.dispose();
    _lokasyonController.dispose();
    _bakimMetniController.dispose();
    _sonucMetniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trafo Bakım Raporu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _pdfOlustur,
            tooltip: 'PDF Oluştur',
          ),
        ],
      ),
      body: Row(
        children: [
          // Sol panel - Form
          Expanded(
            flex: 1,
            child: _buildFormPanel(),
          ),
          // Sağ panel - Önizleme
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: const CoverPage(),
            ),
          ),
        ],
      ),
    );
  }

  /// Sol panel - Form
  Widget _buildFormPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Başlık
            Text(
              'Yeni Rapor Oluştur',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Firma Adı
            _buildTextField(
              controller: _firmaAdiController,
              label: 'Firma Adı',
              hint: 'Firma adını giriniz',
              icon: Icons.business,
              onChanged: (v) => _guncelleRapor(firmaAdi: v),
            ),
            const SizedBox(height: 12),
            
            // Trafo Adı
            _buildTextField(
              controller: _trafoAdiController,
              label: 'Trafo Adı',
              hint: 'Trafo adını giriniz',
              icon: Icons.transform,
              onChanged: (v) => _guncelleRapor(trafoAdi: v),
            ),
            const SizedBox(height: 12),
            
            // Seri No ve Güç
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _seriNoController,
                    label: 'Seri No',
                    hint: 'Seri no',
                    icon: Icons.numbers,
                    onChanged: (v) => _guncelleRapor(seriNo: v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _gucController,
                    label: 'Güç (kVA)',
                    hint: 'kVA',
                    icon: Icons.bolt,
                    onChanged: (v) => _guncelleRapor(guc: v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Tarih seçici
            _buildTarihSecici(),
            const SizedBox(height: 12),
            
            // Lokasyon
            _buildTextField(
              controller: _lokasyonController,
              label: 'Lokasyon',
              hint: 'Adresi giriniz',
              icon: Icons.location_on,
              onChanged: (v) => _guncelleRapor(lokasyon: v),
            ),
            const SizedBox(height: 12),
            
            //İşlem Türü
            _buildIslemTuruSecici(),
            const SizedBox(height: 12),
            
            // Bakım Metni
            _buildTextField(
              controller: _bakimMetniController,
              label: 'Bakım ve Kontrol Açıklaması',
              hint: 'Yapılan işlemleri açıklayınız',
              icon: Icons.description,
              maxLines: 4,
              onChanged: (v) => _guncelleRapor(bakimMetni: v),
            ),
            const SizedBox(height: 12),
            
            // Sonuç Metni
            _buildTextField(
              controller: _sonucMetniController,
              label: 'Sonuç',
              hint: 'Sonuç ve önerileriniz',
              icon: Icons.check_circle,
              maxLines: 3,
              onChanged: (v) => _guncelleRapor(sonucMetni: v),
            ),
            const SizedBox(height: 20),
            
            // Fotoğraf ekleme butonu
            OutlinedButton.icon(
              onPressed: _fotoEkle,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Fotoğraf Ekle'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            
            // Kaydet butonu
            ElevatedButton.icon(
              onPressed: _raporuKaydet,
              icon: const Icon(Icons.save),
              label: const Text('Raporu Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  /// TextField widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      onChanged: onChanged,
    );
  }

  /// Tarih seçici
  Widget _buildTarihSecici() {
    return InkWell(
      onTap: () async {
        final tarih = await showDatePicker(
          context: context,
          initialDate: _secilenTarih,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
        );
        if (tarih != null) {
          setState(() => _secilenTarih = tarih);
          _guncelleRapor(tarih: tarih);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Tarih',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          '${_secilenTarih.day.toString().padLeft(2, '0')}.${_secilenTarih.month.toString().padLeft(2, '0')}.${_secilenTarih.year}',
        ),
      ),
    );
  }

  /// İşlem türü seçici
  Widget _buildIslemTuruSecici() {
    return DropdownButtonFormField<IslemTuru>(
      initialValue: _secilenIslemTuru,
      decoration: const InputDecoration(
        labelText: 'İşlem Türü',
        prefixIcon: Icon(Icons.build),
      ),
      items: IslemTuru.values.map((turu) {
        return DropdownMenuItem(
          value: turu,
          child: Text(turu.label),
        );
      }).toList(),
      onChanged: (yeniDeger) {
        if (yeniDeger != null) {
          setState(() => _secilenIslemTuru = yeniDeger);
          _guncelleRapor(islemTuru: yeniDeger);
        }
      },
    );
  }

  /// Raporu güncelle
  void _guncelleRapor({
    String? firmaAdi,
    String? trafoAdi,
    String? seriNo,
    String? guc,
    DateTime? tarih,
    String? lokasyon,
    String? bakimMetni,
    String? sonucMetni,
    IslemTuru? islemTuru,
  }) {
    context.read<ReportProvider>().raporuGuncelle(
      firmaAdi: firmaAdi,
      trafoAdi: trafoAdi,
      seriNo: seriNo,
      guc: guc,
      tarih: tarih,
      lokasyon: lokasyon,
      bakimMetni: bakimMetni,
      sonucMetni: sonucMetni,
      islemTuru: islemTuru,
    );
  }

  /// Fotoğraf ekle (demo)
  void _fotoEkle() {
    // Gerçek uygulamada image_picker kullanılacak
    // Şimdi demo için placeholder ekle
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fotoğraf Ekleme'),
        content: const Text(
          'Gerçek uygulamada burada kamera veya galeri açılacak.\n\n'
          'Demo için "placeholder" fotoğraf eklemek için devam edin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Demo fotoğraf yolu ekle
              context.read<ReportProvider>().fotoEkle(
                'demo_foto_${DateTime.now().millisecondsSinceEpoch}.jpg',
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fotoğraf eklendi (demo)')),
              );
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  /// Raporu kaydet
  void _raporuKaydet() async {
    final provider = context.read<ReportProvider>();
    await provider.raporuKaydet();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rapor başarıyla kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// PDF oluştur
  void _pdfOlustur() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF Oluştur'),
        content: const Text(
          'PDF oluşturma özelliği aktif edildiğinde, '
          'raporunuz A4 formatında PDF olarak kaydedilecek veya paylaşılabilecek.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
