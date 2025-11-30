import 'package:flutter/material.dart';
import '../models/job.dart';
import 'job_detail_screen.dart';

import '../models/company.dart';
import 'company_profile_screen.dart';
import 'jobs_screen.dart'; // To access getDemoCompanies
import '../services/api_service.dart';
import '../theme/app_theme.dart';


class JobCategoryScreen extends StatefulWidget {
  final String categoryTitle;
  final String categoryId; // 'Volunteering', 'Internship', 'Job'
  final List<Job> allJobs;

  const JobCategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryId,
    required this.allJobs,
  });

  @override
  State<JobCategoryScreen> createState() => _JobCategoryScreenState();
}

class _JobCategoryScreenState extends State<JobCategoryScreen> {
  late List<Job> _categoryJobs;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedTags = {};
  late List<String> _allTags;

  @override
  void initState() {
    super.initState();
    _categoryJobs = widget.allJobs.where((job) => job.category == widget.categoryId).toList();
    _allTags = _categoryJobs.expand((job) => job.tags).toSet().toList();
    // Also add job types as tags
    _allTags.addAll(_categoryJobs.map((job) => job.type).toSet());
    _allTags = _allTags.toSet().toList(); // Remove duplicates
  }

  List<Job> get _filteredJobs {
    return _categoryJobs.where((job) {
      final matchesSearch = _searchQuery.isEmpty ||
          job.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          job.company.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesTags = _selectedTags.isEmpty ||
          _selectedTags.every((tag) => job.tags.contains(tag) || job.type == tag);

      return matchesSearch && matchesTags;
    }).toList();
  }

  void _navigateToCompanyProfile(BuildContext context, String companyId) {
    final companies = JobsScreen.getDemoCompanies();
    final company = companies.firstWhere(
      (c) => c.id == companyId,
      orElse: () => Company(
        id: 'unknown',
        name: 'Unknown Company',
        description: '',
        employeeCount: '',
        location: '',
      ),
    );

    // Get all jobs for this company from the main list (widget.allJobs might be filtered by category, so we should check logic)
    // Actually, we want all jobs for this company across all categories? Or just this one?
    // Usually company profile shows all their jobs.
    // For now, let's filter from widget.allJobs (which is passed from JobsScreen and contains all jobs)
    // Wait, in JobsScreen we pass `_allJobs` which contains everything.
    final companyJobs = widget.allJobs.where((job) => job.companyId == companyId).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyProfileScreen(
          company: company,
          companyJobs: companyJobs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Ara...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _allTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.secondaryLight,
                          checkmarkColor: AppTheme.primaryDark,
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryDark : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? AppTheme.primary : Colors.grey[300]!,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredJobs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work_off_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'İlan bulunamadı',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = _filteredJobs[index];
                      return Hero(
                        tag: 'job_${job.id}',
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                          shadowColor: Colors.black.withValues(alpha: 0.1),
                          clipBehavior: Clip.antiAlias,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Banner Image
                                if (job.bannerUrl != null)
                                  SizedBox(
                                    height: 140,
                                    width: double.infinity,
                                    child: Image.network(
                                      job.bannerUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppTheme.secondaryLight,
                                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                        );
                                      },
                                    ),
                                  )
                                else
                                  Container(
                                    height: 100,
                                    width: double.infinity,
                                    color: AppTheme.secondaryLight,
                                    child: const Icon(Icons.business, size: 48, color: AppTheme.primary),
                                  ),

                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Logo and Company Name
                                      InkWell(
                                        onTap: () => _navigateToCompanyProfile(context, job.companyId),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.grey[200]!),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(alpha: 0.05),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(Icons.business, size: 20, color: AppTheme.primary),
                                            ),
                                            const SizedBox(width: 12),
                                            FutureBuilder<Company>(
                                              future: ApiService().fetchCompanyDetails(job.companyId),
                                              builder: (context, snapshot) {
                                                String companyName = job.company;
                                                if (snapshot.hasData) {
                                                  companyName = snapshot.data!.name;
                                                }
                                                return Text(
                                                  companyName,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Title
                                      Text(
                                        job.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          height: 1.2,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Tags
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          // Type Tag (e.g. Staj, Tam Zamanlı)
                                          _buildTag(job.type, isPrimary: true),
                                          // Other Tags from job.tags
                                          ...job.tags.map((tag) => _buildTag(tag)),
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
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary ? AppTheme.secondaryLight : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isPrimary ? AppTheme.primaryDark : Colors.grey[700],
        ),
      ),
    );
  }
}

