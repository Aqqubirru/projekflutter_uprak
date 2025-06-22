import 'package:flutter/material.dart';
import 'models/product.dart';
import 'widgets/product_card.dart';
import 'widgets/banner_carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const ECommerceHomePage(),
    );
  }
}

class ECommerceHomePage extends StatefulWidget {
  const ECommerceHomePage({super.key});

  @override
  State<ECommerceHomePage> createState() => _ECommerceHomePageState();
}

class _ECommerceHomePageState extends State<ECommerceHomePage> {
  final List<String> categories = [
    'All',
    'Electronics',
    'Clothing',
    'Home',
    'Beauty',
    'Sports',
  ];

  final List<String> filters = [
    'Price: Low to High',
    'Price: High to Low',
    'Newest',
    'Popular',
  ];

  final List<Product> allProducts = [
    Product('Smartphone', 'Electronics', 699, 'lib/images/handphone.jpg', 'Smartphone dengan fitur terbaru dan kamera berkualitas tinggi.'),
    Product('T-Shirt', 'Clothing', 29, 'lib/images/tshirt.jpg', 'T-shirt yang nyaman untuk dipakai bermain.'),
    Product('Sofa', 'Home', 499, 'lib/images/sofa.jpg', 'Sofa empuk dan stylish untuk ruang tamu Anda.'),
    Product('Lipstick', 'Beauty', 19, 'lib/images/lipstick.jpg', 'Lipstick tahan lama dengan warna yang cerah.'),
    Product('Basketball', 'Sports', 39, 'lib/images/basketball.jpg', 'Bola basket berkualitas untuk latihan dan pertandingan.'),
    Product('Laptop', 'Electronics', 999, 'lib/images/laptop.jpg', 'Laptop ringan dengan performa tinggi untuk pekerjaan dan hiburan.'),
    Product('Jeans', 'Clothing', 59, 'lib/images/jeans.jpg', 'Jeans denim klasik yang cocok untuk berbagai kesempatan.'),
    Product('Coffee Maker', 'Home', 89, 'lib/images/coffeemaker.jpg', 'Mesin kopi otomatis dengan desain modern dan mudah digunakan.'),
  ];

  String selectedCategory = 'All';
  String selectedFilter = 'Price: Low to High';
  String searchQuery = '';
  bool showSearchField = false;
  int cartItemCount = 0;
  final List<Product> cartItems = [];

  List<Product> get filteredProducts {
    List<Product> filtered = allProducts.where((product) {
      final matchesCategory = selectedCategory == 'All' || product.category == selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    switch (selectedFilter) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Newest':
        // For demo, no date, so keep as is
        break;
      case 'Popular':
        // For demo, no popularity, so keep as is
        break;
    }
    return filtered;
  }

  void _addToCart(Product product) {
    setState(() {
      cartItems.add(product);
      cartItemCount = cartItems.length;
    });
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return Align(
          alignment: const Alignment(0, -0.7),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                '${product.name} berhasil ditambahkan ke cart',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shopping Cart'),
        content: SizedBox(
          width: double.maxFinite,
          child: cartItems.isEmpty
              ? const Text('Your cart is empty.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems[index];
                    return ListTile(
                      leading: Image.asset(product.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            cartItems.removeAt(index);
                            cartItemCount = cartItems.length;
                          });
                          Navigator.pop(context);
                          _showCartDialog();
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('uprak web'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: _showCartDialog,
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showSearchField
                  ? SizedBox(
                      key: const ValueKey('searchField'),
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search products',
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                setState(() {
                                  showSearchField = false;
                                  searchQuery = '';
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                    )
                  : IconButton(
                      key: const ValueKey('searchIcon'),
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          showSearchField = true;
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('Clear Filters', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.clear),
                onTap: () {
                  setState(() {
                    selectedCategory = 'All';
                    selectedFilter = 'Price: Low to High';
                    searchQuery = '';
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected = category == selectedCategory;
                    return ListTile(
                      title: Text(category),
                      selected: selected,
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final selected = filter == selectedFilter;
                    return ListTile(
                      title: Text(filter),
                      selected: selected,
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: false,
            floating: false,
            delegate: _BannerHeaderDelegate(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: SizedBox(
                  height: 280,
                  child: BannerCarousel(),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Products',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(product.name),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(product.imageUrl, fit: BoxFit.cover),
                                const SizedBox(height: 8),
                                Text('Category: ${product.category}'),
                                Text('Price: \$${product.price}'),
                                const SizedBox(height: 8),
                                const Text('This is a detailed description of the product.'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: ProductCard(
                      product: product,
                      onAddToCart: () => _addToCart(product),
                    ),
                  );
                },
                childCount: filteredProducts.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5 / 3.5,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.blueGrey.shade800,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              margin: const EdgeInsets.only(top: 24, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer Service', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Email: ronaldo@customerservice.com', style: TextStyle(color: Colors.white70)),
                  const Text('Phone: +62 123 4567 890', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  Text('Contact Us', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Address: Jl riung bandung the best', style: TextStyle(color: Colors.white70)),
                  const Text('Working Hours: Senin-Jumat 07:00 till 22:00', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.blueGrey.shade900,
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Center(
                child: Text(
                  '© 2024 E-Commerce Aqbil. All rights reserved.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _BannerHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 288; // 240 height + 24 vertical padding top + 24 bottom

  @override
  double get minExtent => 288;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
