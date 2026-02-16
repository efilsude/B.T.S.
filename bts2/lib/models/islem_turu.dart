/// İşlem Türü Enum
/// Raporun hangi tür işlem için oluşturulduğunu belirler
enum IslemTuru {
  bakim('Bakım', 'Bakım İşlemi'),
  kontrol('Kontrol', 'Kontrol İşlemi'),
  ariza('Arıza', 'Arıza Giderimi'),
  inceleme('İnceleme', 'İnceleme İşlemi');

  const IslemTuru(this.label, this.aciklama);

  /// UI'da gösterilecek etiket
  final String label;

  /// Detaylı açıklama
  final String aciklama;

  /// Enum'dan string'e dönüştürme
  String toJson() => name;

  /// String'den enum'a dönüştürme
  static IslemTuru fromJson(String json) {
    return IslemTuru.values.firstWhere(
      (e) => e.name == json,
      orElse: () => IslemTuru.bakim,
    );
  }
}
