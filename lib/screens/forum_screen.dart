import 'package:flutter/material.dart';
import '../models/forum_post.dart';
import 'forum_helpers.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'messages_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  int _selectedIndex = 0;
  final List<String> _categories = ['Tümü', 'Genel', 'Akademik', 'Teknik', 'Spontane', 'Sosyal'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 4.0,
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        toolbarHeight: 80,
        titleSpacing: 0,
        title: SizedBox(
          height: 60,
          child: Image.asset(
            'lib/data/logo.png',
            fit: BoxFit.fitHeight,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.message_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MessagesScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildCustomTabBar(),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildPostList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewForumPostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(bottom: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _buildTabButton(index, _categories[index]),
      ),
    );
  }

  Widget _buildTabButton(int index, String text) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black.withOpacity(isSelected ? 0.0 : 0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  Widget _buildPostList() {
    final allPosts = _getDemoPosts();
    final category = _categories[_selectedIndex];
    final posts = category == 'Tümü'
        ? allPosts
        : allPosts.where((p) => p.category == category).toList();

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Henüz konu yok',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      key: ValueKey<int>(_selectedIndex), // Key for AnimatedSwitcher
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: posts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          elevation: 0,
          margin: EdgeInsets.zero, // Handled by separator
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFEEEEEE)), // Safe color
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForumPostDetailScreen(post: post),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.primary,
                        child: Text(
                          post.username.isNotEmpty ? post.username[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              post.category,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        post.date,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${post.replies} cevap',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.thumb_up, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _SearchForumDialog(posts: _getDemoPosts()),
    );
  }

  List<ForumPost> _getDemoPosts() {
    return [
      ForumPost(
        id: '9',
        username: 'Elif S.',
        title: 'Staj Başvuru Süreci',
        content: 'Yaz stajı için hangi şirketlere başvurulmalı? Deneyimlerinizi paylaşabilir misiniz?',
        category: 'Genel',
        date: '2 gün önce',
        replies: 12,
        likes: 7,
      ),
      ForumPost(
        id: '6',
        username: 'Burak M.',
        title: 'Kayıt Yenileme',
        content: 'Kayıt yenileme işlemleri için son gün ne zaman? Öğrenci işlerine mi gitmem lazım?',
        category: 'Genel',
        date: '1 gün önce',
        replies: 8,
        likes: 14,
      ),
      ForumPost(
        id: '2',
        username: 'Ahmet Y.',
        title: 'Lineer Cebir Vize Konuları',
        content: 'Arkadaşlar vize sınavında hangi konular çıkacak bilen var mı? Matris işlemleri dahil mi?',
        category: 'Akademik',
        date: '2 saat önce',
        replies: 5,
        likes: 12,
      ),
      ForumPost(
        id: '3',
        username: 'Mehmet A.',
        title: 'Veri Yapıları Final Hazırlık',
        content: 'Final için çalışma grubu kuralım mı? Ağaçlar ve graf algoritmaları üzerinde çalışacağız.',
        category: 'Akademik',
        date: '3 saat önce',
        replies: 6,
        likes: 9,
      ),
      ForumPost(
        id: '5',
        username: 'Zeynep K.',
        title: 'Python Proje Arkadaşı',
        content: 'Web scraping projesi için ekip arkadaşı arıyorum. BeautifulSoup ve Selenium kullanacağız.',
        category: 'Teknik',
        date: '5 saat önce',
        replies: 3,
        likes: 7,
      ),
      ForumPost(
        id: '7',
        username: 'Cem B.',
        title: 'React Native vs Flutter',
        content: 'Mobil uygulama projesi için hangisi daha iyi? Deneyimli olan var mı?',
        category: 'Teknik',
        date: '6 saat önce',
        replies: 11,
        likes: 18,
      ),
      ForumPost(
        id: '1',
        username: 'Koray Ç.',
        title: 'Halı Saha Maçı - 2 Kişi Lazım',
        content: 'Saat 17:00\'de kampüs arkası halı sahada maç var. 2 kişi eksik, gelebilecek var mı?',
        category: 'Spontane',
        date: '15 dk önce',
        replies: 4,
        likes: 8,
      ),
      ForumPost(
        id: '4',
        username: 'Murat D.',
        title: 'Sabah Koşusu - Yarın 07:00',
        content: 'Yarın sabah 7\'de kampüs parkında koşu yapacağım. Katılmak isteyen mesaj atsın!',
        category: 'Spontane',
        date: '1 saat önce',
        replies: 6,
        likes: 12,
      ),
      ForumPost(
        id: '8',
        username: 'Can D.',
        title: 'Kampüste En İyi Kafe',
        content: 'Arkadaşlar hangi kafede oturmayı tercih ediyorsunuz? Fiyat/performans önemli!',
        category: 'Sosyal',
        date: '1 gün önce',
        replies: 8,
        likes: 15,
      ),
      ForumPost(
        id: '10',
        username: 'Gizem A.',
        title: 'Kitap Kulübü Kuralım',
        content: 'Ayda bir kitap okuyup tartışabileceğimiz bir kulüp kurmak istiyorum. İlgilenen var mı?',
        category: 'Sosyal',
        date: '2 gün önce',
        replies: 14,
        likes: 22,
      ),
    ];
  }
}

// Forum arama dialogu
class _SearchForumDialog extends StatefulWidget {
  final List<ForumPost> posts;
  const _SearchForumDialog({required this.posts});

  @override
  State<_SearchForumDialog> createState() => _SearchForumDialogState();
}

class _SearchForumDialogState extends State<_SearchForumDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<ForumPost> _filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _filteredPosts = widget.posts;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPosts = widget.posts;
      } else {
        _filteredPosts = widget.posts.where((post) {
          return post.title.toLowerCase().contains(query) ||
              post.content.toLowerCase().contains(query) ||
              post.username.toLowerCase().contains(query) ||
              post.category.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.secondaryLight, AppTheme.secondaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppTheme.primaryDark),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Konu Ara',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.primaryDark),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Arama çubuğu
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Başlık, içerik veya yazar ara...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.secondaryLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primary, width: 2),
                  ),
                ),
              ),
            ),
            // Sonuçlar
            Flexible(
              child: _filteredPosts.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'Sonuç bulunamadı',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = _filteredPosts[index];
                        return ListTile(
                          title: Text(
                            post.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${post.username} • ${post.category}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumPostDetailScreen(post: post),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}



