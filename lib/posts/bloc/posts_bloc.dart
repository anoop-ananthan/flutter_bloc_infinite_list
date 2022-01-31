import 'dart:convert';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_infinite_list/posts/model/post.dart';
import 'package:http/http.dart' as http;
part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final http.Client httpClient;

  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }

  PostsBloc({required this.httpClient}) : super(const PostsInitial()) {
    on<PostsFetched>(
      (event, emit) async {
        try {
          if (state.hasReachedMaximum) {
            return;
          }
          emit(PostsFetching(state.posts, (state is PostsInitial)));
          final result = await _fetchPosts(state.posts.length);
          final posts = [...state.posts, ...result];
          final hasReachedMaximum = result.isEmpty;
          emit(PostsFetchSuccess(posts, hasReachedMaximum));
        } catch (e) {
          emit(PostsFetchFailure(
            state.posts,
            state.hasReachedMaximum,
            e,
          ));
        }
      },
      transformer: throttleDroppable(const Duration(microseconds: 500)),
    );
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    debugPrint('Query params: $startIndex, 50');
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '50'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        return Post.fromMap(json);
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
