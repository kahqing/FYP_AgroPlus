import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;
  final bool isFixedPrice;
  final DateTime createdDate;
  final bool isSold; // true for sold out
  final String sellerId;

  Map<String, dynamic>? sellerData;
  final String? brand;
  final String? model;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    required this.isFixedPrice,
    required this.sellerId,
    required this.createdDate,
    required this.isSold,
    this.sellerData,
    this.brand,
    this.model,
  });

  //factory method to take DocumentSnapshot and convert to object
  factory Product.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final id = doc.id;
    //final sellerRef = data['sellerRef'] as DocumentReference;
    return Product(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      image: data['image'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      isFixedPrice: data['isFixedPrice'] ?? true,
      isSold: data['isSold'] ?? false,
      createdDate: (data['createdDate'] as Timestamp).toDate(),
      sellerId: data['sellerId'] ?? '',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
    );
  }

  // Factory constructor to create a Product from a map
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    //final sellerRef = map['sellerRef'] as DocumentReference;
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: (map['category'] ?? ''),
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      isFixedPrice: map['isFixedPrice'] ?? true,
      isSold: map['isSold'] ?? false,
      createdDate: (map['createdDate'] as Timestamp).toDate(),
      sellerId: map['sellerId'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
    );
  }

  //method to fetch seller Data from firebase and set the seller data (used in detail screen)
  Future<void> fetchSellerData() async {
    try {
      final userQuery = await FirebaseFirestore.instance
          .collection('seller')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // Assuming you only expect one document for a unique 'matric' value
        final userDoc = userQuery.docs.first;
        sellerData = userDoc.data() as Map<String, dynamic>;
      } else {
        // Handle the case where no document is found for the given 'matric'
        print('User document not found for matric: $sellerId');
      }
    } catch (e) {
      // Handle any errors that might occur during the fetch
      print('Error fetching user data: $e');
    }
  }
}
