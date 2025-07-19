part of 'catalog_bloc.dart';

class CatalogState extends Equatable {
  const CatalogState({this.status = Status.initial, this.items = const <CatalogModel>[]});
  final Status status;
  final List<CatalogModel> items;

  CatalogState copyWith({Status? status, List<CatalogModel>? items}) =>
      CatalogState(status: status ?? this.status, items: items ?? this.items);
  @override
  List<Object?> get props => [status, items];
}
