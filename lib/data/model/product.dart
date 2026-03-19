class Product {
  int? id;
  String name;
  double price;
  int quantity;
  double discount;

  double subtotal;
  double total;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.discount,
    this.subtotal = 0,
    this.total = 0,
  });

  void calculate() {
    subtotal = price * quantity;
    total = subtotal - discount;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
      discount: map['discount'],
      subtotal: map['subtotal'],
      total: map['total'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'discount': discount,
      'subtotal': subtotal,
      'total': total,
    };
  }
}