class ForumPost {
  final String id;
  final String username;
  final String title;
  final String content;
  final String category;
  final String date;
  final int replies;
  final int likes;

  ForumPost({
    required this.id,
    required this.username,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    required this.replies,
    required this.likes,
  });
}

