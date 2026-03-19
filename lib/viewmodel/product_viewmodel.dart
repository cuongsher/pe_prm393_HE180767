import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/product.dart';
import '../data/repository/product_repository.dart';

final productProvider = StateNotifierProvider<ProductViewModel, List<Product>>((
  ref,
) {
  return ProductViewModel();
});

class ProductViewModel extends StateNotifier<List<Product>> {
  ProductViewModel() : super([]) {
    init();
  }

  final repo = ProductRepository();

  Future<void> init() async {
    await seedIfEmpty();
  }

  Future<void> load() async {
    state = await repo.getAll();
  }

  Future<void> seedIfEmpty() async {
    final data = await repo.getAll();
    if (data.isNotEmpty) {
      state = data;
      return;
    }
    final samples = [
      Product(name: "AirPods", price: 5000000, quantity: 2, discount: 200000),
      Product(name: "MacBook", price: 25000000, quantity: 1, discount: 1000000),
    ];
    for (var p in samples) {
      await repo.insert(p);
    }
    state = await repo.getAll();
  }

  Future<void> increase(Product p) async {
    p.quantity++;
    p.calculate();
    await repo.update(p);
    state = [...state];
  }

  Future<void> decrease(Product p) async {
    if (p.quantity > 1) {
      p.quantity--;
      p.calculate();
      await repo.update(p);
      state = [...state];
    }
  }

  Future<void> delete(int id) async {
    await repo.delete(id);
    state = state.where((e) => e.id != id).toList();
  }
}
