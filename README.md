# flutter_bloc_infinite_list

A sample application to learn flutter bloc the correct way. Took some deviations from the tutorial and based on the experiance here are some notes to self:
1. You can do many things with Cubit and don't need Bloc all the time. In this example, there are transformation using events, debounce etc... Therefore, Blocs is really needed here.

2. Using enumeration for the loading status is better than writing specific classes for each state as it increases boilerplate code.

3. I love bloc! :heart:

## Getting Started

This application is inspired from the bloc [tutorial](https://bloclibrary.dev/#/flutterinfinitelisttutorial).

## Project Structure

Follows a **feature-driven directory structure.**

Refer the project structure directly from the tutorial from [here](https://bloclibrary.dev/#/flutterinfinitelisttutorial?id=project-structure).

<pre>
├── lib
| ├── posts
│ │ ├── bloc
│ │ │ └── post_bloc.dart
| | | └── post_event.dart
| | | └── post_state.dart
| | └── models
| | | └── models.dart*
| | | └── post.dart
│ │ └── view
│ │ | ├── posts_page.dart
│ │ | └── posts_list.dart
| | | └── view.dart*
| | └── widgets
| | | └── bottom_loader.dart
| | | └── post_list_item.dart
| | | └── widgets.dart*
│ │ ├── posts.dart*
│ ├── app.dart
│ ├── simple_bloc_observer.dart
│ └── main.dart
├── pubspec.lock
├── pubspec.yaml
</pre>

## Useful Links

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [Tutorial](https://bloclibrary.dev/#/flutterinfinitelisttutorial)
