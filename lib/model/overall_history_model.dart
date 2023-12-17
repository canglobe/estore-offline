class OverallHistoryModel {
  String? customer;
  String? product;
  String? price;
  String? quantity;
  String? date;

  OverallHistoryModel({
    required this.customer,
    required this.product,
    required this.price,
    required this.quantity,
    date,
  });

  toMap() {
    return {
      'name': customer,
      'product': product,
      'price': price,
      'quantity': quantity,
    };
  }
}
