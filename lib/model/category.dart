import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  late String image;
  late String? price;
  late String name;
  Category({
    required this.name,
    required this.price,
    required this.image,
  });

  Category.fromDocumentSnapshot(QueryDocumentSnapshot<Object?> snapshot) {
    image = snapshot['image'];
    name = snapshot['name'];
    price = snapshot['price'];
  }
}
