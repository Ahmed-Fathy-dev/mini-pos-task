import 'package:bloc_test/bloc_test.dart';
import 'package:daftra_task/src/catalog/catalog_bloc.dart';
import 'package:daftra_task/src/util/app_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatalogBloc Tests', () {
    const validCatalogJson = '''
      [ { "id": "p01", "name": "Coffee", "price": 2.50 } ]
    ''';
    const malformedCatalogJson = 'this is not a valid json';

    blocTest<CatalogBloc, CatalogState>(
      'loads catalog successfully from JSON asset',
      build: () => CatalogBloc(),

      act: (bloc) => bloc.add(LoadCatalog(mockJson: validCatalogJson)),
      expect: () => [
        const CatalogState(status: Status.loading),
        predicate<CatalogState>((state) {
          return state.status == Status.success && state.items.length == 1;
        }),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'emits failure when JSON is malformed',
      build: () => CatalogBloc(),

      act: (bloc) => bloc.add(LoadCatalog(mockJson: malformedCatalogJson)),
      expect: () => [
        const CatalogState(status: Status.loading),
        const CatalogState(status: Status.failure),
      ],
    );
  });
}
