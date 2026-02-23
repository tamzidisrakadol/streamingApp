import 'package:flutter/material.dart';

/// Represents a streaming content item with metadata
class StreamItem {
  final String name;
  final String imageAsset; // logo.png or glogo.png
  final int views;
  final bool isPrivate;
  final String country;
  final String countryCode;
  final String category;

  StreamItem({
    required this.name,
    required this.imageAsset,
    required this.views,
    required this.isPrivate,
    required this.country,
    required this.countryCode,
    required this.category,
  });
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  late AnimationController _itemAnimationController;
  late List<AnimationController> _staggeredControllers;

  // Category list
  static const List<String> categories = ['Home', 'Audio', 'Games'];
  String selectedCategory = 'Home';

  // Sample stream items data
  late final Map<String, List<StreamItem>> streamItems;

  @override
  void initState() {
    super.initState();

    // Initialize stream data
    streamItems = {
      'Home': [
        StreamItem(
          name: 'Morning Live Talk',
          imageAsset: 'assets/image/logo.png',
          views: 1250,
          isPrivate: false,
          country: 'USA',
          countryCode: 'US',
          category: 'Home',
        ),
        StreamItem(
          name: 'Cooking Show',
          imageAsset: 'assets/image/glogo.png',
          views: 3420,
          isPrivate: false,
          country: 'UK',
          countryCode: 'GB',
          category: 'Home',
        ),
        StreamItem(
          name: 'Private Session',
          imageAsset: 'assets/image/logo.png',
          views: 542,
          isPrivate: true,
          country: 'Canada',
          countryCode: 'CA',
          category: 'Home',
        ),
        StreamItem(
          name: 'Fitness Journey',
          imageAsset: 'assets/image/glogo.png',
          views: 5890,
          isPrivate: false,
          country: 'Australia',
          countryCode: 'AU',
          category: 'Home',
        ),
        StreamItem(
          name: 'Tech Deep Dive',
          imageAsset: 'assets/image/logo.png',
          views: 2145,
          isPrivate: false,
          country: 'Germany',
          countryCode: 'DE',
          category: 'Home',
        ),
      ],
      'Audio': [
        StreamItem(
          name: 'Music Session',
          imageAsset: 'assets/image/glogo.png',
          views: 4200,
          isPrivate: false,
          country: 'Japan',
          countryCode: 'JP',
          category: 'Audio',
        ),
        StreamItem(
          name: 'Podcast Discussion',
          imageAsset: 'assets/image/logo.png',
          views: 2100,
          isPrivate: false,
          country: 'India',
          countryCode: 'IN',
          category: 'Audio',
        ),
        StreamItem(
          name: 'Private Audio',
          imageAsset: 'assets/image/glogo.png',
          views: 380,
          isPrivate: true,
          country: 'France',
          countryCode: 'FR',
          category: 'Audio',
        ),
        StreamItem(
          name: 'DJ Set Live',
          imageAsset: 'assets/image/logo.png',
          views: 6700,
          isPrivate: false,
          country: 'Brazil',
          countryCode: 'BR',
          category: 'Audio',
        ),
        StreamItem(
          name: 'Audio Workshop',
          imageAsset: 'assets/image/glogo.png',
          views: 1850,
          isPrivate: false,
          country: 'Spain',
          countryCode: 'ES',
          category: 'Audio',
        ),
      ],
      'Games': [
        StreamItem(
          name: 'Gaming Tournament',
          imageAsset: 'assets/image/logo.png',
          views: 8920,
          isPrivate: false,
          country: 'South Korea',
          countryCode: 'KR',
          category: 'Games',
        ),
        StreamItem(
          name: 'Casual Play',
          imageAsset: 'assets/image/glogo.png',
          views: 3500,
          isPrivate: false,
          country: 'Mexico',
          countryCode: 'MX',
          category: 'Games',
        ),
        StreamItem(
          name: 'Private Gaming',
          imageAsset: 'assets/image/logo.png',
          views: 640,
          isPrivate: true,
          country: 'Italy',
          countryCode: 'IT',
          category: 'Games',
        ),
        StreamItem(
          name: 'Speedrun Challenge',
          imageAsset: 'assets/image/glogo.png',
          views: 5400,
          isPrivate: false,
          country: 'Netherlands',
          countryCode: 'NL',
          category: 'Games',
        ),
        StreamItem(
          name: 'Co-op Adventure',
          imageAsset: 'assets/image/logo.png',
          views: 2780,
          isPrivate: false,
          country: 'Poland',
          countryCode: 'PL',
          category: 'Games',
        ),
      ],
    };

    // Initialize staggered animation controllers for list items
    _staggeredControllers = List.generate(5, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    // Start animations with stagger effect
    _animateItems();
  }

  void _animateItems() {
    for (int i = 0; i < _staggeredControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _staggeredControllers[i].forward();
        }
      });
    }
  }

  void _changeCategory(String newCategory) {
    setState(() {
      selectedCategory = newCategory;
    });
    // Reset and restart animations
    for (var controller in _staggeredControllers) {
      controller.reset();
    }
    _animateItems();
  }

  @override
  void dispose() {
    for (var controller in _staggeredControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161622),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with avatar and action buttons
            SliverAppBar(
              backgroundColor: const Color(0xFF161622),
              elevation: 0,
              floating: true,
              pinned: true,
              centerTitle: false,
              title: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF6B35),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade700,
                  backgroundImage: const AssetImage('assets/image/boy.png'),
                ),
              ),
              actions: [
                // Search button
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/image/search.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                // Notification button
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(
                          'assets/image/bell.png',
                          width: 24,
                          height: 24,
                        ),
                        // Notification badge
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF4D4D),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Space between AppBar and categories
            SliverPadding(
              padding: const EdgeInsets.only(top: 20),
              sliver: SliverToBoxAdapter(
                child: Container(),
              ),
            ),

            //Category chips
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories.map((category) {
                      final isSelected = category == selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => _changeCategory(category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFF6B35)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFF6B35)
                                    : Colors.grey.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade400,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Stream items grid with staggered animation (2 columns)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final items = streamItems[selectedCategory]!;
                    final item = items[index];

                    // Calculate stagger index for animation (cycle through controllers)
                    final staggerIndex = index % _staggeredControllers.length;

                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _staggeredControllers[staggerIndex],
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: FadeTransition(
                        opacity: _staggeredControllers[staggerIndex],
                        child: _buildStreamCard(item),
                      ),
                    );
                  },
                  childCount: streamItems[selectedCategory]!.length,
                ),
              ),
            ),

            // Bottom padding
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamCard(StreamItem item) {
    return GestureDetector(
      onTap: () {
        // Handle card tap - navigate to stream details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening: ${item.name}'),
            duration: const Duration(milliseconds: 800),
            backgroundColor: const Color(0xFFFF6B35),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Card background with gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.withValues(alpha: 0.1),
                    Colors.grey.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stream preview with image and metadata overlay
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                    child: Stack(
                      children: [
                        // Background image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.imageAsset,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),

                        // Overlay with gradient
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),

                        // Views count (bottom left)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatViews(item.views),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Private lock icon (top right)
                        if (item.isPrivate)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B35),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.asset(
                                'assets/image/padlock.png',
                                width: 14,
                                height: 14,
                              ),
                            ),
                          ),

                        // Live indicator (top left)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4D4D),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Stream title
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Stream metadata (country)
                  Text(
                    item.country,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Status row (live viewers and accessibility)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF4D4D),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Streaming now',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
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
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }
}
