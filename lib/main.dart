import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_infinite_list/app.dart';
import 'package:flutter_bloc_infinite_list/posts/bloc/posts_bloc.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(const App()),
    blocObserver: SimpleBlocObserver(),
  );
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('${bloc.runtimeType}, $error');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType}, $change');
    if (change.nextState is PostsFetchSuccess) {
      // debugPrint('> No: of posts is ${change.nextState.posts.length}');
    }
  }
}
