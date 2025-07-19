import 'dart:convert' show json;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import '../util/app_enums.dart';
import 'catalog_model.dart';

part 'catalog_state.dart';

///* Read-only. On LoadCatalog event emits [CatalogLoaded(List<Item>)].
/// Items come from assets/catalog.json
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc() : super(CatalogState(status: Status.initial)) {
    on<LoadCatalog>(_onLoadCatalog);
  }
  String get _jsonPath => 'assets/catalog.json';
  Future<void> _onLoadCatalog(LoadCatalog event, Emitter<CatalogState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final String jsonString = event.mockJson ?? await rootBundle.loadString(_jsonPath);

      final List<dynamic> jsonList = json.decode(jsonString);
      final List<CatalogModel> items = jsonList
          .map((json) => CatalogModel.fromJson(json as Map<String, dynamic>))
          .toList();

      emit(state.copyWith(status: Status.success, items: items));
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }
}

abstract class CatalogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCatalog extends CatalogEvent {
  final String? mockJson;
  LoadCatalog({this.mockJson});
}
