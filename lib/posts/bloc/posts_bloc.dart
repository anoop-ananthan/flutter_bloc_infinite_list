import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_infinite_list/posts/model/post.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final http.Client httpClient;

  PostsBloc({required this.httpClient}) : super(const PostsInitial()) {
    on<PostsFetched>((event, emit) async {
      try {
        if (state.hasReachedMaximum) return;
        // if (state is PostsInitial) {
        final posts = await _fetchPosts(state.posts.length);
        state.posts.addAll(posts);
        emit(PostsFetchSuccess(posts, false));
        // }
      } catch (e) {
        emit(PostsFetchFailure(
          state.posts,
          state.hasReachedMaximum,
          e as Exception,
        ));
      }
    });
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '20'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        return Post(
          id: json['id'] as int,
          title: json['title'] as String,
          body: json['body'] as String,
          userId: 0,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
