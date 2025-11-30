import 'package:flutter/material.dart';
import '../models/job.dart';
import '../models/company.dart';
import 'company_profile_screen.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';

class JobDetailScreen extends StatefulWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  String _formatTimeAgo(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} yıl önce';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} ay önce';
      } else if (difference.inDays > 0) {
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

  Future<void> _navigateToCompanyProfile(BuildContext context, String companyId) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final apiService = ApiService();
      final company = await apiService.fetchCompanyDetails(companyId);
      final companyJobs = await apiService.fetchCompanyInternships(companyId);

      if (!mounted) return;
      
      // Hide loading indicator
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompanyProfileScreen(
            company: company,
            companyJobs: companyJobs,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      // Hide loading indicator
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şirket bilgileri alınamadı: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header and Description Section
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Hero(
                            tag: 'job_${widget.job.id}',
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryLight,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 3,
                                    blurRadius: 4,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: (widget.job.bannerUrl != null && widget.job.bannerUrl!.isNotEmpty)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        widget.job.bannerUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.business, size: 40, color: AppTheme.primary),
                                      ),
                                    )
                                  : const Icon(Icons.business, size: 40, color: AppTheme.primary),
                            ),
                          ),

                          // Content
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.job.title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.bookmark_border, color: AppTheme.primary),
                                      onPressed: () {
                                        // Bookmark functionality
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Description
                                Text(
                                  widget.job.description,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black87,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Metadata
                                InkWell(
                                  onTap: () => _navigateToCompanyProfile(context, widget.job.companyId),
                                  child: FutureBuilder<Company>(
                                    future: ApiService().fetchCompanyDetails(widget.job.companyId),
                                    builder: (context, snapshot) {
                                      String companyName = widget.job.company;
                                      if (snapshot.hasData) {
                                        companyName = snapshot.data!.name;
                                      }
                                      return Text(
                                        companyName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Date and Contact Info
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Yayınlanma: ${_formatTimeAgo(widget.job.postedDate)}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 14, decoration: TextDecoration.none),
                                    ),
                                  ],
                                ),
                                if (widget.job.contactEmail != null && widget.job.contactEmail!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.job.contactEmail!,
                                        style: TextStyle(color: Colors.grey[600], fontSize: 14, decoration: TextDecoration.none),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 16),

                                // Tags
                                Row(
                                  children: [
                                    _buildTag(Icons.location_on_outlined, widget.job.location),
                                    const SizedBox(width: 12),
                                    _buildTag(Icons.access_time, widget.job.type),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          ],
                        ),
                      ),
                    
                    // Similar Jobs Section
                    _buildSimilarJobs(context),

                    const SizedBox(height: 100), // Bottom padding for FAB
                  ],
                ),
              ),
              bottomSheet: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Başvurunuz başarıyla alındı!'),
                            backgroundColor: AppTheme.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Hemen Başvur',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarJobs(BuildContext context) {
    // Mock similar jobs
    final similarJobs = [
      Job(
        id: '99',
        title: 'Senior Flutter Developer',
        company: 'Tech Solutions',
        description: 'We are looking for an experienced Flutter developer...',
        type: 'Tam Zamanlı',
        location: 'İstanbul',
        postedDate: '2023-11-20',
        category: 'Job',
        companyId: 'tech_solutions',
        bannerUrl: 'https://images.unsplash.com/photo-1551434678-e076c223a692?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        tags: ['Flutter', 'Dart', 'Mobile'],
      ),
      Job(
        id: '100',
        title: 'Junior Mobile Developer',
        company: 'App Studio',
        description: 'Join our team as a junior developer...',
        type: 'Yarı Zamanlı',
        location: 'Ankara',
        postedDate: '2023-11-22',
        category: 'Internship',
        companyId: 'app_studio',
        bannerUrl: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        tags: ['iOS', 'Swift', 'Mobile'],
      ),
    ];

    if (similarJobs.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Benzer İlanlar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180, // Fixed height for carousel
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: similarJobs.length,
              itemBuilder: (context, index) {
                final job = similarJobs[index];
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        // Close current bottom sheet and open new one
                        Navigator.pop(context);
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
                          // Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Container(
                              height: 80,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: (job.bannerUrl != null && job.bannerUrl!.isNotEmpty)
                                  ? Image.network(
                                      job.bannerUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.business, color: Colors.grey),
                                    )
                                  : const Icon(Icons.business, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FutureBuilder<Company>(
                                  future: ApiService().fetchCompanyDetails(job.companyId),
                                  builder: (context, snapshot) {
                                    String companyName = job.company;
                                    if (snapshot.hasData) {
                                      companyName = snapshot.data!.name;
                                    }
                                    return Text(
                                      companyName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        decoration: TextDecoration.none,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
