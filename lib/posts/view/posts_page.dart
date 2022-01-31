import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_infinite_list/posts/bloc/posts_bloc.dart';
import 'package:flutter_bloc_infinite_list/posts/view/posts_list.dart';
import 'package:http/http.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (_) => PostsBloc(httpClient: Client())..add(PostsFetched()),
        child: const PostsList(),
      ),
    );
  }
}
