import '../db/database_helper.dart';
import '../model/product.dart';

class ProductRepository {
  final db = DatabaseHelper();

  Future<List<Product>> getAll() async {
    final data = await db.getProducts();
    return data.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> insert(Product p) async {
    p.calculate();
    await db.insertProduct(p.toMap());
  }

  Future<void> update(Product p) async {
    p.calculate();
    await db.updateProduct(p.toMap());
  }

  Future<void> delete(int id) async {
    await db.deleteProduct(id);
  }
}