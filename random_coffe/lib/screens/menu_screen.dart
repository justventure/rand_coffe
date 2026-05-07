import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_provider.dart';
import '../models/menu_provider.dart';
import '../models/product.dart';
import '../models/theme_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_sheet.dart';
import 'product_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? _selectedCategory;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};

  static const Color primaryButtonColor = Color(0xFF5CBCE5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().load();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initKeys(List<String> categories) {
    for (final cat in categories) {
      _categoryKeys.putIfAbsent(cat, () => GlobalKey());
    }
  }

  void _scrollToCategory(String category) {
    setState(() => _selectedCategory = category);
    final key = _categoryKeys[category];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _openCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const CartSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MenuProvider>(
          builder: (context, menu, _) {
            if (menu.status == MenuStatus.loading ||
                menu.status == MenuStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (menu.status == MenuStatus.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(menu.error ?? 'Ошибка загрузки'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: menu.load,
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            final categories = menu.categories;
            _initKeys(categories);
            _selectedCategory ??=
            categories.isNotEmpty ? categories.first : null;

            return Stack(
              children: [
                Column(
                  children: [
                    _CategoryBar(
                      categories: categories,
                      selected: _selectedCategory ?? '',
                      onSelect: _scrollToCategory,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...categories.map((cat) {
                              final catProducts = menu.productsByCategory(cat);
                              if (catProducts.isEmpty)
                                return const SizedBox.shrink();
                              return _CategorySection(
                                key: _categoryKeys[cat],
                                category: cat,
                                products: catProducts,
                                onProductTap: (product) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailScreen(product: product),
                                    ),
                                  );
                                },
                              );
                            }),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Positioned(
                  bottom: 16,
                  left: 32,
                  child: _ThemeToggleButton(),
                ),
                Positioned(
                  bottom: 16,
                  right: 32,
                  child: _CartButton(onTap: _openCart),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  const _CategoryBar({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  static const Color primaryButtonColor = Color(0xFF5CBCE5);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = cat == selected;
            return GestureDetector(
              onTap: () => onSelect(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color:
                  isSelected ? primaryButtonColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(
                    color:
                    Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  const _CategorySection({
    super.key,
    required this.category,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: products
                    .map(
                      (product) => SizedBox(
                    width: cardWidth,
                    child: ProductCard(
                      product: product,
                      onTap: () => onProductTap(product),
                    ),
                  ),
                )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CartButton({required this.onTap});

  static const Color primaryButtonColor = Color(0xFF5CBCE5);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        if (cart.totalCount == 0) return const SizedBox.shrink();
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: primaryButtonColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_bag_outlined,
                    color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${cart.total.toInt()} ₽',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) => GestureDetector(
        onTap: theme.toggle,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            theme.isDark
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            size: 22,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
