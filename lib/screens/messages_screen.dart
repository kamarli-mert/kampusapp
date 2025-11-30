import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../theme/app_theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = _getDemoChats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesajlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primary,
                  child: Text(
                    chat.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (chat.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              chat.name,
              style: TextStyle(
                fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (chat.unreadCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    name: chat.name,
                    isOnline: chat.isOnline,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Chat> _getDemoChats() {
    return [
      Chat(
        id: '1',
        name: 'Ali Yılmaz',
        lastMessage: 'Yarın sınav var mı?',
        time: '14:30',
        unreadCount: 2,
        isOnline: true,
      ),
      Chat(
        id: '2',
        name: 'Zeynep Kaya',
        lastMessage: 'Teşekkürler!',
        time: 'Dün',
        unreadCount: 0,
        isOnline: false,
      ),
      Chat(
        id: '3',
        name: 'Mehmet Demir',
        lastMessage: 'Proje dosyasını gönderdim',
        time: '2 gün önce',
        unreadCount: 1,
        isOnline: true,
      ),
    ];
  }

  void _showSearchDialog(BuildContext context) {
    final demoUsers = [
      {'name': 'Ayşe Saraç', 'department': 'Bilgisayar Mühendisliği', 'year': '2. Sınıf'},
      {'name': 'Can Öztürk', 'department': 'Elektrik Mühendisliği', 'year': '3. Sınıf'},
      {'name': 'Deniz Yıldız', 'department': 'Endüstri Mühendisliği', 'year': '4. Sınıf'},
      {'name': 'Elif Koç', 'department': 'Bilgisayar Mühendisliği', 'year': '1. Sınıf'},
      {'name': 'Furkan Aslan', 'department': 'Makine Mühendisliği', 'year': '3. Sınıf'},
      {'name': 'Gülcan Aydın', 'department': 'Bilgisayar Mühendisliği', 'year': '2. Sınıf'},
      {'name': 'Hakan Polat', 'department': 'İnşaat Mühendisliği', 'year': '4. Sınıf'},
      {'name': 'İrem Kara', 'department': 'Elektrik Mühendisliği', 'year': '2. Sınıf'},
      {'name': 'Ali Yılmaz', 'department': 'Makine Mühendisliği', 'year': '2. Sınıf'},
      {'name': 'Zeynep Kaya', 'department': 'Endüstri Mühendisliği', 'year': '3. Sınıf'},
      {'name': 'Mehmet Demir', 'department': 'Bilgisayar Mühendisliği', 'year': '4. Sınıf'},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return _SearchUsersDialog(users: demoUsers);
      },
    );
  }

}

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final bool isOnline;
  const ChatDetailScreen({super.key, required this.name, required this.isOnline});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_Message> _messages = [
    _Message(text: 'Merhaba!', isMe: false, time: '14:20'),
    _Message(text: 'Selam! Nasılsın?', isMe: true, time: '14:21'),
    _Message(text: 'İyiyim, proje nasıl gidiyor?', isMe: false, time: '14:22'),
  ];
  bool _showEmoji = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: Text(widget.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                ),
                Text(
                  widget.isOnline ? 'Çevrimiçi' : 'Çevrimiş',
                  style: TextStyle(fontSize: 12, color: widget.isOnline ? AppTheme.primary : Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return Align(
                  alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: m.isMe ? AppTheme.primary : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(m.isMe ? 12 : 0),
                          bottomRight: Radius.circular(m.isMe ? 0 : 12),
                        ),
                        boxShadow: [
                          if (!m.isMe)
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                        border: m.isMe ? null : Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.text,
                            style: TextStyle(color: m.isMe ? Colors.white : Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              m.time,
                              style: TextStyle(
                                fontSize: 10,
                                color: m.isMe ? Colors.white70 : Colors.grey[600],
                              ),
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
          if (_showEmoji) _buildEmojiPicker(),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))
        ]),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined, color: AppTheme.primary),
              onPressed: () => setState(() => _showEmoji = !_showEmoji),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Mesaj yaz...',
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 4,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.attach_file, color: AppTheme.primary),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: AppTheme.primary),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiPicker() {
    const emojis = ['😀','😁','😂','🤣','😊','😍','😘','😎','🤔','👍','🙏','🎉'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: AppTheme.secondaryLight,
      child: Wrap(
        spacing: 8,
        children: [
          for (final e in emojis)
            GestureDetector(
              onTap: () {
                _controller.text += e;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );
              },
              child: Text(e, style: const TextStyle(fontSize: 24)),
            ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text: text, isMe: true, time: _nowTime()));
      _controller.clear();
    });
  }

  String _nowTime() {
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _Message {
  final String text;
  final bool isMe;
  final String time;
  _Message({required this.text, required this.isMe, required this.time});
}

// Kullanıcı arama dialogu
class _SearchUsersDialog extends StatefulWidget {
  final List<Map<String, String>> users;

  const _SearchUsersDialog({required this.users});

  @override
  State<_SearchUsersDialog> createState() => _SearchUsersDialogState();
}

class _SearchUsersDialogState extends State<_SearchUsersDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.users;
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = widget.users;
      } else {
        _filteredUsers = widget.users.where((user) {
          final name = user['name']!.toLowerCase();
          final department = user['department']!.toLowerCase();
          return name.contains(query) || department.contains(query);
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
                      'Kullanıcı Ara',
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
                  hintText: 'İsim veya bölüm ara...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
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
              child: _filteredUsers.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_search, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'Kullanıcı bulunamadı',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primary,
                            child: Text(
                              user['name']![0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            user['name']!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "${user['department']} • ${user['year']}",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailScreen(
                                  name: user['name']!,
                                  isOnline: index % 2 == 0,
                                ),
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



