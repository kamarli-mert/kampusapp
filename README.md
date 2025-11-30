# Kampüs Uygulaması

Üniversite öğrencileri için tasarlanmış kapsamlı bir mobil uygulama. Flutter ile geliştirilmiştir.

## Özellikler

✅ **Topluluk Duyuruları ve Etkinlikler** - Kampüsteki kulüplerin duyurularını takip edin
✅ **Soru-Cevap Forumu** - Öğrenciler arası akademik yardımlaşma
✅ **İkinci El Alışveriş** - Kampüste ürün alım-satımı
✅ **Otobüs Takip** - Kampüs otobüslerinin anlık konumları
✅ **İş İlanları** - Öğrenciler için staj ve part-time fırsatları
✅ **Cafe İndirimleri** - Kampüs çevresindeki cafe kampanyaları
✅ **Kayıp Eşya** - Kayıp ve bulunmuş eşya bildirimleri
✅ **Yemekhane Menüsü** - Günlük ve haftalık menü bilgileri
✅ **Ders Notları Paylaşımı** - Ders notu ve döküman paylaşımı
✅ **Etüt Arkadaşı Bulma** - Birlikte çalışmak için arkadaş bulun
✅ **Anlık Mesajlaşma** - Öğrenciler arası mesajlaşma

## Kurulum

### Gereksinimler
- Flutter SDK (3.0.0 veya üzeri)
- Dart SDK
- Android Studio / VS Code
- Android Emulator veya iOS Simulator

### Adımlar

1. Flutter SDK'yı indirin ve kurun:
```bash
# https://flutter.dev/docs/get-started/install
```

2. Projeyi klonlayın veya indirin

3. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## Proje Yapısı

```
lib/
├── main.dart                 # Uygulama giriş noktası
├── screens/                  # Tüm ekranlar
│   ├── home_page.dart
│   ├── announcements_screen.dart
│   ├── forum_screen.dart
│   ├── marketplace_screen.dart
│   ├── bus_tracking_screen.dart
│   ├── jobs_screen.dart
│   ├── cafe_discounts_screen.dart
│   ├── lost_found_screen.dart
│   ├── cafeteria_menu_screen.dart
│   ├── notes_screen.dart
│   ├── study_buddy_screen.dart
│   └── messages_screen.dart
├── models/                   # Data modelleri
│   ├── announcement.dart
│   ├── forum_post.dart
│   ├── marketplace_item.dart
│   ├── bus.dart
│   ├── job.dart
│   ├── cafe_discount.dart
│   ├── lost_item.dart
│   ├── menu.dart
│   ├── note.dart
│   ├── study_buddy.dart
│   └── chat.dart
├── widgets/                  # Özel widget'lar
└── services/                 # API ve servis katmanı
```

## Kullanılan Teknolojiler

- **Flutter** - UI framework
- **Material Design 3** - Modern ve temiz tasarım
- **Provider** - State yönetimi (gelecekte eklenecek)
- **Dart** - Programlama dili

## Özellikler ve Performans

- 🚀 Hafif ve hızlı
- 📱 Responsive tasarım
- 🎨 Modern Material Design 3 arayüzü
- 🔄 Bottom Navigation ile kolay gezinme
- 💾 Düşük sistem gereksinimleri
- 🔋 Optimize edilmiş pil kullanımı

## Gelecek Özellikler

- [ ] Backend API entegrasyonu
- [ ] Kullanıcı kimlik doğrulama
- [ ] Push bildirimler
- [ ] Gerçek zamanlı mesajlaşma
- [ ] Harita entegrasyonu (otobüs takip için)
- [ ] Dosya yükleme ve indirme
- [ ] Profil yönetimi
- [ ] Arama ve filtreleme
- [ ] Karanlık tema desteği

## Katkıda Bulunma

Bu proje hackathon için geliştirilmiştir. Katkılarınızı bekliyoruz!

## Lisans

Bu proje MIT lisansı altında sunulmaktadır.

## İletişim

Sorularınız için proje ekibiyle iletişime geçin.
