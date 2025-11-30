class Job {
  final String id;
  final String title;
  final String company;
  final String description;
  final String type;
  final String location;
  final String postedDate;

  final String category; // 'Volunteering', 'Internship', 'Job'
  final List<String> requirements;
  final String? contactEmail;
  final String? bannerUrl;
  final List<String> tags;
  final String companyId;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.type,
    required this.location,
    required this.postedDate,
    required this.category,
    required this.companyId,
    this.requirements = const [],
    this.contactEmail,
    this.bannerUrl,
    this.tags = const [],
  });
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'].toString(),
      title: json['intern_title'] ?? '',
      company: 'Company #${json['intern_place']}', // Placeholder as company name is not in response
      description: json['intern_text'] ?? '',
      type: json['intern_time'] ?? 'Full-Time',
      location: (json['intern_remote'] == true) ? 'Uzaktan' : 'İş Yerinde',
      postedDate: json['intern_date'] ?? '',
      category: 'Internship',
      companyId: json['intern_place']?.toString() ?? '1',
      bannerUrl: _resolveImageUrl(json['intern_image'] ?? json['image']),
      contactEmail: json['intern_contact'],
      requirements: [],
      tags: [],
    );
  }

  static String? _resolveImageUrl(String? url) {
    if (url == null) return null;
    if (url.startsWith('http')) return url;
    if (url.startsWith('/')) return 'https://muratyl2k4.pythonanywhere.com$url';
    return 'https://muratyl2k4.pythonanywhere.com/$url';
  }
}

