import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/report_provider.dart';
import '../models/trafo_report.dart';
import '../models/islem_turu.dart';

/// Kapak Sayfası Widget'ı
/// A4 oranında profesyonel rapor önizlemesi
class CoverPage extends StatelessWidget {
  const CoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, provider, child) {
        final rapor = provider.mevcutRapor;
        
        if (rapor == null) {
          return const Center(
            child: Text('Rapor bulunamadı'),
          );
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık Alanı
              _buildHeader(rapor),
              const SizedBox(height: 20),
              
              // Bilgi Grid
              _buildInfoGrid(rapor),
              const SizedBox(height: 20),
              
              // İşlem Türü
              _buildIslemTuru(rapor),
              const SizedBox(height: 20),
              
              // Bakım Metni
              _buildBakimMetni(rapor),
              const SizedBox(height: 20),
              
              // Sonuç Metni
              _buildSonucMetni(rapor),
              const SizedBox(height: 20),
              
              // Fotoğraflar
              _buildPhotoSection(rapor, provider),
              
              const Spacer(),
              
              // Alt bilgi
              _buildFooter(rapor),
            ],
          ),
        );
      },
    );
  }

  /// Başlık bölümü
  Widget _buildHeader(TrafoReport rapor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'TRAFO BAKIM VE KONTROL RAPORU',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            rapor.firmaAdi.isNotEmpty ? rapor.firmaAdi : 'Firma Adı',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Trafo: ${rapor.trafoAdi.isNotEmpty ? rapor.trafoAdi : "___"}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  /// Bilgi grid bölümü
  Widget _buildInfoGrid(TrafoReport rapor) {
    return Table(
      border: TableBorder.all(color: Colors.grey[400]!),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            _buildGridCell('Seri No', isHeader: true),
            _buildGridCell(rapor.seriNo.isNotEmpty ? rapor.seriNo : '___'),
            _buildGridCell('Güç (kVA)', isHeader: true),
            _buildGridCell(rapor.guc.isNotEmpty ? rapor.guc : '___'),
          ],
        ),
        TableRow(
          children: [
            _buildGridCell('Tarih', isHeader: true),
            _buildGridCell(_formatDate(rapor.tarih)),
            _buildGridCell('Lokasyon', isHeader: true),
            _buildGridCell(rapor.lokasyon.isNotEmpty ? rapor.lokasyon : '___'),
          ],
        ),
      ],
    );
  }

  Widget _buildGridCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 12 : 11,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  /// İşlem türü bölümü
  Widget _buildIslemTuru(TrafoReport rapor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Text(
            'İşlem Türü: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getIslemTuruRengi(rapor.islemTuru),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              rapor.islemTuru.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getIslemTuruRengi(IslemTuru turu) {
    switch (turu) {
      case IslemTuru.bakim:
        return Colors.green[700]!;
      case IslemTuru.kontrol:
        return Colors.blue[700]!;
      case IslemTuru.ariza:
        return Colors.red[700]!;
      case IslemTuru.inceleme:
        return Colors.orange[700]!;
    }
  }

  /// Bakım metni bölümü
  Widget _buildBakimMetni(TrafoReport rapor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bakım ve Kontrol Açıklaması:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            rapor.bakimMetni.isNotEmpty ? rapor.bakimMetni : 'Belirtilmemiş',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  /// Sonuç metni bölümü
  Widget _buildSonucMetni(TrafoReport rapor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sonuç:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            rapor.sonucMetni.isNotEmpty ? rapor.sonucMetni : 'Belirtilmemiş',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  /// Fotoğraflar bölümü
  Widget _buildPhotoSection(TrafoReport rapor, ReportProvider provider) {
    if (rapor.fotograflar.isEmpty) {
      return Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 5),
            Text(
              'Fotoğraf eklemek için butona tıklayın',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotoğraflar (${rapor.fotograflar.length} adet):',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: rapor.fotograflar.asMap().entries.map((entry) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[100],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.image, size: 40, color: Colors.grey[500]),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => provider.fotoSil(entry.key),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      color: Colors.black54,
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Alt bilgi
  Widget _buildFooter(TrafoReport rapor) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[400]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rapor No: ${rapor.id}',
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
          Text(
            'Oluşturulma: ${_formatDate(rapor.olusturmaTarihi)}',
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
