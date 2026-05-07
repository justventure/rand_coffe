import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  static const Color primaryButtonColor = Color(0xFF5CBCE5);

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final inCart = cart.inCart(product.id);
        final quantity = cart.getQuantity(product.id);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: product.imageUrl != null
                        ? _ImageWithTimeout(imageUrl: product.imageUrl!)
                        : const _Placeholder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      inCart
                          ? _QuantityPanel(
                        product: product,
                        quantity: quantity,
                        cart: cart,
                      )
                          : _BuyButton(product: product, cart: cart),
                    ],
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

class _ImageWithTimeout extends StatefulWidget {
  final String imageUrl;

  const _ImageWithTimeout({required this.imageUrl});

  @override
  State<_ImageWithTimeout> createState() => _ImageWithTimeoutState();
}

class _ImageWithTimeoutState extends State<_ImageWithTimeout> {
  bool _timedOut = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    debugPrint('IMAGE LOAD START: ${widget.imageUrl}');
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && !_loaded) {
        debugPrint('IMAGE TIMEOUT: ${widget.imageUrl}');
        setState(() => _timedOut = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_timedOut) {
      debugPrint('IMAGE SHOWING PLACEHOLDER (timeout): ${widget.imageUrl}');
      return const _Placeholder();
    }

    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        debugPrint('IMAGE LOADING (placeholder shown): $url');
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      },
      imageBuilder: (context, imageProvider) {
        debugPrint('IMAGE LOADED OK: ${widget.imageUrl}');
        _loaded = true;
        return Image(image: imageProvider, fit: BoxFit.cover);
      },
      errorWidget: (context, url, error) {
        debugPrint('IMAGE ERROR: $error | URL: $url');
        return const _Placeholder();
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.coffee_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _BuyButton extends StatelessWidget {
  final Product product;
  final CartProvider cart;

  static const Color primaryButtonColor = Color(0xFF5CBCE5);

  const _BuyButton({required this.product, required this.cart});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => cart.add(product),
        style: FilledButton.styleFrom(
          backgroundColor: primaryButtonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          '${product.price.toInt()} ₽',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _QuantityPanel extends StatelessWidget {
  final Product product;
  final int quantity;
  final CartProvider cart;

  const _QuantityPanel({
    required this.product,
    required this.quantity,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleButton(
            icon: Icons.remove,
            onTap: () => cart.remove(product.id),
          ),
          Text(
            '$quantity',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          _CircleButton(
            icon: Icons.add,
            onTap: quantity < 10 ? () => cart.add(product) : null,
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 20,
          color: onTap != null
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context)
              .colorScheme
              .onPrimaryContainer
              .withOpacity(0.3),
        ),
      ),
    );
  }
}
