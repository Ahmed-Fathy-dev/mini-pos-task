part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartLine> lines;

  final CartTotals totals;

  const CartState({this.lines = const [], this.totals = const CartTotals.empty()});

  CartState copyWith({List<CartLine>? lines, CartTotals? totals}) {
    return CartState(lines: lines ?? this.lines, totals: totals ?? this.totals);
  }

  /// Returns a new [CartState] with calculated [CartTotals].
  /// The calculation is as follows:
  ///
  /// - [CartTotals.subtotal] is the sum of the [CartLine.lineNet]s.
  /// - [CartTotals.vat] is 15% of [CartTotals.subtotal] rounded to the nearest
  ///   cent.
  /// - [CartTotals.discount] is the sum of the discounts applied to each line,
  ///   rounded to two decimal places.
  /// - [CartTotals.grandTotal] is the sum of [CartTotals.subtotal] and
  ///   [CartTotals.vat], rounded to two decimal places.
  CartState withCalculatedTotals() {
    final double subtotal = lines.fold(0.0, (sum, line) => sum + line.lineNet);

    final int subtotalInCents = (subtotal * 100).round();
    final int vatInCents = (subtotalInCents * 15 / 100).round();
    final double vat = vatInCents / 100.0;

    final double totalDiscountAmount = lines.fold(
      0.0,
      (sum, line) => sum + (line.item.price * line.quantity * line.discount),
    );

    final double grandTotal = double.parse((subtotal + vat).asMoney);

    return copyWith(
      totals: CartTotals(
        subtotal: subtotal,
        vat: vat,
        discount: double.parse(totalDiscountAmount.asMoney),
        grandTotal: grandTotal,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lines': lines.map((line) => line.toJson()).toList()};
  }

  @override
  List<Object?> get props => [lines, totals];
}
