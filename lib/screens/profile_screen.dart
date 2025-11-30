import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.secondaryLight, AppTheme.secondaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Profile Picture
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primary,
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ahmet Yılmaz',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bilgisayar Mühendisliği',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const Text(
                    '3. Sınıf',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '2021123456',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildMenuItem(
              Icons.person_outline,
              'Kişisel Bilgiler',
              'İsim, e-posta ve telefon',
              context,
            ),
            _buildMenuItem(
              Icons.notifications_outlined,
              'Bildirim Ayarları',
              'Bildirim tercihlerini yönet',
              context,
            ),
            
            _buildMenuItem(
              Icons.security_outlined,
              'Gizlilik',
              'Gizlilik ve güvenlik ayarları',
              context,
            ),
            
            
            _buildMenuItem(
              Icons.help_outline,
              'Yardım ve Destek',
              'SSS ve iletişim',
              context,
            ),
            const SizedBox(height: 16),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final authService = AuthService();
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Çıkış Yap',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _SettingDetailPage(title: title),
            ),
          );
        },
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.secondaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    );
  }
}

// Ayarlar için detay sayfası
class _SettingDetailPage extends StatefulWidget {
  final String title;

  const _SettingDetailPage({required this.title});

  @override
  State<_SettingDetailPage> createState() => _SettingDetailPageState();
}

class _SettingDetailPageState extends State<_SettingDetailPage> {
  // Kişisel bilgiler form state (mock)
  final _formKey = GlobalKey<FormState>();
  String name = 'Ahmet Yılmaz';
  String email = 'ahmet.yilmaz@uni.edu.tr';
  String phone = '+90 555 123 45 67';
  String department = 'Bilgisayar Mühendisliği';
  String grade = '3. Sınıf';
  String studentId = '2021123456';

  // Gizlilik ayarları (mock)
  bool isProfilePublic = true;
  bool showEmail = false;
  bool showPhone = false;
  bool allowMessagesFromAll = true;

  // Bildirim ayarları (mock)
  bool notifPosts = true;
  bool notifMessages = true;
  bool notifAnnouncements = true;
  bool notifMarketplace = false;
  bool notifSound = true;


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
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(widget.title),
      ),
    );
  }

  Widget _buildBody(String title) {
    switch (title) {
      case 'Kişisel Bilgiler':
        return _buildPersonalInfoBody();
      case 'Bildirim Ayarları':
        return _buildNotificationBody();
      case 'Gizlilik':
        return _buildPrivacyBody();
      case 'Yardım ve Destek':
        return _buildHelpBody();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalInfoBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Genel Bilgiler'),
            _textField(label: 'Ad Soyad', initialValue: name, onSaved: (v) => name = v ?? name),
            _textField(label: 'E-posta', initialValue: email, keyboardType: TextInputType.emailAddress, onSaved: (v) => email = v ?? email),
            _textField(label: 'Telefon', initialValue: phone, keyboardType: TextInputType.phone, onSaved: (v) => phone = v ?? phone),
            const SizedBox(height: 8),
            _sectionTitle('Akademik Bilgiler'),
            _readonlyTile('Bölüm', department),
            _readonlyTile('Sınıf', grade),
            _readonlyTile('Öğrenci No', studentId),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  _formKey.currentState?.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bilgiler güncellendi (demo)')),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyBody() {
    return ListView(
      children: [
        _sectionTitle('Görünürlük'),
        _switchTile(
          title: 'Profil herkes tarafından görülebilir',
          value: isProfilePublic,
          onChanged: (v) => setState(() => isProfilePublic = v),
        ),
        _switchTile(
          title: 'E-posta adresini profilimde göster',
          value: showEmail,
          onChanged: (v) => setState(() => showEmail = v),
        ),
        _switchTile(
          title: 'Telefon numarasını profilimde göster',
          value: showPhone,
          onChanged: (v) => setState(() => showPhone = v),
        ),
        const SizedBox(height: 8),
        _sectionTitle('İletişim'),
        _switchTile(
          title: 'Herkes bana mesaj gönderebilsin',
          value: allowMessagesFromAll,
          onChanged: (v) => setState(() => allowMessagesFromAll = v),
        ),
        const SizedBox(height: 16),
        
      ],
    );
  }

  Widget _buildNotificationBody() {
    return ListView(
      children: [
        _sectionTitle('Bildirim Türleri'),
        _switchTile(
          title: 'Forum Gönderileri',
          subtitle: 'Yeni yanıtlar ve beğeniler',
          value: notifPosts,
          onChanged: (v) => setState(() => notifPosts = v),
        ),
        _switchTile(
          title: 'Mesajlar',
          subtitle: 'Yeni mesajlar',
          value: notifMessages,
          onChanged: (v) => setState(() => notifMessages = v),
        ),
        _switchTile(
          title: 'Duyurular',
          subtitle: 'Yeni duyuru ve etkinlikler',
          value: notifAnnouncements,
          onChanged: (v) => setState(() => notifAnnouncements = v),
        ),
        _switchTile(
          title: 'Alışveriş',
          subtitle: 'Yeni ürün ilanları',
          value: notifMarketplace,
          onChanged: (v) => setState(() => notifMarketplace = v),
        ),
        const SizedBox(height: 8),
        _sectionTitle('Ses ve Titreşim'),
        _switchTile(
          title: 'Bildirim Sesi',
          value: notifSound,
          onChanged: (v) => setState(() => notifSound = v),
        ),
      ],
    );
  }


  Widget _buildHelpBody() {
    return ListView(
      children: [
        _sectionTitle('Sıkça Sorulan Sorular'),
        _faq(
          'Forumda nasıl soru paylaşırım?',
          'Forum ekranında sağ alttaki + butonuna basarak yeni konu oluşturabilirsiniz.',
        ),
        _faq(
          'İlan nasıl verilir?',
          'Alışveriş sekmesinde sağ alttaki + butonuna basarak ürün ekleyebilirsiniz.',
        ),
        _faq(
          'Şifre mi unuttum, ne yapmalıyım?',
          'Profil > Kişisel Bilgiler sayfasından e-posta adresinizle şifre sıfırlama bağlantısı talep edebilirsiniz.',
        ),
        const SizedBox(height: 8),
        _sectionTitle('İletişim'),
        _contactTile(Icons.email_outlined, 'E-posta', 'destek@unihub.app'),
        _contactTile(Icons.telegram, 'Telegram', '@unihub_support'),
        _contactTile(Icons.language, 'Web', 'https://unihub.app/destek'),
      ],
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryDark,
          ),
        ),
      );

  Widget _textField({
    required String label,
    required String initialValue,
    TextInputType? keyboardType,
    required void Function(String?) onSaved,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide:
            BorderSide.none
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onSaved: onSaved,
      ),
    );
  }

  Widget _readonlyTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }

  Widget _switchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primary,
      ),
    );
  }

  Widget _faq(String q, String a) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline, color: AppTheme.primary),
        title: Text(q),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(a, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  Widget _contactTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }  
}



