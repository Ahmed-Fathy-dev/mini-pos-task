import 'package:equatable/equatable.dart';

class CatalogModel extends Equatable {
  const CatalogModel({required this.id, required this.name, required this.price});

  final String id;
  final String name;
  final double price;

  factory CatalogModel.fromJson(Map<String, dynamic> json) {
    return CatalogModel(id: json["id"], name: json["name"], price: json["price"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name, "price": price};
  
  @override
  List<Object?> get props => [id, name, price];
}
