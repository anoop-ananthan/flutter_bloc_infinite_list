part of 'posts_bloc.dart';

@immutable
abstract class PostsState {
  final List<Post> posts;
  final bool hasReachedMaximum;
  const PostsState({
    this.posts = const <Post>[],
    required this.hasReachedMaximum,
  });

  List<Object> get props => [posts, hasReachedMaximum];
}

class PostsInitial extends PostsState {
  const PostsInitial() : super(hasReachedMaximum: false);
}

class PostsFetchSuccess extends PostsState {
  const PostsFetchSuccess(
    List<Post> posts,
    bool hasReachedMaximum,
  ) : super(
          posts: posts,
          hasReachedMaximum: hasReachedMaximum,
        );
}

class PostsFetchFailure extends PostsState {
  final Exception exception;

  const PostsFetchFailure(
    List<Post> posts,
    bool hasReachedMaximum,
    this.exception,
  ) : super(
          posts: posts,
          hasReachedMaximum: hasReachedMaximum,
        );

  @override
  List<Object> get props => [exception.toString()];
}

class PostsFetching extends PostsState {
  const PostsFetching() : super(hasReachedMaximum: false);
}
