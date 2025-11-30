import 'package:flutter/material.dart';
import '../models/forum_post.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

// Yeni forum gönderisi oluşturma
class NewForumPostScreen extends StatefulWidget {
  const NewForumPostScreen({super.key});

  @override
  State<NewForumPostScreen> createState() => _NewForumPostScreenState();
}

class _NewForumPostScreenState extends State<NewForumPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Akademik';
  final List<String> _categories = ['Akademik', 'Sosyal', 'Teknik', 'Genel'];
  bool _isCustomCategory = false;
  final _customCategoryController = TextEditingController();
  final List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Yeni Gönderi',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.image, color: AppTheme.primary),
            onPressed: _pickImage,
          ),
          TextButton(
            onPressed: _submitPost,
            child: const Text(
              'Paylaş',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Görsel ekleme
            if (_imagePaths.isNotEmpty)
              Container(
                height: 100,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagePaths.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: kIsWeb
                                ? null
                                : DecorationImage(
                                    image: FileImage(File(_imagePaths[index])),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          child: kIsWeb
                              ? const Center(child: Icon(Icons.image, size: 40))
                              : null,
                        ),
                        Positioned(
                          top: 4,
                          right: 12,
                          child: InkWell(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            // Kategori seçimi
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                value: _isCustomCategory ? null : _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: InputBorder.none,
                ),
                items: [
                  ..._categories.map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      )),
                  const DropdownMenuItem(
                    value: '__custom__',
                    child: Text('+ Özel Kategori Ekle'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value == '__custom__') {
                      _isCustomCategory = true;
                    } else {
                      _isCustomCategory = false;
                      _selectedCategory = value!;
                    }
                  });
                },
              ),
            ),
            if (_isCustomCategory) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _customCategoryController,
                  decoration: const InputDecoration(
                    labelText: 'Kategori Adı',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  validator: (v) => v?.isEmpty ?? true ? 'Kategori adı girin' : null,
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Başlık
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Başlık girin' : null,
              ),
            ),
            const SizedBox(height: 12),
            // İçerik
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _contentController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'İçerik',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'İçerik girin' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePaths.add(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resim seçilirken hata oluştu: $e')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      final category = _isCustomCategory ? _customCategoryController.text : _selectedCategory;
      // Demo: Gönderiyi kaydet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gönderi "$category" kategorisinde paylaşıldı!')),
      );
      Navigator.pop(context);
    }
  }
}

// Forum post detay ve cevaplar
class ForumPostDetailScreen extends StatefulWidget {
  final ForumPost post;
  const ForumPostDetailScreen({super.key, required this.post});

  @override
  State<ForumPostDetailScreen> createState() => _ForumPostDetailScreenState();
}

class _ForumPostDetailScreenState extends State<ForumPostDetailScreen> {
  final _replyController = TextEditingController();
  final List<_Reply> _replies = [
    _Reply('Mehmet K.', 'Benimki de aynı sorun var, çözümü buldum mu?', '2 saat önce'),
    _Reply('Ayşe S.', 'Ders notlarına bakabilirsin, orada açıklanmış.', '1 saat önce'),
  ];

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

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
          'Gönderi Detayı',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Orijinal gönderi
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.primary,
                            child: Text(
                              widget.post.username[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.username,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${widget.post.category} • ${widget.post.date}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.post.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.post.content,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.post.replies} cevap',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Cevaplar başlığı
                Text(
                  'Cevaplar (${_replies.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 12),
                // Cevaplar
                ..._replies.map((reply) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppTheme.secondaryLight,
                                child: Text(
                                  reply.username[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                reply.username,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                reply.time,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(reply.message),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          // Cevap yazma alanı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: 'Cevap yaz...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppTheme.primary),
                    onPressed: () {
                      if (_replyController.text.isNotEmpty) {
                        setState(() {
                          _replies.add(_Reply(
                            'Sen',
                            _replyController.text,
                            'Şimdi',
                          ));
                          _replyController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Reply {
  final String username;
  final String message;
  final String time;
  _Reply(this.username, this.message, this.time);
}



