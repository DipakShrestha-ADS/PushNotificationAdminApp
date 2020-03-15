import 'package:flutter/material.dart';
import 'package:push_notification_admin/src/blocs/pushDataToFirebase/push_to_firebase_bloc.dart';

class PushToFireBaseBlocProvider extends InheritedWidget {
  final pushToFireBaseBloc = PushToFireBaseBloc();

  PushToFireBaseBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static PushToFireBaseBloc of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<PushToFireBaseBlocProvider>()
        .pushToFireBaseBloc);
  }
}
