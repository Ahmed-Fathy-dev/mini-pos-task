import 'dart:io' show Directory;

import 'package:bloc_test/bloc_test.dart';
import 'package:daftra_task/src/util/app_ext.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daftra_task/src/cart/cart_bloc.dart';
import 'package:daftra_task/src/cart/cart_models.dart';
import 'package:daftra_task/src/catalog/catalog_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  });
  group('CartBloc Tests', () {
    late CartBloc cartBloc;
    late CatalogModel testItem1;
    late CatalogModel testItem2;

    setUp(() {
      cartBloc = CartBloc();
      testItem1 = const CatalogModel(id: 'p01', name: 'Coffee', price: 2.50);
      testItem2 = const CatalogModel(id: 'p02', name: 'Bagel', price: 3.20);
    });

    tearDown(() {
      cartBloc.close();
      HydratedBloc.storage.clear();
    });

    test('initial state is empty cart', () {
      expect(cartBloc.state.lines, isEmpty);
      expect(cartBloc.state.totals.subtotal, 0.0);
      expect(cartBloc.state.totals.vat, 0.0);
      expect(cartBloc.state.totals.grandTotal, 0.0);
    });

    group('Required Tests', () {
      blocTest<CartBloc, CartState>(
        'Test 1: Two different items calculate correct totals',
        build: () => cartBloc,
        act: (bloc) => bloc
          ..add(AddItem(testItem1))
          ..add(AddItem(testItem2)),
        expect: () => [
          predicate<CartState>((state) {
            return state.lines.length == 1 &&
                state.lines.first.item.name == 'Coffee' &&
                state.lines.first.quantity == 1 &&
                state.totals.subtotal == 2.50 &&
                state.totals.vat == 0.38 &&
                state.totals.grandTotal == 2.88;
          }),
          predicate<CartState>((state) {
            return state.lines.length == 2 &&
                state.totals.subtotal == 5.70 &&
                state.totals.vat == 0.86 &&
                state.totals.grandTotal == 6.56;
          }),
        ],
      );

      blocTest<CartBloc, CartState>(
        'Test 2: Quantity and discount changes update totals correctly',
        build: () => cartBloc,
        act: (bloc) => bloc
          ..add(AddItem(testItem1))
          ..add(ChangeQuantity('p01', 3))
          ..add(ChangeDiscount('p01', 0.1)),
        expect: () => [
          predicate<CartState>((state) {
            return state.lines.length == 1 && state.totals.subtotal == 2.50;
          }),

          predicate<CartState>((state) {
            return state.lines.first.quantity == 3 &&
                state.totals.subtotal == 7.50 &&
                state.totals.vat == 1.13 &&
                state.totals.grandTotal == 8.63;
          }),

          predicate<CartState>((state) {
            return state.lines.first.discount == 0.1 &&
                state.totals.subtotal == 6.75 &&
                state.totals.vat == 1.01 &&
                state.totals.discount == 0.75 &&
                state.totals.grandTotal == 7.76;
          }),
        ],
      );

      blocTest<CartBloc, CartState>(
        'Test 3: Clearing cart resets state to empty',
        build: () => cartBloc,
        act: (bloc) => bloc
          ..add(AddItem(testItem1))
          ..add(AddItem(testItem2))
          ..add(ChangeQuantity('p01', 2))
          ..add(ClearCart()),
        expect: () => [
          predicate<CartState>((state) => state.lines.length == 1),

          predicate<CartState>((state) => state.lines.length == 2),

          predicate<CartState>(
            (state) => state.lines.first.quantity == 2 && state.totals.subtotal > 0,
          ),

          predicate<CartState>((state) {
            return state.lines.isEmpty &&
                state.totals.subtotal == 0.0 &&
                state.totals.vat == 0.0 &&
                state.totals.discount == 0.0 &&
                state.totals.grandTotal == 0.0;
          }),
        ],
      );
    });

    group('Additional Cart Operations Tests', () {
      blocTest<CartBloc, CartState>(
        'adding same item increases quantity',
        build: () => cartBloc,
        act: (bloc) => bloc
          ..add(AddItem(testItem1))
          ..add(AddItem(testItem1)),
        expect: () => [
          predicate<CartState>((state) {
            return state.lines.length == 1 && state.lines.first.quantity == 1;
          }),
          predicate<CartState>((state) {
            return state.lines.length == 1 &&
                state.lines.first.quantity == 2 &&
                state.totals.subtotal == 5.0;
          }),
        ],
      );

      blocTest<CartBloc, CartState>(
        'removing item deletes it from cart',
        build: () => cartBloc,
        act: (bloc) => bloc
          ..add(AddItem(testItem1))
          ..add(AddItem(testItem2))
          ..add(RemoveItem('p01')),
        expect: () => [
          predicate<CartState>((state) => state.lines.length == 1),
          predicate<CartState>((state) => state.lines.length == 2),
          predicate<CartState>((state) {
            return state.lines.length == 1 &&
                state.lines.first.item.name == 'Bagel' &&
                state.totals.subtotal == 3.20;
          }),
        ],
      );

      blocTest<CartBloc, CartState>(
        'changing quantity to 0 removes item',
        build: () => cartBloc,
        act: (bloc) => bloc
          ..add(AddItem(testItem1))
          ..add(ChangeQuantity('p01', 0)),
        expect: () => [
          predicate<CartState>((state) => state.lines.length == 1),
          predicate<CartState>((state) {
            return state.lines.isEmpty && state.totals.subtotal == 0.0;
          }),
        ],
      );

      blocTest<CartBloc, CartState>(
        'discount is clamped between 0.0 and 1.0',
        build: () => cartBloc,
        act: (bloc) => bloc
          ..add(AddItem(testItem1))
          ..add(ChangeDiscount('p01', 1.5)),
        expect: () => [
          predicate<CartState>((state) => state.lines.length == 1),
          predicate<CartState>((state) {
            return state.lines.first.discount == 1.0 && state.totals.subtotal == 0.0;
          }),
        ],
      );
    });

    group('Business Rules Tests', () {
      test('lineNet calculation is correct', () {
        final cartLine = CartLine(item: testItem1, quantity: 3, discount: 0.2);

        expect(cartLine.lineNet, 6.00);
      });

      test('VAT calculation is 15%', () {
        cartBloc.add(AddItem(testItem1));
        cartBloc.stream.listen((state) {
          if (state.lines.isNotEmpty) {
            final expectedVat = double.parse((state.totals.subtotal * 0.15).asMoney);
            expect(state.totals.vat, expectedVat);
          }
        });
      });

      test('grandTotal = subtotal + vat', () {
        cartBloc.add(AddItem(testItem1));
        cartBloc.add(AddItem(testItem2));

        cartBloc.stream.listen((state) {
          if (state.lines.length == 2) {
            final expectedGrandTotal = double.parse(
              (state.totals.subtotal + state.totals.vat).asMoney,
            );
            expect(state.totals.grandTotal, expectedGrandTotal);
          }
        });
      });
    });

    group('Undo/Redo Tests (Nice-to-have)', () {
      blocTest<CartBloc, CartState>(
        'undo restores previous state',
        build: () => cartBloc,
        act: (bloc) => bloc
          ..add(AddItem(testItem1))
          ..add(AddItem(testItem2))
          ..add(UndoAction()),
        expect: () => [
          predicate<CartState>((state) => state.lines.length == 1),
          predicate<CartState>((state) => state.lines.length == 2),
          predicate<CartState>((state) => state.lines.length == 1),
        ],
      );

      blocTest<CartBloc, CartState>(
        'redo restores undone action',
        build: () => cartBloc,
        act: (bloc) => bloc
          ..add(AddItem(testItem1))
          ..add(AddItem(testItem2))
          ..add(UndoAction())
          ..add(RedoAction()),
        expect: () => [
          predicate<CartState>((state) => state.lines.length == 1),
          predicate<CartState>((state) => state.lines.length == 2),
          predicate<CartState>((state) => state.lines.length == 1),
          predicate<CartState>((state) => state.lines.length == 2),
        ],
      );

      test('canUndo and canRedo work correctly', () {
        expect(cartBloc.canUndo, false);
        expect(cartBloc.canRedo, false);

        cartBloc.add(AddItem(testItem1));

        cartBloc.stream.listen((state) {
          expect(cartBloc.canUndo, true);
          expect(cartBloc.canRedo, false);
        });
      });
    });
  });
}
