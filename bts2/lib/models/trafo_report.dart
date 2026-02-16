import 'islem_turu.dart';

/// Trafo Bakım Raporu Veri Modeli
/// Tüm rapor bilgilerini barındırır
class TrafoReport {
  /// Benzersiz ID
  String id;

  /// Firma adı
  String firmaAdi;

  /// Trafo adı
  String trafoAdi;

  /// Seri numarası
  String seriNo;

  /// Trafo gücü (kVA)
  String guc;

  /// İşlem tarihi
  DateTime tarih;

  /// Lokasyon / Adres
  String lokasyon;

  /// Bakım ve kontrol açıklama metni
  String bakimMetni;

  /// Sonuç metni
  String sonucMetni;

  /// İşlem türü
  IslemTuru islemTuru;

  /// Fotoğraf yolları listesi
  List<String> fotograflar;

  /// Rapor oluşturulma tarihi
  DateTime olusturmaTarihi;

  /// Rapor son güncelleme tarihi
  DateTime? guncellemeTarihi;

  TrafoReport({
    required this.id,
    required this.firmaAdi,
    required this.trafoAdi,
    required this.seriNo,
    required this.guc,
    required this.tarih,
    required this.lokasyon,
    this.bakimMetni = '',
    this.sonucMetni = '',
    required this.islemTuru,
    List<String>? fotograflar,
    DateTime? olusturmaTarihi,
    this.guncellemeTarihi,
  })  : fotograflar = fotograflar ?? [],
        olusturmaTarihi = olusturmaTarihi ?? DateTime.now();

  /// Boş rapor oluştur
  factory TrafoReport.yeni() {
    return TrafoReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firmaAdi: '',
      trafoAdi: '',
      seriNo: '',
      guc: '',
      tarih: DateTime.now(),
      lokasyon: '',
      bakimMetni: '',
      sonucMetni: '',
      islemTuru: IslemTuru.bakim,
    );
  }

  /// Raporu kopyala
  TrafoReport copyWith({
    String? id,
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
    DateTime? olusturmaTarihi,
    DateTime? guncellemeTarihi,
  }) {
    return TrafoReport(
      id: id ?? this.id,
      firmaAdi: firmaAdi ?? this.firmaAdi,
      trafoAdi: trafoAdi ?? this.trafoAdi,
      seriNo: seriNo ?? this.seriNo,
      guc: guc ?? this.guc,
      tarih: tarih ?? this.tarih,
      lokasyon: lokasyon ?? this.lokasyon,
      bakimMetni: bakimMetni ?? this.bakimMetni,
      sonucMetni: sonucMetni ?? this.sonucMetni,
      islemTuru: islemTuru ?? this.islemTuru,
      fotograflar: fotograflar ?? List.from(this.fotograflar),
      olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
      guncellemeTarihi: guncellemeTarihi ?? this.guncellemeTarihi,
    );
  }

  /// JSON dönüşümü
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firmaAdi': firmaAdi,
      'trafoAdi': trafoAdi,
      'seriNo': seriNo,
      'guc': guc,
      'tarih': tarih.toIso8601String(),
      'lokasyon': lokasyon,
      'bakimMetni': bakimMetni,
      'sonucMetni': sonucMetni,
      'islemTuru': islemTuru.toJson(),
      'fotograflar': fotograflar,
      'olusturmaTarihi': olusturmaTarihi.toIso8601String(),
      'guncellemeTarihi': guncellemeTarihi?.toIso8601String(),
    };
  }

  /// JSON'dan nesne oluştur
  factory TrafoReport.fromJson(Map<String, dynamic> json) {
    return TrafoReport(
      id: json['id'] as String,
      firmaAdi: json['firmaAdi'] as String,
      trafoAdi: json['trafoAdi'] as String,
      seriNo: json['seriNo'] as String,
      guc: json['guc'] as String,
      tarih: DateTime.parse(json['tarih'] as String),
      lokasyon: json['lokasyon'] as String,
      bakimMetni: json['bakimMetni'] as String? ?? '',
      sonucMetni: json['sonucMetni'] as String? ?? '',
      islemTuru: IslemTuru.fromJson(json['islemTuru'] as String),
      fotograflar: List<String>.from(json['fotograflar'] as List? ?? []),
      olusturmaTarihi: DateTime.parse(json['olusturmaTarihi'] as String),
      guncellemeTarihi: json['guncellemeTarihi'] != null
          ? DateTime.parse(json['guncellemeTarihi'] as String)
          : null,
    );
  }

  /// Form validasyonu
  bool get isValid {
    return firmaAdi.isNotEmpty &&
        trafoAdi.isNotEmpty &&
        seriNo.isNotEmpty &&
        guc.isNotEmpty &&
        lokasyon.isNotEmpty;
  }

  /// Eksik alanları döndür
  List<String> get eksikAlanlar {
    final liste = <String>[];
    if (firmaAdi.isEmpty) liste.add('Firma Adı');
    if (trafoAdi.isEmpty) liste.add('Trafo Adı');
    if (seriNo.isEmpty) liste.add('Seri No');
    if (guc.isEmpty) liste.add('Güç');
    if (lokasyon.isEmpty) liste.add('Lokasyon');
    return liste;
  }

  @override
  String toString() {
    return 'TrafoReport(id: $id, trafoAdi: $trafoAdi, islemTuru: ${islemTuru.label})';
  }
}
