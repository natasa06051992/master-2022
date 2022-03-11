import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  late String image;
  late List<Price> price = [];
  late String name;
  Category({
    required this.name,
    required this.price,
    required this.image,
  });

  Category.fromDocumentSnapshot(QueryDocumentSnapshot<Object?> snapshot) {
    image = snapshot['image'];
    name = snapshot['name'];

    for (var priceFromSnapshot in snapshot['pricePerLocation']) {
      price.add(Price.fromDocumentSnapshot(priceFromSnapshot));
    }
  }
}

class Price {
  late String location;
  late double? price;
  Price({
    required this.location,
    required this.price,
  });
  Price.fromDocumentSnapshot(Map<String, dynamic> snapshot) {
    String priceFromFirebase = snapshot['price'];
    location = snapshot['location'];
    price = double.tryParse(priceFromFirebase) ?? 0;
  }
}
