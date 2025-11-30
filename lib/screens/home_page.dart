import 'package:flutter/material.dart';
import '../data/announcements_data.dart';
import '../models/announcement.dart';
import 'forum_screen.dart';
import 'marketplace_screen.dart';
import 'jobs_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  int _jobsTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(onTabChange: (index, {int? subIndex}) {
        setState(() {
          _selectedIndex = index;
          if (subIndex != null && index == 3) {
            _jobsTabIndex = subIndex;
          }
        });
      }),
      const ForumScreen(),
      const MarketplaceScreen(),
      JobsScreen(initialIndex: _jobsTabIndex),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_outlined),
              activeIcon: Icon(Icons.forum),
              label: 'Forum',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Alışveriş',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'İş İlanları',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final Function(int, {int? subIndex}) onTabChange;
  const DashboardScreen({super.key, required this.onTabChange});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = 'Öğrenci';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final profile = await ApiService().fetchUserProfile();
      if (mounted) {
        setState(() {
          _userName = profile['first_name'] ?? profile['fullname'] ?? 'Öğrenci';
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoş Geldin,',
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            Text(
              _userName,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            _buildStories(),
            const SizedBox(height: 24),
            _buildHeroSection(),
            const SizedBox(height: 24),
            Text(
              'Hızlı Erişim',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildNavigationGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildStories() {
    final stories = [
      _Story(
        id: '1',
        name: 'Google',
        avatarUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png',
        imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        title: 'Yazılım Mühendisliği Stajı',
        color: Colors.blue,
      ),
      _Story(
        id: '2',
        name: 'Microsoft',
        avatarUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Microsoft_logo.svg/2048px-Microsoft_logo.svg.png',
        imageUrl: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        title: 'AI Araştırma Projesi',
        color: Colors.green,
      ),
      _Story(
        id: '3',
        name: 'Kızılay',
        avatarUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Turk_Kizilay_Logo.svg/1200px-Turk_Kizilay_Logo.svg.png',
        imageUrl: 'https://images.unsplash.com/photo-1593113598332-cd288d649433?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        title: 'Kan Bağışı Kampanyası',
        color: Colors.red,
      ),
      _Story(
        id: '4',
        name: 'TEGV',
        avatarUrl: 'https://pbs.twimg.com/profile_images/1615285836642844673/Y-y-gQ0__400x400.jpg',
        imageUrl: 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        title: 'Eğitim Gönüllüleri Aranıyor',
        color: Colors.orange,
      ),
      _Story(
        id: '5',
        name: 'Aselsan',
        avatarUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Aselsan_logo.svg/2560px-Aselsan_logo.svg.png',
        imageUrl: 'https://images.unsplash.com/photo-1581092921461-eab62e97a782?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        title: 'Savunma Sanayi Stajı',
        color: Colors.blue[900]!,
      ),
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final story = stories[index];
          return GestureDetector(
            onTap: () => _showStory(context, story),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.orange, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(story.imageUrl),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Fallback if image fails
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  story.name,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showStory(BuildContext context, _Story story) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                // Story Content
                Positioned.fill(
                  child: Column(
                    children: [
                      // Progress Bar (Static for demo)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: story.color,
                              child: Text(
                                story.name[0],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              story.name,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '1s',
                              style: GoogleFonts.outfit(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Image/Content Placeholder
                      Container(
                        height: 400,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(story.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.title,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.onTabChange(3, subIndex: 1); // Go to Jobs (Internship default for stories)
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primary,
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Text(
                                  'İlanı Gör',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        _buildHeroCard(
          title: 'Staj Programları',
          subtitle: 'Kariyerine ilk adımı at',
          icon: Icons.work_outline,
          color: const Color(0xFF4A90E2),
          onTap: () => widget.onTabChange(3, subIndex: 1), // Jobs Tab, Internship
        ),
        const SizedBox(height: 16),
        _buildHeroCard(
          title: 'Gönüllülük',
          subtitle: 'Topluma katkıda bulun',
          icon: Icons.volunteer_activism,
          color: const Color(0xFFFF6B6B),
          onTap: () => widget.onTabChange(3, subIndex: 0), // Jobs Tab, Volunteering
        ),
      ],
    );
  }

  Widget _buildHeroCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 140,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildNavButton(
          title: 'Forum',
          icon: Icons.forum_outlined,
          color: AppTheme.primary,
          onTap: () => widget.onTabChange(1),
        ),
        _buildNavButton(
          title: 'Alışveriş',
          icon: Icons.shopping_bag_outlined,
          color: Colors.orange,
          onTap: () => widget.onTabChange(2),
        ),
        _buildNavButton(
          title: 'İş İlanları',
          icon: Icons.work_outline,
          color: Colors.purple,
          onTap: () => widget.onTabChange(3, subIndex: 2), // Jobs Tab, Job
        ),
        _buildNavButton(
          title: 'Mesajlar',
          icon: Icons.message_outlined,
          color: Colors.teal,
          onTap: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const MessagesScreen()),
             );
          },
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bildirimler ekranı
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _Notification('Yeni Duyuru', 'Bilgisayar Kulübü yeni bir etkinlik paylaştı', '5 dk önce', Icons.campaign),
      _Notification('Yeni Mesaj', 'Ali Yılmaz size mesaj gönderdi', '15 dk önce', Icons.message),
      _Notification('Takip', 'Zeynep Kaya sizi takip etmeye başladı', '1 saat önce', Icons.person_add),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bildirimler',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Tümünü Oku'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.secondaryLight,
                child: Icon(n.icon, color: AppTheme.primary),
              ),
              title: Text(
                n.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.message),
                  const SizedBox(height: 4),
                  Text(
                    n.time,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

class _Notification {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  _Notification(this.title, this.message, this.time, this.icon);
}

// Takip edilenler ekranı
class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final List<_FollowUser> following = [
    _FollowUser('Bilgisayar Kulübü', 'Etkinlikler ve duyurular', true),
    _FollowUser('Müzik Kulübü', 'Konserler ve etkinlikler', true),
    _FollowUser('Yürüyüş Kulübü', 'Doğa yürüyüşleri', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Takip Edilenler',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: following.length,
        itemBuilder: (context, index) {
          final f = following[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primary,
                child: Text(
                  f.name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                f.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(f.description),
              trailing: Switch(
                value: f.notifications,
                onChanged: (v) {
                  setState(() {
                    f.notifications = v;
                  });
                },
                activeColor: AppTheme.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FollowUser {
  final String name;
  final String description;
  bool notifications;
  _FollowUser(this.name, this.description, this.notifications);
}

class _Story {
  final String id;
  final String name;
  final String avatarUrl;
  final String imageUrl;
  final String title;
  final Color color;

  _Story({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.imageUrl,
    required this.title,
    required this.color,
  });
}

// Arama sonuçları ekranı
class SearchResultsScreen extends StatelessWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    // Demo arama sonuçları
    final results = [
      {'type': 'Duyuru', 'title': 'Hackathon 2024', 'subtitle': 'Bilgisayar Kulübü'},
      {'type': 'Forum', 'title': 'Python Proje Arkadaşı', 'subtitle': 'Teknik'},
      {'type': 'Ürün', 'title': 'Lineer Cebir Kitabı', 'subtitle': '150 TL'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE64A19)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '\'$query\' ara',
          style: const TextStyle(
            color: Color(0xFFE64A19),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final r = results[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFFFCCBC),
                child: Icon(
                  r['type'] == 'Duyuru'
                      ? Icons.campaign
                      : r['type'] == 'Forum'
                          ? Icons.forum
                          : Icons.shopping_bag,
                  color: const Color(0xFFE64A19),
                ),
              ),
              title: Text(
                r['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(r['subtitle'] as String),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}



// Duyuru detay ekranı
class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE64A19)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          announcement.title,
          style: const TextStyle(
            color: Color(0xFFE64A19),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(announcement.clubName, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(announcement.date, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 12),
            Text(announcement.fullDescription),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    announcement.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFFC51B1B),
                  ),
                  onPressed: () {},
                ),
                Text('${announcement.likeCount}'),
                const SizedBox(width: 16),
                const Icon(Icons.comment_outlined),
                const SizedBox(width: 8),
                Text('${announcement.comments.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



