import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_provider.dart';

class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  static const Color primaryColor = Color(0xFF5CBCE5);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                child: Row(
                  children: [
                    Text(
                      'Ваш заказ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (cart.cartList.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => cart.clear(),
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),
              ),
              if (cart.cartList.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Корзина пуста',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: cart.cartList.length,
                  itemBuilder: (context, index) {
                    final item = cart.cartList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: item.product.imageUrl != null
                                  ? Image.network(item.product.imageUrl!,
                                  fit: BoxFit.cover)
                                  : Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                child: const Icon(
                                    Icons.coffee_outlined,
                                    size: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.quantity > 1
                                  ? '${item.product.name}  ${item.quantity}'
                                  : item.product.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            '${(item.product.price * item.quantity).toInt()} ₽',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Divider(
                  indent: 32,
                  endIndent: 32,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                  child: Row(
                    children: [
                      Text(
                        'Итого',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        '${cart.total.toInt()} ₽',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Заказ создан'),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Оформить заказ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
