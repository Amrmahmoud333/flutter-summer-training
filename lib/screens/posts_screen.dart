import 'package:expense/cubit/posts_states.dart';
import 'package:expense/screens/posts_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/posts_cubit.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostsCubit>().getPosta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts Screen'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: BlocBuilder<PostsCubit, PostsStates>(
        builder: (context, state) {
          if (state is PostsLoadingState || state is PostsInitState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostsErrorState) {
            return Center(child: Text(state.messageError));
          } else if (state is PostsSuccessState) {
            return ListView.builder(
              itemCount: state.posts.length,

              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostDetailsScreen(post: post),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(post.title),
                        subtitle: Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
