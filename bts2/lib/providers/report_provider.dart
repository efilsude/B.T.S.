import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/trafo_report.dart';
import '../models/islem_turu.dart';

/// Rapor Provider - State Management
/// Rapor verilerini yönetir ve UI'ı günceller
class ReportProvider extends ChangeNotifier {
  /// Mevcut rapor
  TrafoReport? _mevcutRapor;

  /// Kaydedilmiş raporlar listesi
  List<TrafoReport> _raporlar = [];

  /// Yükleniyor durumu
  bool _yukleniyor = false;

  /// Hata mesajı
  String? _hataMesaji;

  // Getter'lar
  TrafoReport? get mevcutRapor => _mevcutRapor;
  List<TrafoReport> get raporlar => _raporlar;
  bool get yukleniyor => _yukleniyor;
  String? get hataMesaji => _hataMesaji;

  /// Yeni rapor oluştur
  void yeniRaporOlustur() {
    _mevcutRapor = TrafoReport.yeni();
    _hataMesaji = null;
    notifyListeners();
  }

  /// Mevcut raporu güncelle
  void raporuGuncelle({
    String? firmaAdi,
    String? trafoAdi,
    String? seriNo,
    String? guc,
    DateTime? tarih,
    String? lokasyon,
    String? bakimMetni,
    String? sonucMetni,
    IslemTuru? islemTuru,
    List<String>? fotograflar,
  }) {
    if (_mevcutRapor == null) return;

    _mevcutRapor = _mevcutRapor!.copyWith(
      firmaAdi: firmaAdi,
      trafoAdi: trafoAdi,
      seriNo: seriNo,
      guc: guc,
      tarih: tarih,
      lokasyon: lokasyon,
      bakimMetni: bakimMetni,
      sonucMetni: sonucMetni,
      islemTuru: islemTuru,
      fotograflar: fotograflar,
      guncellemeTarihi: DateTime.now(),
    );
    notifyListeners();
  }

  /// Fotoğraf ekle
  void fotoEkle(String yol) {
    if (_mevcutRapor == null) return;
    
    final fotolar = List<String>.from(_mevcutRapor!.fotograflar);
    fotolar.add(yol);
    raporuGuncelle(fotograflar: fotolar);
  }

  /// Fotoğraf sil
  void fotoSil(int index) {
    if (_mevcutRapor == null) return;
    if (index < 0 || index >= _mevcutRapor!.fotograflar.length) return;

    final fotolar = List<String>.from(_mevcutRapor!.fotograflar);
    fotolar.removeAt(index);
    raporuGuncelle(fotograflar: fotolar);
  }

  /// Raporu kaydet (listeeye ekle)
  Future<void> raporuKaydet() async {
    if (_mevcutRapor == null) return;

    _yukleniyor = true;
    notifyListeners();

    try {
      // Mevcut raporu güncelle veya yeni ekle
      final mevcutIndex = _raporlar.indexWhere((r) => r.id == _mevcutRapor!.id);
      
      if (mevcutIndex >= 0) {
        _raporlar[mevcutIndex] = _mevcutRapor!;
      } else {
        _raporlar.add(_mevcutRapor!);
      }

      _hataMesaji = null;
    } catch (e) {
      _hataMesaji = 'Rapor kaydedilirken hata: $e';
    } finally {
      _yukleniyor = false;
      notifyListeners();
    }
  }

  /// Raporu yükle
  void raporuSec(TrafoReport rapor) {
    _mevcutRapor = rapor;
    _hataMesaji = null;
    notifyListeners();
  }

  /// Raporu sil
  void raporuSil(String id) {
    _raporlar.removeWhere((r) => r.id == id);
    if (_mevcutRapor?.id == id) {
      _mevcutRapor = null;
    }
    notifyListeners();
  }

  /// Raporu temizle
  void temizle() {
    _mevcutRapor = null;
    _hataMesaji = null;
    notifyListeners();
  }

  /// JSON'a dönüştür
  String raporlariJsonOlarakAktar() {
    final liste = _raporlar.map((r) => r.toJson()).toList();
    return jsonEncode(liste);
  }

  /// JSON'dan yükle
  void jsonDanYukle(String json) {
    try {
      final liste = jsonDecode(json) as List;
      _raporlar = liste
          .map((e) => TrafoReport.fromJson(e as Map<String, dynamic>))
          .toList();
      _hataMesaji = null;
      notifyListeners();
    } catch (e) {
      _hataMesaji = 'JSON yüklenirken hata: $e';
      notifyListeners();
    }
  }
}
