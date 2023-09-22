import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../model/Post.dart';

part 'network_event.dart';

part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial()) {
    on<NetworkEvent>((event, emit) {});
    on<GetPost>((event, emit) async {
      Dio dio = Dio();
      emit(NetworkLoading());
      try {
        var response =
            await dio.get("https://jsonplaceholder.typicode.com/posts");
        if (response.statusCode == 200) {
          emit(NetworkSuccess(listFromJson(response.data)));
        } else {
          emit(NetworkError("Noma'lum xatolik"));
        }
      } on DioException catch (e) {
        if(e.response?.statusCode==404)
        emit(NetworkError("Kontent topilmadi"));
      }
    });
  }
}
