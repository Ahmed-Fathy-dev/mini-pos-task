import 'package:daftra_task/src/catalog/catalog_model.dart';
import 'package:daftra_task/src/util/app_ext.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'cart_models.dart';

part 'cart_events.dart';
part 'cart_state.dart';

///* Events: AddItem, RemoveItem, ChangeQty, ChangeDiscount, ClearCart.
///* State: CartState(lines, totals) where lines = [List<CartLine>].
///* No mutable fields—use value equality.

class CartBloc extends HydratedBloc<CartEvent, CartState> {
  static const int _maxHistorySize = 10;
  final List<CartState> _history = [];
  int _historyIndex = -1;

  CartBloc() : super(const CartState()) {
    _history.add(state);
    _historyIndex = 0;

    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<ChangeQuantity>(_onChangeQuantity);
    on<ChangeDiscount>(_onChangeDiscount);
    on<ClearCart>(_onClearCart);
    on<UndoAction>(_onUndoAction);
    on<RedoAction>(_onRedoAction);
  }

  /// Adds the given [CartState] to the history for undo/redo functionality.
  /// If the current index is not at the end of the history, it removes
  /// all states beyond the current index.
  void _addToHistory(CartState state) {
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(state);
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
    }
    _historyIndex = _history.length - 1;
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    final List<CartLine> newLines = List.from(state.lines);
    final int existingIndex = newLines.indexWhere((line) => line.item.id == event.item.id);

    if (existingIndex >= 0) {
      final CartLine existingLine = newLines[existingIndex];
      newLines[existingIndex] = existingLine.copyWith(quantity: existingLine.quantity + 1);
    } else {
      newLines.add(CartLine(item: event.item, quantity: 1));
    }
    final CartState newState = CartState(lines: newLines).withCalculatedTotals();
    _addToHistory(newState);
    emit(newState);
  }

  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    final List<CartLine> newLines = state.lines
        .where((line) => line.item.id != event.itemId)
        .toList();
    final CartState newState = CartState(lines: newLines).withCalculatedTotals();
    _addToHistory(newState);
    emit(newState);
  }

  void _onChangeQuantity(ChangeQuantity event, Emitter<CartState> emit) {
    final List<CartLine> newLines = state.lines
        .map((line) {
          if (line.item.id == event.itemId) {
            if (event.quantity <= 0) return null;
            return line.copyWith(quantity: event.quantity);
          }
          return line;
        })
        .whereType<CartLine>()
        .toList();
    final CartState newState = CartState(lines: newLines).withCalculatedTotals();
    _addToHistory(newState);
    emit(newState);
  }

  void _onChangeDiscount(ChangeDiscount event, Emitter<CartState> emit) {
    final List<CartLine> newLines = state.lines.map((line) {
      if (line.item.id == event.itemId) {
        return line.copyWith(discount: event.discount.clamp(0.0, 1.0));
      }
      return line;
    }).toList();
    final CartState newState = CartState(lines: newLines).withCalculatedTotals();
    _addToHistory(newState);
    emit(newState);
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    const CartState newState = CartState();
    _addToHistory(newState);
    emit(newState);
  }

  void _onUndoAction(UndoAction event, Emitter<CartState> emit) {
    if (canUndo) {
      _historyIndex--;
      emit(_history[_historyIndex]);
    }
  }

  void _onRedoAction(RedoAction event, Emitter<CartState> emit) {
    if (canRedo) {
      _historyIndex++;
      emit(_history[_historyIndex]);
    }
  }

  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;

  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> linesJson = json['lines'] as List;
      final List<CartLine> lines = linesJson.map((lineJson) {
        return CartLine.fromJson(lineJson as Map<String, dynamic>);
      }).toList();
      return CartState(lines: lines).withCalculatedTotals();
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CartState state) {
    return state.toJson();
  }
}
