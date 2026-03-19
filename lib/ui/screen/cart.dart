import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/product_viewmodel.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);
    final vm = ref.read(productProvider.notifier);

    final totalSubtotal = products.fold<double>(
      0.0,
          (sum, p) => sum + p.subtotal,
    );

    final totalDiscount = products.fold<double>(
      0.0,
          (sum, p) => sum + p.discount,
    );

    final total = products.fold<double>(
      0.0,
          (sum, p) => sum + p.total,
    );

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Column(
        children: [
          /// GRID VIEW
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait ? 1 : 2,
                mainAxisExtent: 160, // ✅ FIX OVERFLOW
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        /// INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text("Price: ${p.price}"),
                              Text("Discount: ${p.discount}"),

                              const SizedBox(height: 8),

                              /// QUANTITY
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => vm.decrease(p),
                                  ),
                                  Text("${p.quantity}"),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => vm.increase(p),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// DELETE BUTTON
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => vm.delete(p.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// TOTAL SECTION
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Subtotal: $totalSubtotal"),
                Text("Discount: $totalDiscount"),
                const SizedBox(height: 5),
                Text(
                  "Total: $total",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Checkout"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}