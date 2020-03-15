import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_admin/src/blocs/pushDataToFirebase/push_to_firebase_bloc.dart';
import 'package:push_notification_admin/src/blocs/pushDataToFirebase/push_to_firebase_bloc_provider.dart';
import 'package:push_notification_admin/src/utils/strings_constants.dart';

class PushToFireBaseForm extends StatefulWidget {
  //signed in auth result for current user details
  final AuthResult _firebaseCurrentAuthResult;

  PushToFireBaseForm(this._firebaseCurrentAuthResult);

  @override
  State<StatefulWidget> createState() {
    return PushToFireBaseFormState();
  }
}

class PushToFireBaseFormState extends State<PushToFireBaseForm> {
  //creating object for PushToFireBaseBloc
  PushToFireBaseBloc _pushToFireBaseBloc;

  @override
  void didChangeDependencies() {
    //initiating PushToFireBaseBloc object
    _pushToFireBaseBloc = PushToFireBaseBlocProvider.of(context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //need to close all the steam controller inside the PushToFireBaseBloc when this widget disposed
    _pushToFireBaseBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    titleFocusNode.unfocus();
    abstractMessageFocusNode.unfocus();
    detailedMessageFocusNode.unfocus();
    hyperlinkFocusNode.unfocus();
    return Container(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30.0),
              ),
              titleField(),
              Container(
                margin: EdgeInsets.only(top: 20.0),
              ),
              abstractMessageField(),
              Container(
                margin: EdgeInsets.only(top: 20.0),
              ),
              hyperLinkField(),
              Container(
                margin: EdgeInsets.only(top: 20.0),
              ),
              detailedMessageField(),
              Container(
                margin: EdgeInsets.only(top: 30.0),
              ),
              publishButton(),
            ],
          ),
        ),
      ),
    );
  }

  //initiating focus node for title edit field
  final titleFocusNode = new FocusNode();

  //Edit text field for Title
  Widget titleField() {
    return StreamBuilder(
      stream: _pushToFireBaseBloc.getTitle,
      builder: (context, titleSnapshot) {
        return TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: StringsConstants.titleLabel,
            icon: Icon(Icons.title),
            border: OutlineInputBorder(),
            errorText: titleSnapshot.error,
          ),
          onChanged: (title) {
            _pushToFireBaseBloc.setTitle(title);
          },
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          focusNode: titleFocusNode,
          onFieldSubmitted: (value) {
            //on submitted this title edit field: focusing to the next, abstract message field
            FocusScope.of(context).requestFocus(abstractMessageFocusNode);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  //initiating focus node for abstract message edit field
  final abstractMessageFocusNode = new FocusNode();

  //Edit text field for abstract message
  Widget abstractMessageField() {
    return StreamBuilder(
      stream: _pushToFireBaseBloc.getAbstractMessage,
      builder: (context, absMsgSnapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: StringsConstants.abstractLabel,
            icon: Icon(Icons.textsms),
            border: OutlineInputBorder(),
            errorText: absMsgSnapshot.error,
          ),
          maxLength: 255,
          buildCounter: (
            BuildContext context, {
            int currentLength,
            int maxLength,
            bool isFocused,
          }) {
            return Text('$currentLength / $maxLength');
          },
          focusNode: abstractMessageFocusNode,
          onChanged: (absMsg) {
            _pushToFireBaseBloc.setAbstractMessage(absMsg);
          },
          onFieldSubmitted: (value) {
            //on submitted this abstract message edit field: focusing to the next, detailed message field
            FocusScope.of(context).requestFocus(hyperlinkFocusNode);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  //initiating focus node for detailed message edit field
  final detailedMessageFocusNode = new FocusNode();

  //Edit text Field for Multiline Text
  Widget detailedMessageField() {
    return StreamBuilder(
      stream: _pushToFireBaseBloc.getDetailedMessage,
      builder: (context, detailSnapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: StringsConstants.detailedMessageLabel,
            icon: Icon(Icons.message),
            border: OutlineInputBorder(),
            errorText: detailSnapshot.error,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          focusNode: detailedMessageFocusNode,
          onChanged: (detailMsg) {
            _pushToFireBaseBloc.setDetailedMessage(detailMsg);
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }

  //initiating focus node for hyperlink edit field
  final hyperlinkFocusNode = new FocusNode();

  //Edit text field for Hyperlink
  Widget hyperLinkField() {
    return StreamBuilder(
      stream: _pushToFireBaseBloc.getHyperLinkController,
      builder: (context, hyperlinkSnapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: StringsConstants.hyperLinkLabel,
            icon: Icon(Icons.insert_link),
            border: OutlineInputBorder(),
            errorText: hyperlinkSnapshot.error,
          ),
          keyboardType: TextInputType.url,
          focusNode: hyperlinkFocusNode,
          onChanged: (hyperlink) {
            _pushToFireBaseBloc.setHyperlink(hyperlink);
          },
          onFieldSubmitted: (hyperlink) {
            FocusScope.of(context).requestFocus(detailedMessageFocusNode);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  //publish button to send data in firebase
  Widget publishButton() {
    return StreamBuilder(
      initialData: false,
      stream: _pushToFireBaseBloc.getIsShowProgressBar,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.data) {
          return publishButtonWidget();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  //widget for publish button view
  Widget publishButtonWidget() {
    return RaisedButton(
      color: Colors.deepPurple,
      splashColor: Colors.purpleAccent,
      focusColor: Colors.white70,
      onPressed: () {
        if (_pushToFireBaseBloc.validateAllForm()) {
          _pushToFireBaseBloc.setIsShowProgressBar(true);
          _pushToFireBaseBloc
              .sendDataToFireStoreDatabase(
                  widget._firebaseCurrentAuthResult.user.email)
              .then((value) {
            if (value == 1) {
              showSnackMessage(
                  'Successfully send data to Firebase Database. 😍');
              _pushToFireBaseBloc.setIsShowProgressBar(false);
            }
          }).catchError((e) {
            showSnackMessage('Error got ${e.message}');
            _pushToFireBaseBloc.setIsShowProgressBar(false);
          });
        } else {
          showSnackMessage('Some of the field contains error !');
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          StringsConstants.publishButtonText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  void showSnackMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.deepOrange,
      duration: new Duration(seconds: 2),
      elevation: 8.0,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
