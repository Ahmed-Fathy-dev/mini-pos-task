import 'package:daftra_task/src/util/app_ext.dart';
import 'package:equatable/equatable.dart';

import '../catalog/catalog_model.dart';

class CartLine extends Equatable {
  final CatalogModel item;

  final int quantity;
  final double discount;
  const CartLine({required this.item, required this.quantity, this.discount = 0.0});

  double get lineNet {
    final double baseAmount = item.price * quantity;
    final double discountAmount = baseAmount * discount;
    return double.parse((baseAmount - discountAmount).asMoney);
  }

  factory CartLine.fromJson(Map<String, dynamic> json) {
    return CartLine(
      item: CatalogModel.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  CartLine copyWith({CatalogModel? item, int? quantity, double? discount}) {
    return CartLine(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
    );
  }

  Map<String, dynamic> toJson() {
    return {'item': item.toJson(), 'quantity': quantity, 'discount': discount};
  }

  @override
  List<Object?> get props => [item, quantity, discount];
}

class CartTotals extends Equatable {
  final double subtotal;

  final double vat;

  final double discount;

  final double grandTotal;

  const CartTotals({
    required this.subtotal,
    required this.vat,
    required this.discount,
    required this.grandTotal,
  });

  const CartTotals.empty() : subtotal = 0.0, vat = 0.0, discount = 0.0, grandTotal = 0.0;

  @override
  List<Object?> get props => [subtotal, vat, discount, grandTotal];
}
