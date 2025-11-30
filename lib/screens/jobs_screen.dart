import 'package:flutter/material.dart';
import '../models/job.dart';
import '../models/company.dart';
import 'job_category_screen.dart';
import 'job_detail_screen.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'messages_screen.dart';

class JobsScreen extends StatefulWidget {
  final int initialIndex;
  const JobsScreen({super.key, this.initialIndex = 0});

  @override
  State<JobsScreen> createState() => _JobsScreenState();

  static List<Company> getDemoCompanies() {
    return [
      Company(
        id: '1',
        name: 'Renkli Gelecek Derneği',
        description: 'Çocukların eğitimine katkıda bulunmak ve sosyal sorumluluk projeleri geliştirmek amacıyla kurulmuş bir sivil toplum kuruluşudur.',
        employeeCount: '50-100',
        location: 'Ankara',
        website: 'https://renkligelecek.org',
        logoUrl: 'assets/company1.png',
      ),
      Company(
        id: '2',
        name: 'Pati Dostları',
        description: 'Sokak hayvanlarını koruma, besleme ve tedavi etme misyonuyla çalışan gönüllü topluluğu.',
        employeeCount: '10-50',
        location: 'İstanbul',
        website: 'https://patidostlari.com',
        logoUrl: 'assets/company2.png',
      ),
      Company(
        id: '3',
        name: 'TechCorp',
        description: 'Yenilikçi yazılım çözümleri sunan, global ölçekte çalışan bir teknoloji şirketi.',
        employeeCount: '500+',
        location: 'İstanbul',
        website: 'https://techcorp.com',
        logoUrl: 'assets/company3.png',
      ),
      Company(
        id: '4',
        name: 'Global Marketing',
        description: 'Dijital pazarlama ve marka yönetimi konusunda uzmanlaşmış ajans.',
        employeeCount: '100-200',
        location: 'İstanbul',
        website: 'https://globalmarketing.com',
        logoUrl: 'assets/company4.png',
      ),
      Company(
        id: '5',
        name: 'DataSystems',
        description: 'Büyük veri analizi ve yapay zeka çözümleri geliştiren teknoloji firması.',
        employeeCount: '200-500',
        location: 'İstanbul',
        website: 'https://datasystems.com',
        logoUrl: 'assets/company5.png',
      ),
      Company(
        id: '6',
        name: 'Yapı İnşaat A.Ş.',
        description: 'Türkiye\'nin önde gelen inşaat firmalarından biri. Büyük konut ve altyapı projeleri yürütmektedir.',
        employeeCount: '1000+',
        location: 'Ankara',
        website: 'https://yapiinsaat.com',
        logoUrl: 'assets/company6.png',
      ),
      Company(
        id: '7',
        name: 'Enerji Plus',
        description: 'Yenilenebilir enerji ve elektrik altyapı sistemleri üzerine uzmanlaşmış mühendislik firması.',
        employeeCount: '200-500',
        location: 'İzmir',
        website: 'https://enerjiplus.com',
        logoUrl: 'assets/company7.png',
      ),
    ];
  }

  static List<Job> getDemoJobs() {
    return [
      // Volunteering
      Job(
        id: '1',
        title: 'Köy Okulu Boyama',
        company: 'Renkli Gelecek Derneği',
        companyId: 'c1',
        description: 'Hafta sonu köy okulunu boyamak için gönüllüler arıyoruz. Ulaşım ve yemek derneğimiz tarafından karşılanacaktır. Çocuklarla vakit geçirmeyi seven, enerjik arkadaşlar arıyoruz.',
        type: 'Gönüllü',
        location: 'Ankara',
        postedDate: '1 gün önce',
        category: 'Volunteering',
        requirements: ['18 yaşından büyük olmak', 'Takım çalışmasına yatkınlık', 'Çocuklarla iletişim becerisi'],
        contactEmail: 'iletisim@renkligelecek.org',
        bannerUrl: 'https://images.unsplash.com/photo-1531206715517-5c0ba140b2b8?auto=format&fit=crop&q=80&w=800',
        tags: ['Sosyal Sorumluluk', 'Eğitim', 'Hafta Sonu'],
      ),
      Job(
        id: '2',
        title: 'Barınak Ziyareti',
        company: 'Pati Dostları',
        companyId: 'c2',
        description: 'Barınaktaki dostlarımızı beslemek ve onlarla ilgilenmek için bekliyoruz. Mama bağışı yapmak isteyenler de katılabilir.',
        type: 'Gönüllü',
        location: 'İstanbul',
        postedDate: '2 gün önce',
        category: 'Volunteering',
        requirements: ['Hayvan sevgisi', 'Sorumluluk sahibi olmak'],
        contactEmail: 'info@patidostlari.com',
        bannerUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&q=80&w=800',
        tags: ['Hayvan Hakları', 'Barınak', 'Yardımlaşma'],
      ),
      
      // Jobs
      Job(
        id: '9',
        title: 'Junior Backend Developer',
        company: 'DataSystems',
        companyId: 'c5',
        description: 'Node.js ve MongoDB bilen geliştirici aranıyor. Microservices mimarisi üzerinde çalışılacak.',
        type: 'Tam Zamanlı',
        location: 'İstanbul',
        postedDate: '1 gün önce',
        category: 'Job',
        requirements: ['Node.js, Express.js', 'MongoDB, Redis', 'Docker deneyimi', 'İyi derecede İngilizce'],
        contactEmail: 'jobs@datasystems.com',
        bannerUrl: 'https://images.unsplash.com/photo-1555099962-4199c345e5dd?auto=format&fit=crop&q=80&w=800',
        tags: ['Backend', 'Yazılım', 'Mühendislik'],
      ),
      Job(
        id: '10',
        title: 'İnşaat Mühendisi',
        company: 'Yapı İnşaat A.Ş.',
        companyId: 'c6',
        description: 'Büyük ölçekli konut projemizde görev alacak, saha deneyimi olan inşaat mühendisi arıyoruz.',
        type: 'Tam Zamanlı',
        location: 'Ankara',
        postedDate: '2 gün önce',
        category: 'Job',
        requirements: ['İnşaat Mühendisliği mezunu', 'En az 3 yıl şantiye deneyimi', 'AutoCAD ve MS Office bilgisi'],
        contactEmail: 'ik@yapiinsaat.com',
        bannerUrl: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&q=80&w=800',
        tags: ['İnşaat', 'Saha', 'Mühendislik'],
      ),
      Job(
        id: '11',
        title: 'Şantiye Şefi',
        company: 'Yapı İnşaat A.Ş.',
        companyId: 'c6',
        description: 'Şantiye organizasyonunu ve iş programını yönetecek deneyimli şantiye şefi.',
        type: 'Tam Zamanlı',
        location: 'Ankara',
        postedDate: '3 gün önce',
        category: 'Job',
        requirements: ['İnşaat Mühendisliği veya Mimarlık mezunu', 'En az 7 yıl deneyim', 'Liderlik vasıfları'],
        contactEmail: 'ik@yapiinsaat.com',
        bannerUrl: 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&q=80&w=800',
        tags: ['İnşaat', 'Yönetim', 'Saha'],
      ),
      Job(
        id: '12',
        title: 'Elektrik Ustası',
        company: 'Enerji Plus',
        companyId: 'c7',
        description: 'Bina elektrik tesisatı ve pano montajı konularında deneyimli elektrik ustası.',
        type: 'Tam Zamanlı',
        location: 'İzmir',
        postedDate: '1 gün önce',
        category: 'Job',
        requirements: ['Meslek Lisesi veya MYO mezunu', 'Elektrik tesisatında deneyimli', 'B sınıfı ehliyet'],
        contactEmail: 'kariyer@enerjiplus.com',
        bannerUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&q=80&w=800',
        tags: ['Elektrik', 'Teknik', 'Saha'],
      ),
      Job(
        id: '13',
        title: 'Elektrik Teknikeri',
        company: 'Enerji Plus',
        companyId: 'c7',
        description: 'Bakım ve onarım ekiplerinde görev alacak, arıza tespiti yapabilen elektrik teknikeri.',
        type: 'Tam Zamanlı',
        location: 'İzmir',
        postedDate: '4 gün önce',
        category: 'Job',
        requirements: ['Elektrik Teknikerliği mezunu', 'Proje okuma becerisi', 'Takım çalışmasına yatkın'],
        contactEmail: 'kariyer@enerjiplus.com',
        bannerUrl: 'https://images.unsplash.com/photo-1581092921461-eab62e97a782?auto=format&fit=crop&q=80&w=800',
        tags: ['Elektrik', 'Bakım', 'Teknik'],
      ),
    ];
  }
}

class _JobsScreenState extends State<JobsScreen> {
  List<Job> jobs = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  int _selectedIndex = 0;
  
  // Sub-categories for Internships
  int _subSelectedIndex = 0;
  List<Map<String, dynamic>> _subCategories = [{'id': 'all', 'name': 'Tümü'}];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadData();
  }

  @override
  void didUpdateWidget(JobsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Load demo jobs first
    jobs = JobsScreen.getDemoJobs();

    try {
      // Fetch categories and internships in parallel
      final results = await Future.wait([
        _apiService.fetchInternshipCategories(),
        _apiService.fetchInternships(),
      ]);

      final categories = results[0] as List<Map<String, dynamic>>;
      final internships = results[1] as List<Job>;

      setState(() {
        _subCategories = [{'id': 'all', 'name': 'Tümü'}, ...categories];
        jobs.addAll(internships);
      });
    } catch (e) {
      print('Error loading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veriler yüklenemedi: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onSubTabChanged(int index) async {
    setState(() {
      _subSelectedIndex = index;
      _isLoading = true;
    });

    try {
      final category = _subCategories[index];
      List<Job> fetchedJobs = [];

      // Always reload demo jobs + initial fetch logic if "Tümü"
      // But for simplicity, let's just fetch from API based on selection
      // If "Tümü" (id: 'all'), we fetch all internships again or use cached?
      // User asked to fetch from endpoint for categories.
      // Let's re-fetch all for "Tümü" to be safe and consistent.
      
      if (category['id'] == 'all') {
         fetchedJobs = await _apiService.fetchInternships();
      } else {
         fetchedJobs = await _apiService.fetchInternshipsByCategory(category['id']);
      }

      setState(() {
        // Clear existing internships but keep demo jobs? 
        // Or just replace everything? 
        // Let's keep demo jobs for now as they are hardcoded.
        jobs = JobsScreen.getDemoJobs(); 
        jobs.addAll(fetchedJobs);
      });

    } catch (e) {
      print('Error fetching jobs for category: $e');
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İlanlar yüklenemedi: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_selectedIndex == 1 ? 110 : 60),
          child: Column(
            children: [
              _buildCustomTabBar(),
              if (_selectedIndex == 1) ...[
                const SizedBox(height: 10),
                _buildSubTabBar(),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(
                key: ValueKey<String>('$_selectedIndex-$_subSelectedIndex'),
                child: _buildJobList(
                  _selectedIndex == 0
                      ? 'Volunteering'
                      : _selectedIndex == 1
                          ? 'Internship'
                          : 'Job',
                ),
              ),
            ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTabButton(0, 'Gönüllülük'),
          const SizedBox(width: 10),
          _buildTabButton(1, 'Staj'),
          const SizedBox(width: 10),
          _buildTabButton(2, 'İş İlanları'),
        ],
      ),
    );
  }

  Widget _buildSubTabBar() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _subCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return _buildSubTabButton(index, _subCategories[index]['name']);
        },
      ),
    );
  }

  Widget _buildSubTabButton(int index, String text) {
    final isSelected = _subSelectedIndex == index;
    return GestureDetector(
      onTap: () => _onSubTabChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: GoogleFonts.outfit(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
            child: Text(text),
          ),
        ),
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
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black.withOpacity(isSelected ? 0.0 : 0.2),
            width: 1,
          ),
        ),
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
    );
  }

  Widget _buildJobList(String category) {
    final filteredJobs = jobs.where((job) {
      // Main category filter
      bool matchesCategory = job.category == category;
      
      // Sub-category filtering is now handled by API fetching
      // We just display what's in the 'jobs' list for Internships
      // But we still need to filter out non-Internship jobs if we are in Internship tab
      // Wait, 'jobs' contains everything (demo + fetched).
      // If we are in Internship tab, we re-fetched 'jobs' to contain specific category jobs.
      // BUT, 'jobs' also contains 'Volunteering' and 'Job' demo data.
      // So we still need to filter by main category.
      
      return matchesCategory;
    }).toList();

    if (filteredJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Bu kategoride ilan bulunamadı.',
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) {
        final job = filteredJobs[index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildJobCard(Job job) {
    return Hero(
      tag: 'job_${job.id}',
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => FractionallySizedBox(
                heightFactor: 0.9,
                child: JobDetailScreen(job: job),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              if (job.bannerUrl != null && job.bannerUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    job.bannerUrl!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: AppTheme.secondaryLight,
                      child: const Icon(Icons.business, size: 48, color: AppTheme.primary),
                    ),
                  ),
                ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (job.type.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              job.type,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.primaryDark,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<Company>(
                      future: ApiService().fetchCompanyDetails(job.companyId),
                      builder: (context, snapshot) {
                        String companyName = job.company;
                        if (snapshot.hasData) {
                          companyName = snapshot.data!.name;
                        }
                        return Text(
                          companyName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          job.location,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12, decoration: TextDecoration.none),
                        ),
                        const Spacer(),
                        Text(
                          _formatTimeAgo(job.postedDate),
                          style: TextStyle(color: Colors.grey[400], fontSize: 12, decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} gün önce';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} saat önce';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} dakika önce';
      } else {
        return 'Az önce';
      }
    } catch (e) {
      return dateString;
    }
  }
}

