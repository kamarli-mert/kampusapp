import '../models/announcement.dart';

class AnnouncementsData {
  static List<Announcement> getAllAnnouncements() {
    final now = DateTime.now();
    
    return [
      // Öne Çıkan 3 Duyuru
      Announcement(
        id: '1',
        clubName: 'Bilgisayar Kulübü',
        title: 'Hackathon 2024 🔥',
        shortDescription: '24 saat kod yazcanız arkadaşlar! Yapay zeka ve ML konularında proje yapıcaz',
        fullDescription: '24 saatlik kodlama maratonu! Ödüller ve sürprizler sizi bekliyor.\n\nEtkinlik Detayları:\n- 15 Kasım Cumartesi 09:00\n- Takımlar 3-5 kişilik olacak\n- Her takıma mentor atanacak\n- Yemek ve içecek ücretsiz\n\nÖdüller:\n1. Takım: 10.000 TL\n2. Takım: 5.000 TL\n3. Takım: 2.500 TL\n\nKayıt için: hackathon@bilkom.edu.tr',
        date: '2 saat önce',
        location: 'Mühendislik A201',
        eventDate: now.add(const Duration(days: 3)),
        likeCount: 145,
        category: 'Teknik',
        comments: [
          Comment(id: '1', userName: 'Ayşe Y.', content: 'Harika bir etkinlik olacak gibi!', date: '10 Kasım'),
          Comment(id: '2', userName: 'Mehmet K.', content: 'Takım arkadaşı arıyorum, ilgilenenler mesaj atabilir.', date: '11 Kasım'),
        ],
      ),
      Announcement(
        id: '2',
        clubName: 'Müzik Kulübü',
        title: 'Bahar konseri geliooo',
        shortDescription: 'Kampüsteki tum gruplar sahne alıcak, akustik set var şiir dinletisi de olcak',
        fullDescription: 'Öğrenci gruplarımızın performansları ile unutulmaz bir gece!\n\nProgram:\n19:00 - Kapılar açılır\n19:30 - Echo Band\n20:15 - Akustik Ruhlar\n21:00 - Ara\n21:30 - Campus Voices\n22:30 - Final\n\nGiriş ücretsizdir. Kontenjan sınırlıdır.',
        date: '5 saat önce',
        location: 'Konferans Salonu',
        eventDate: now.add(const Duration(days: 5)),
        likeCount: 98,
        category: 'Kültürel',
        comments: [
          Comment(id: '1', userName: 'Zeynep A.', content: 'Çok heyecanlıyım!', date: '15 Kasım'),
        ],
      ),
      Announcement(
        id: '3',
        clubName: 'Spor Kulübü',
        title: 'Basketbol Turnuvası ⛹️',
        shortDescription: 'Fakülteler arası maçlar başlıyo, gelip destekleyin bizi!',
        fullDescription: 'Takımlar arası basketbol turnuvası. Katılım ücretsiz!\n\nTurnuva Formatı:\n- 5v5 basketbol\n- Grup aşaması + Eleme\n- Her takım en az 3 maç garanti\n\nKurallar:\n- Sadece öğrenciler katılabilir\n- Takım başına maksimum 8 oyuncu\n- Hakem kararları kesindir\n\nKayıt: sporkulubu@edu.tr',
        date: 'Dün',
        location: 'Spor Salonu',
        eventDate: now.add(const Duration(days: 7)),
        likeCount: 76,
        category: 'Sportif',
      ),
      
      // Diğer Duyurular
      Announcement(
        id: '4',
        clubName: 'Yazılım Kulübü',
        title: 'Flutter Workshop var',
        shortDescription: 'Mobil app yapmayı öğrenin gelin, sıfırdan başlıcaz',
        fullDescription: 'Sıfırdan mobil uygulama geliştirmeyi öğrenin. Flutter framework ile Android ve iOS uygulamaları geliştirmeyi öğreneceksiniz.\n\nKatılım için kayıt gerekli.',
        date: '30 dk önce',
        location: 'Bilgisayar Lab 3',
        isFollowing: false,
        likeCount: 54,
        category: 'Teknik',
        eventDate: now.add(const Duration(days: 2)),
      ),
      Announcement(
        id: '5',
        clubName: 'Fotoğraf Kulübü',
        title: 'Portre çekimi nasıl yapılır?',
        shortDescription: 'Profesyonel fotoğrafçı gelcek, ışık kullanımı falan anlatıcak',
        fullDescription: 'Portre çekiminde ışık kullanımı ve kompozisyon teknikleri. Profesyonel fotoğrafçımız tecrübelerini paylaşacak.',
        date: '1 saat önce',
        location: 'Sanat Atelye',
        isFollowing: true,
        likeCount: 42,
        category: 'Kültürel',
        eventDate: now.add(const Duration(days: 4)),
      ),
      Announcement(
        id: '6',
        clubName: 'Tiyatro Kulübü',
        title: 'OYUNCU ARIYORUZZZ',
        shortDescription: 'Yeni oyun icin kadın erkek oyuncu lazım, deneme çekimleri yapılıcak',
        fullDescription: 'Bahar dönemi oyunu için deneme çekimleri. Deneyim şart değil, isteyen herkes katılabilir!',
        date: '2 saat önce',
        isFollowing: false,
        likeCount: 67,
        category: 'Kültürel',
        eventDate: now.add(const Duration(days: 10)),
      ),
      Announcement(
        id: '7',
        clubName: 'Girişimcilik Kulübü',
        title: 'Startup Pitch Day 🚀',
        shortDescription: 'Start-up fikriniz varsa gelin sunun, yatırımcılar olcak',
        fullDescription: 'Genç girişimciler için fırsat. Fikirlerinizi yatırımcılara sunun, geri bildirim alın ve networking yapın.',
        date: '3 saat önce',
        location: 'İnovasyon Merkezi',
        isFollowing: true,
        likeCount: 89,
        category: 'Akademik',
        eventDate: now.add(const Duration(days: 6)),
      ),
      Announcement(
        id: '8',
        clubName: 'Yürüyüş Kulübü',
        title: 'Haftasonu dağa çıkıyozz',
        shortDescription: 'Likya yolunda 2 gunluk kamp, çadır getirin',
        fullDescription: 'Likya yolunda 2 günlük kamp. Doğayla iç içe harika bir hafta sonu geçireceğiz.',
        date: '5 saat önce',
        likeCount: 38,
        category: 'Sosyal',
        isFollowing: false,
        eventDate: now.add(const Duration(days: 2)),
      ),
      Announcement(
        id: '9',
        clubName: 'Satranç Kulübü',
        title: 'Satranç turnuvası var',
        shortDescription: 'Kim daha iyi oynuyo görelim, blitz ve klasik var',
        fullDescription: 'Blitz ve klasik kategorilerde yarışma. Her seviyeden oyuncu katılabilir.',
        date: '6 saat önce',
        location: 'Öğrenci Merkezi',
        isFollowing: false,
        likeCount: 31,
        category: 'Sosyal',
        eventDate: now.add(const Duration(days: 8)),
      ),
      Announcement(
        id: '10',
        clubName: 'Edebiyat Kulübü',
        title: 'Kitap Okuma Kulübü toplantısı',
        shortDescription: 'Bu ay Sabahattin Ali okuyoruz, tartışma yapıcaz',
        fullDescription: 'Aylık kitap okuma kulübü toplantısı. Bu ay Sabahattin Ali\'nin eserlerini okuyup tartışacağız.',
        date: '7 saat önce',
        location: 'Kütüphane Toplantı Odası',
        isFollowing: false,
        likeCount: 28,
        category: 'Kültürel',
        eventDate: now.add(const Duration(days: 5)),
      ),
      Announcement(
        id: '11',
        clubName: 'Voleybol Kulübü',
        title: 'Voleybol turnuvası kayıtları başladı',
        shortDescription: 'Fakülte takımları arası turnuva, erkek ve kadın kategorileri var',
        fullDescription: 'Fakülte takımları arası voleybol turnuvası. Hem erkek hem kadın kategorilerinde yarışmalar olacak.',
        date: '8 saat önce',
        location: 'Spor Salonu',
        isFollowing: true,
        likeCount: 52,
        category: 'Sportif',
        eventDate: now.add(const Duration(days: 12)),
      ),
      Announcement(
        id: '12',
        clubName: 'Robotik Kulübü',
        title: 'Robot yarışması hazırlıkları',
        shortDescription: 'TÜBİTAK yarışmasına hazırlanıyoz, ekip üyesi lazım',
        fullDescription: 'TÜBİTAK robot yarışmasına hazırlanıyoruz. Arduino, Raspberry Pi konusunda tecrübesi olanlar ekibe katılabilir.',
        date: '10 saat önce',
        location: 'Robotik Lab',
        isFollowing: false,
        likeCount: 61,
        category: 'Teknik',
        eventDate: now.add(const Duration(days: 15)),
      ),
      Announcement(
        id: '13',
        clubName: 'Sosyal Sorumluluk Kulübü',
        title: 'Hayvan barınağına yardım',
        shortDescription: 'Cumartesi günü hayvan barınağına gidiyoz, gönüllüler bekliyoruz',
        fullDescription: 'Hayvan barınağına gönüllü ziyareti. Barınaktaki hayvanlara mama ve bakım yardımı yapacağız.',
        date: 'Dün',
        location: 'Kampus Girişi (Toplanma)',
        isFollowing: true,
        likeCount: 94,
        category: 'Sosyal',
        eventDate: now.add(const Duration(days: 4)),
      ),
      Announcement(
        id: '14',
        clubName: 'Akademik Kulüp',
        title: 'Yüksek Lisans semineri',
        shortDescription: 'Yurt dışı yüksek lisans başvuruları hakkında bilgilendirme',
        fullDescription: 'Yurt dışı yüksek lisans başvuruları, burs imkanları ve sınav hazırlık süreci hakkında detaylı bilgilendirme semineri.',
        date: 'Dün',
        location: 'Konferans Salonu B',
        isFollowing: false,
        likeCount: 73,
        category: 'Akademik',
        eventDate: now.add(const Duration(days: 3)),
      ),
      Announcement(
        id: '15',
        clubName: 'Halk Oyunları Kulübü',
        title: 'Halk oyunları gösterisi provası',
        shortDescription: 'Yıl sonu gösterisi için son provalar, herkes gelebilir',
        fullDescription: 'Yıl sonu gösterisi için son provalar başladı. Yeni üyeler de aramıza katılabilir!',
        date: '2 gün önce',
        location: 'Spor Salonu',
        isFollowing: false,
        likeCount: 45,
        category: 'Kültürel',
        eventDate: now.add(const Duration(days: 20)),
      ),
    ];
  }

  // Öne çıkan duyuruları getir (ilk 3)
  static List<Announcement> getFeaturedAnnouncements() {
    return getAllAnnouncements().take(3).toList();
  }

  // Kategoriye göre filtrele
  static List<Announcement> getAnnouncementsByCategory(String category) {
    if (category == 'Tümü') {
      return getAllAnnouncements();
    }
    return getAllAnnouncements()
        .where((a) => a.category == category)
        .toList();
  }
}

