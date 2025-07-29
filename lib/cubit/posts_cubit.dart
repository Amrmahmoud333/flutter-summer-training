import 'package:dio/dio.dart';
import 'package:expense/cubit/posts_states.dart';
import 'package:expense/models/posts_model.dart';
import 'package:expense/service%20/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsCubit extends Cubit<PostsStates> {
  PostsCubit() : super(PostsInitState());
  Future<void> getPosta() async {
    emit(PostsLoadingState());
    try {
      final Response reponse = await DioHelper.getData(endpoint: '/posts');
      print('Response data: ${reponse.data}');
      List<PostsModel> posts = [];

      for (var post in reponse.data['posts']) {
        posts.add(PostsModel.fromJson(post));
      }
      emit(PostsSuccessState(posts));
    } catch (e) {
      emit(PostsErrorState(e.toString()));
    }
  }
}
