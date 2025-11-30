class Announcement {
  final String id;
  final String clubName;
  final String title;
  final String shortDescription;  // Kısa açıklama 
  final String fullDescription;   // Detaylı açıklama 
  final String date;
  final String? location;
  int likeCount;
  bool isLiked;
  final List<Comment> comments;
  final DateTime? eventDate;  // Etkinlik tarihi (opsiyonel)
  bool isFollowing;  // Kulüp takip durumu
  final String category;  // Kategori: Sportif, Akademik, Kültürel, Sosyal, Teknik

  Announcement({
    required this.id,
    required this.clubName,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.date,
    this.location,
    this.likeCount = 0,
    this.isLiked = false,
    List<Comment>? comments,
    this.eventDate,
    this.isFollowing = false,
    this.category = 'Diğer',
  }) : comments = comments ?? [];
}

class Comment {
  final String id;
  final String userName;
  final String content;
  final String date;

  Comment({
    required this.id,
    required this.userName,
    required this.content,
    required this.date,
  });
}

