import 'package:expense/models/posts_model.dart';

abstract class PostsStates {}

class PostsInitState extends PostsStates {}

class PostsLoadingState extends PostsStates {}

class PostsErrorState extends PostsStates {
  final String messageError;

  PostsErrorState(this.messageError);
}

class PostsSuccessState extends PostsStates {
  final List<PostsModel> posts;

  PostsSuccessState(this.posts);
}
