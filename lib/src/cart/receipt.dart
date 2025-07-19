import 'package:equatable/equatable.dart';

import 'cart_bloc.dart' show CartState;

///* The [ReceiptModel] class represents a receipt.
class ReceiptModel extends Equatable {
  final ReceiptHeader header;

  final List<ReceiptLine> lines;

  final ReceiptTotals totals;

  const ReceiptModel({required this.header, required this.lines, required this.totals});

  @override
  List<Object?> get props => [header, lines, totals];

  @override
  String toString() => 'Receipt(header: $header, lines: ${lines.length}, totals: $totals)';
}

/// Builds a [ReceiptModel] from a [CartState] and a [DateTime].
///
/// - Pure function Receipt buildReceipt(CartState, DateTime) that copies the
/// current cart into a DTO (header, lines, totals).
ReceiptModel buildReceipt(CartState cartState, DateTime timestamp) {
  final String receiptNumber = 'R${timestamp.millisecondsSinceEpoch.toString().substring(8)}';

  final ReceiptHeader header = ReceiptHeader(timestamp: timestamp, receiptNumber: receiptNumber);

  final List<ReceiptLine> lines = cartState.lines.map((cartLine) {
    return ReceiptLine(
      itemId: cartLine.item.id,
      itemName: cartLine.item.name,
      itemPrice: cartLine.item.price,
      quantity: cartLine.quantity,
      discount: cartLine.discount,
      lineNet: cartLine.lineNet,
    );
  }).toList();

  final ReceiptTotals totals = ReceiptTotals(
    subtotal: cartState.totals.subtotal,
    vat: cartState.totals.vat,
    discount: cartState.totals.discount,
    grandTotal: cartState.totals.grandTotal,
  );

  return ReceiptModel(header: header, lines: lines, totals: totals);
}

///* The [ReceiptLine] class represents a single line item on a receipt
class ReceiptLine extends Equatable {
  final String itemId;

  final String itemName;

  final double itemPrice;

  final int quantity;

  final double discount;

  final double lineNet;

  const ReceiptLine({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.quantity,
    required this.discount,
    required this.lineNet,
  });

  @override
  List<Object?> get props => [itemId, itemName, itemPrice, quantity, discount, lineNet];
}

///* The [ReceiptTotals] class represents the totals for a receipt.
class ReceiptTotals extends Equatable {
  final double subtotal;

  final double vat;

  final double discount;

  final double grandTotal;

  const ReceiptTotals({
    required this.subtotal,
    required this.vat,
    required this.discount,
    required this.grandTotal,
  });

  @override
  List<Object?> get props => [subtotal, vat, discount, grandTotal];
}

///* The [ReceiptHeader] class represents the header for a receipt.
class ReceiptHeader extends Equatable {
  final DateTime timestamp;

  final String receiptNumber;

  const ReceiptHeader({required this.timestamp, required this.receiptNumber});

  @override
  List<Object?> get props => [timestamp, receiptNumber];
}
