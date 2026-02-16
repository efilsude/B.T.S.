# Trafo Bakım Raporlama Uygulaması

## Proje Yapısı (Clean Architecture)

```
lib/
├── main.dart                    # Uygulama giriş noktası
├── models/                      # Veri modelleri
│   ├── trafo_report.dart        # Trafo rapor modeli
│   └── islem_turu.dart          # İşlem türü enum
├── services/                    # İş mantığı servisleri
│   ├── pdf_service.dart         # PDF oluşturma servisi
│   ├── storage_service.dart     # Yerel depolama servisi
│   └── photo_service.dart       # Fotoğraf işleme servisi
├── providers/                   # State management
│   └── report_provider.dart     # Rapor provider
├── screens/                     # Ekranlar
│   ├── home_screen.dart         # Ana sayfa
│   ├── cover_page.dart          # Kapak sayfası
│   ├── report_form.dart         # Rapor formu
│   └── report_list.dart         # Rapor listesi
└── widgets/                     # Tekrar kullanılabilir widgetlar
    ├── custom_button.dart       # Özelleştirilmiş buton
    ├── custom_text_field.dart   # Özelleştirilmiş text field
    └── photo_picker.dart        # Fotoğraf seçici
```

## Teknolojiler
- **Framework:** Flutter
- **State Management:** Provider
- **Local Storage:** Hive
- **PDF:** pdf, printing paketleri
- **Platform:** Android + iOS

## Kurulum
```bash
flutter pub get
flutter run
```
