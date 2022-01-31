import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_infinite_list/posts/bloc/posts_bloc.dart';
import 'package:flutter_bloc_infinite_list/posts/model/post.dart';

class PostsList extends StatefulWidget {
  const PostsList({Key? key}) : super(key: key);

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (isScrollAtBottom()) {
      context.read<PostsBloc>().add(PostsFetched());
    }
  }

  bool isScrollAtBottom() {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll * .9;
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is PostsInitial ||
            (state is PostsFetching && state.isInitial)) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is PostsFetchSuccess ||
            (state is PostsFetching && !state.isInitial)) {
          return ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, i) {
              if (i >= state.posts.length) {
                return state.hasReachedMaximum
                    ? const SizedBox()
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
              } else {
                final post = state.posts[i];
                return PostListItem(post: post);
              }
            },
            separatorBuilder: (_, i) => const Divider(),
            itemCount: state.posts.length + 1,
          );
        } else if (state is PostsFetchFailure) {
          return ErrorWidget(exception: state.exception);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class PostListItem extends StatelessWidget {
  const PostListItem({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text(post.body),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final dynamic exception;
  const ErrorWidget({
    Key? key,
    required this.exception,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
            size: 120,
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              exception.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}
