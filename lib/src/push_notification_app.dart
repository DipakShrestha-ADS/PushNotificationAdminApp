import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_admin/src/blocs/login/login_bloc_provider.dart';
import 'package:push_notification_admin/src/ui/login.dart';

class PushNotificationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*Here we use BLoC: Business Logic Components Architecture to build our App.*/
    /*Wrapping MaterialApp by InheritedWidget: LoginBlocProvider help to
      access the LoginBloc object throughout the widget tree.*/
    return LoginBlocProvider(
      //also wrapping with PushToFireBaseBlocProvider to give access of PushToFireBaseBloc instance for business logic
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.purpleAccent,
        ),
        home: LoginUi(),
      ),
    );
  }
}
