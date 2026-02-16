import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/trafo_report.dart';
import '../models/islem_turu.dart';

/// PDF Oluşturma Servisi
/// A4 formatında profesyonel rapor PDF'i oluşturur
class PdfService {
  /// PDF oluştur ve kaydet
  static Future<File> pdfOlusturVeKaydet(TrafoReport rapor) async {
    final pdf = pw.Document();
    
    // PDF içeriğini oluştur
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => _buildPage(rapor),
      ),
    );

    // Dosya yolunu al
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'trafo_rapor_${rapor.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final filePath = '${directory.path}/$fileName';

    // PDF'i kaydet
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// PDF sayfasını oluştur
  static pw.Widget _buildPage(TrafoReport rapor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Başlık
        _buildHeader(rapor),
        pw.SizedBox(height: 20),
        
        // Bilgi Grid
        _buildInfoGrid(rapor),
        pw.SizedBox(height: 20),
        
        // İşlem Türü
        _buildIslemTuru(rapor),
        pw.SizedBox(height: 20),
        
        // Bakım Metni
        _buildBakimMetni(rapor),
        pw.SizedBox(height: 20),
        
        // Sonuç Metni
        _buildSonucMetni(rapor),
        pw.SizedBox(height: 20),
        
        // Fotoğraflar
        _buildFotograflar(rapor),
        
        // Alt bilgi
        pw.Spacer(),
        _buildFooter(rapor),
      ],
    );
  }

  /// Başlık bölümü
  static pw.Widget _buildHeader(TrafoReport rapor) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey800,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'TRAFO BAKIM VE KONTROL RAPORU',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            rapor.firmaAdi.isNotEmpty ? rapor.firmaAdi : 'Firma Adı',
            style: const pw.TextStyle(
              fontSize: 16,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Trafo: ${rapor.trafoAdi.isNotEmpty ? rapor.trafoAdi : "___"}',
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Bilgi grid bölümü
  static pw.Widget _buildInfoGrid(TrafoReport rapor) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _buildGridCell('Seri No', isHeader: true),
            _buildGridCell(rapor.seriNo.isNotEmpty ? rapor.seriNo : '___'),
            _buildGridCell('Güç (kVA)', isHeader: true),
            _buildGridCell(rapor.guc.isNotEmpty ? rapor.guc : '___'),
          ],
        ),
        pw.TableRow(
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

  /// Grid hücresi
  static pw.Widget _buildGridCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  /// İşlem türü bölümü
  static pw.Widget _buildIslemTuru(TrafoReport rapor) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        children: [
          pw.Text(
            'İşlem Türü: ',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: pw.BoxDecoration(
              color: _getIslemTuruRengi(rapor.islemTuru),
              borderRadius: pw.BorderRadius.circular(3),
            ),
            child: pw.Text(
              rapor.islemTuru.label,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// İşlem türü rengi
  static PdfColor _getIslemTuruRengi(IslemTuru turu) {
    switch (turu) {
      case IslemTuru.bakim:
        return PdfColors.green700;
      case IslemTuru.kontrol:
        return PdfColors.blue700;
      case IslemTuru.ariza:
        return PdfColors.red700;
      case IslemTuru.inceleme:
        return PdfColors.orange700;
    }
  }

  /// Bakım metni bölümü
  static pw.Widget _buildBakimMetni(TrafoReport rapor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Bakım ve Kontrol Açıklaması:',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Text(
            rapor.bakimMetni.isNotEmpty ? rapor.bakimMetni : 'Belirtilmemiş',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  /// Sonuç metni bölümü
  static pw.Widget _buildSonucMetni(TrafoReport rapor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Sonuç:',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Text(
            rapor.sonucMetni.isNotEmpty ? rapor.sonucMetni : 'Belirtilmemiş',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  /// Fotoğraflar bölümü
  static pw.Widget _buildFotograflar(TrafoReport rapor) {
    if (rapor.fotograflar.isEmpty) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(20),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: pw.BorderRadius.circular(5),
        ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  '[Fotoğraf]',
                  style: const pw.TextStyle(color: PdfColors.grey400, fontSize: 12),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Fotoğraf eklenmemiş',
                  style: const pw.TextStyle(color: PdfColors.grey400, fontSize: 10),
                ),
              ],
            ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Fotoğraflar (${rapor.fotograflar.length} adet):',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: rapor.fotograflar.map((path) {
            return pw.Container(
              width: 150,
              height: 150,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Center(
                child: pw.Text(
                  'Foto: ${rapor.fotograflar.indexOf(path) + 1}',
                  style: const pw.TextStyle(color: PdfColors.grey600),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Alt bilgi
  static pw.Widget _buildFooter(TrafoReport rapor) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Rapor No: ${rapor.id}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          pw.Text(
            'Oluşturulma: ${_formatDate(rapor.olusturmaTarihi)}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  /// Tarih formatla
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  /// PDF'i paylaş
  static Future<void> pdfPaylas(File pdfFile) async {
    await Share.shareXFiles(
      [XFile(pdfFile.path)],
      text: 'Trafo Bakım Raporu',
    );
  }

  /// PDF'i önizleme olarak aç
  static Future<void> pdfOzetGoster(File pdfFile) async {
    // Printing paketi ile önizleme
    // await Printing.layoutPdf(onLayout: (_) => pdfFile.readAsBytes());
  }
}
