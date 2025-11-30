import 'package:flutter/material.dart';
import '../models/marketplace_item.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'messages_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  int _selectedIndex = 0;

  final List<String> _categories = ['Tümü', 'Kitap', 'Elektronik', 'Kıyafet', 'Diğer'];

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
          preferredSize: const Size.fromHeight(60),
          child: _buildCustomTabBar(),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _buildProductList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewMarketplaceItemScreen()),
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

  Widget _buildProductList() {
    final allItems = _getDemoItems();
    final category = _categories[_selectedIndex];
    final items = category == 'Tümü'
        ? allItems
        : allItems.where((item) => item.category == category).toList();

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Bu kategoride ürün bulunamadı',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80), // Bottom padding for FAB
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildProductCard(items[index]);
      },
    );
  }

  Widget _buildProductCard(MarketplaceItem item) {
    return Hero(
      tag: 'product_${item.id}',
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(item: item),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: item.imagePaths.isNotEmpty
                      ? (kIsWeb
                          ? Image.network(item.imagePaths.first, fit: BoxFit.cover)
                          : Image.file(File(item.imagePaths.first), fit: BoxFit.cover))
                      : Center(
                          child: Icon(
                            _getCategoryIcon(item.category),
                            size: 48,
                            color: Colors.grey[400],
                          ),
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
                            item.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${item.price} TL',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.primaryDark,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            item.condition,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.person_outline, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          item.seller,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            decoration: TextDecoration.none,
                          ),
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Elektronik':
        return Icons.laptop;
      case 'Kitap':
        return Icons.menu_book;
      case 'Kıyafet':
        return Icons.checkroom;
      case 'Diğer':
        return Icons.widgets;
      default:
        return Icons.category;
    }
  }

  List<MarketplaceItem> _getDemoItems() {
    return [
      MarketplaceItem(
        id: '1',
        title: 'Logitech Mouse',
        description: 'Az kullanılmış',
        price: 200,
        category: 'Elektronik',
        condition: 'Sıfır gibi',
        seller: 'Ayşe M.',
        imagePaths: ['https://loremflickr.com/400/400/computer,mouse'],
      ),
      MarketplaceItem(
        id: '2',
        title: 'Lineer Cebir Ders Kitabı',
        description: 'Altı çizili, notlu',
        price: 150,
        category: 'Kitap',
        condition: 'İyi durumda',
        seller: 'Ali D.',
        imagePaths: ['https://loremflickr.com/400/400/textbook', 'https://loremflickr.com/400/400/book'],
      ),
      MarketplaceItem(
        id: '3',
        title: 'Fizik Ders Kitabı',
        description: 'Temiz, notları var',
        price: 120,
        category: 'Kitap',
        condition: 'İyi durumda',
        seller: 'Mehmet K.',
        imagePaths: ['https://loremflickr.com/400/400/physics,book'],
      ),
      MarketplaceItem(
        id: '4',
        title: 'Laptop Çantası',
        description: '15 inç uyumlu, su geçirmez',
        price: 180,
        category: 'Elektronik',
        condition: 'Sıfır gibi',
        seller: 'Zeynep A.',
        imagePaths: ['https://loremflickr.com/400/400/laptop,bag'],
      ),
      MarketplaceItem(
        id: '5',
        title: 'Spor Ayakkabı',
        description: '42 numara, Nike',
        price: 350,
        category: 'Kıyafet',
        condition: 'Az kullanılmış',
        seller: 'Can Ö.',
        imagePaths: ['https://loremflickr.com/400/400/sneakers', 'https://loremflickr.com/400/400/shoes'],
      ),
      MarketplaceItem(
        id: '6',
        title: 'Kol Saati',
        description: 'Casio, su geçirmez',
        price: 250,
        category: 'Diğer',
        condition: 'İyi durumda',
        seller: 'Selin Y.',
        imagePaths: ['https://loremflickr.com/400/400/wristwatch'],
      ),
      MarketplaceItem(
        id: '7',
        title: 'Mont',
        description: 'M beden, kışlık',
        price: 400,
        category: 'Kıyafet',
        condition: 'Sıfır gibi',
        seller: 'Berk T.',
        imagePaths: ['https://loremflickr.com/400/400/winter,jacket'],
      ),
      MarketplaceItem(
        id: '8',
        title: 'Kablosuz Kulaklık',
        description: 'JBL, kutulu',
        price: 300,
        category: 'Elektronik',
        condition: 'Sıfır gibi',
        seller: 'Deniz S.',
        imagePaths: ['https://loremflickr.com/400/400/headphones'],
      ),
    ];
  }

  void _showFilterDialog() {
    // Deprecated, kept just in case or removed if unused.
    // Logic moved to tabs.
  }
}

// Ürün detay ekranı
class ProductDetailScreen extends StatelessWidget {
  final MarketplaceItem item;

  const ProductDetailScreen({super.key, required this.item});

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
          'İlan Detayı',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fotoğraf galerisi
                  if (item.imagePaths.isNotEmpty)
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        itemCount: item.imagePaths.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              image: DecorationImage(
                                image: item.imagePaths[index].startsWith('http')
                                    ? NetworkImage(item.imagePaths[index])
                                    : (kIsWeb
                                        ? NetworkImage(item.imagePaths[index]) // Fallback for web if not http (unlikely for local)
                                        : FileImage(File(item.imagePaths[index])) as ImageProvider),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          _getCategoryIcon(item.category),
                          size: 80,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  // Foto sayısı göstergesi
                  if (item.imagePaths.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          item.imagePaths.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Ürün bilgileri
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fiyat ve durum
                        Row(
                          children: [
                            Text(
                              '${item.price} TL',
                              style: const TextStyle(
                                color: AppTheme.primaryLight,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.condition,
                                style: const TextStyle(
                                  color: AppTheme.primaryDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Başlık
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Kategori
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        // Açıklama
                        const Text(
                          'Açıklama',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        // Satıcı bilgisi
                        const Text(
                          'Satıcı',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.primary,
                              child: Text(
                                item.seller[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.seller,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Satıcı',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Mesajlaş butonu
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductChatScreen(
                          productTitle: item.title,
                          productPrice: item.price,
                          productCondition: item.condition,
                          sellerName: item.seller,
                          category: item.category,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.message, color: Colors.white),
                  label: const Text(
                    'Mesajlaş',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Elektronik':
        return Icons.laptop;
      case 'Kitap':
        return Icons.menu_book;
      case 'Kıyafet':
        return Icons.checkroom;
      default:
        return Icons.category;
    }
  }
}

// Ürün sohbet ekranı
class ProductChatScreen extends StatefulWidget {
  final String productTitle;
  final int productPrice;
  final String productCondition;
  final String sellerName;
  final String category;

  const ProductChatScreen({
    super.key,
    required this.productTitle,
    required this.productPrice,
    required this.productCondition,
    required this.sellerName,
    required this.category,
  });

  @override
  State<ProductChatScreen> createState() => _ProductChatScreenState();
}

class _ProductChatScreenState extends State<ProductChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ProductMessage> _messages = [
    _ProductMessage(text: 'Merhaba, ürünle ilgileniyorum.', isMe: true, time: '15:20'),
    _ProductMessage(text: 'Merhaba! Elbette, sorularınızı alabilir miyim?', isMe: false, time: '15:21'),
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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: Text(
                widget.sellerName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sellerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Satıcı',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Ürün bilgi bannerı
          _buildProductBanner(),
          // Mesajlar
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return Align(
                  alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
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
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                        ],
                        border: m.isMe ? null : Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.text,
                            style: TextStyle(
                              color: m.isMe ? Colors.white : Colors.black87,
                            ),
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

  Widget _buildProductBanner() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.secondaryLight, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(widget.category),
              size: 32,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.productPrice} TL',
                  style: const TextStyle(
                    color: AppTheme.primaryLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.productCondition,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.secondaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.category,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            )
          ],
        ),
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
              icon: const Icon(Icons.send_rounded, color: AppTheme.primary),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiPicker() {
    const emojis = ['😀', '😁', '😂', '🤣', '😊', '😍', '👍', '👏', '🎉', '❤️', '🙏', '🔥'];
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
      _messages.add(_ProductMessage(text: text, isMe: true, time: _nowTime()));
      _controller.clear();
    });
  }

  String _nowTime() {
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Elektronik':
        return Icons.laptop;
      case 'Kitap':
        return Icons.menu_book;
      case 'Kıyafet':
        return Icons.checkroom;
      default:
        return Icons.category;
    }
  }
}

class _ProductMessage {
  final String text;
  final bool isMe;
  final String time;
  _ProductMessage({required this.text, required this.isMe, required this.time});
}

// Yeni ürün ilanı
class NewMarketplaceItemScreen extends StatefulWidget {
  const NewMarketplaceItemScreen({super.key});

  @override
  State<NewMarketplaceItemScreen> createState() => _NewMarketplaceItemScreenState();
}

class _NewMarketplaceItemScreenState extends State<NewMarketplaceItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'Kitap';
  String _selectedCondition = 'İyi durumda';
  final List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
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
          'Yeni İlan',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _submitItem,
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
            // Fotoğraf ekleme
            Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imagePaths.length + 1,
                itemBuilder: (context, index) {
                  if (index == _imagePaths.length) {
                    // Add photo button
                    return InkWell(
                      onTap: _imagePaths.length < 5 ? _pickImage : null,
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _imagePaths.length < 5 ? Colors.white : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _imagePaths.length < 5 ? AppTheme.primary : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 40,
                              color: _imagePaths.length < 5 ? AppTheme.primary : Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _imagePaths.length < 5 ? 'Fotoğraf Ekle' : 'Max 5 foto',
                              style: TextStyle(
                                color: _imagePaths.length < 5 ? AppTheme.primary : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  // Image preview
                  return Stack(
                    children: [
                      Container(
                        width: 120,
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
                            ? const Center(
                                child: Icon(Icons.image, size: 40),
                              )
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
            // Başlık
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Ürün Adı',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Ürün adı girin' : null,
              ),
            ),
            const SizedBox(height: 12),
            // Kategori
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: InputBorder.none,
                ),
                items: ['Kitap', 'Elektronik', 'Kıyafet', 'Diğer']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
            ),
            const SizedBox(height: 12),
            // Fiyat
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fiyat (TL)',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Fiyat girin' : null,
              ),
            ),
            const SizedBox(height: 12),
            // Durum
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  labelText: 'Durum',
                  border: InputBorder.none,
                ),
                items: ['İyi durumda', 'Sıfır gibi', 'Az kullanılmış', 'Eski']
                    .map((cond) => DropdownMenuItem(value: cond, child: Text(cond)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCondition = v!),
              ),
            ),
            const SizedBox(height: 12),
            // Açıklama
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _descController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Açıklama girin' : null,
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

  void _submitItem() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İlan paylaşıldı!')),
      );
      Navigator.pop(context);
    }
  }
}



