part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddItem extends CartEvent {
  final CatalogModel item;

  AddItem(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveItem extends CartEvent {
  final String itemId;

  RemoveItem(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ChangeQuantity extends CartEvent {
  final String itemId;

  final int quantity;

  ChangeQuantity(this.itemId, this.quantity);

  @override
  List<Object?> get props => [itemId, quantity];
}

class ChangeDiscount extends CartEvent {
  final String itemId;

  final double discount;

  ChangeDiscount(this.itemId, this.discount);

  @override
  List<Object?> get props => [itemId, discount];
}

class ClearCart extends CartEvent {}

class UndoAction extends CartEvent {}

class RedoAction extends CartEvent {}
