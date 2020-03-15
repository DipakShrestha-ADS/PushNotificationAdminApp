import 'dart:async';

import 'package:push_notification_admin/src/models/push_to_firebase_model.dart';
import 'package:push_notification_admin/src/resources/repository/push_to_firebase_repository.dart';
import 'package:rxdart/rxdart.dart';

class PushToFireBaseBloc {
  final _pushToFirebaseRepository = PushToFireBaseRepository();

  /*Initialize the Stream Controller for all the text form field or
  edit text field using RxDart library*/
  /*Listening to the stream before any input*/
  final _titleFieldController = BehaviorSubject<String>();
  final _abstractMessageController = BehaviorSubject<String>();
  final _detailedMessageController = BehaviorSubject<String>();
  final _hyperLinkController = BehaviorSubject<String>();

  final _showProgressBarController = BehaviorSubject<bool>();

  //getters for the stream from the respective stream controller
  //Observable is similar to Stream
  Observable<String> get getTitle =>
      _titleFieldController.stream.transform(_validateTitle);
  Observable<String> get getAbstractMessage =>
      _abstractMessageController.stream.transform(_validateAbstractMessage);
  Observable<String> get getDetailedMessage =>
      _detailedMessageController.stream.transform(_validateDetailedMessage);
  Observable<String> get getHyperLinkController =>
      _hyperLinkController.stream.transform(_validateHyperlink);

  //stream for progress bar
  Observable<bool> get getIsShowProgressBar =>
      _showProgressBarController.stream;

  //setters function for the stream controller using sink from respective field
  Function(String) get setTitle => _titleFieldController.sink.add;
  Function(String) get setAbstractMessage =>
      _abstractMessageController.sink.add;
  Function(String) get setDetailedMessage =>
      _detailedMessageController.sink.add;
  Function(String) get setHyperlink => _hyperLinkController.sink.add;

  //add value to the stream controll whether to show progress bar or not
  Function(bool) get setIsShowProgressBar =>
      _showProgressBarController.sink.add;

  //send data to firebase
  Future<int> sendDataToFireStoreDatabase(String userEmail) {
    String dateString = new DateTime.now().toString();

    PushToFireBaseModel pushToFireBaseModel = PushToFireBaseModel(
        _titleFieldController.value,
        _abstractMessageController.value,
        _detailedMessageController.value,
        _hyperLinkController.value,
        dateString,
        userEmail);

    return _pushToFirebaseRepository
        .sendDataToFireStoreDatabase(pushToFireBaseModel);
  }

  //validation for title field
  //this stream transformer transforms string to new string after handling data
  final _validateTitle =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    //check if the title is null or not
    if (title == null) {
      sink.addError('Please add the required field title !');
      return;
    }
    //check if title is empty or not
    if (title.isEmpty) {
      sink.addError('Title field cannot be empty !');
      return;
    }

    //if title is not null and non empty than add title back to the same stream controller
    sink.add(title);
  });

  //validation for abstract message field
  final _validateAbstractMessage =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (absMsg, sink) {
    //check if the abstract Message is null or not
    if (absMsg == null) {
      sink.addError('Please add the required field abstract message !');
      return;
    }
    //check if abstract message is empty or not
    if (absMsg.isEmpty) {
      sink.addError('Abstract message field cannot be empty !');
      return;
    }

    //if abstract message is not null and non empty than add it back to the same stream controller
    sink.add(absMsg);
  });

  //validation for detailed message field
  final _validateDetailedMessage =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (detailMessage, sink) {
    //check if the detailed message is null or not
    if (detailMessage == null) {
      sink.addError('Please add the required field detailed message !');
      return;
    }
    //check if detailed message is empty or not
    if (detailMessage.isEmpty) {
      sink.addError('Detailed message field cannot be empty !');
      return;
    }

    //if detailed message is not null and non empty than add it back to the same stream controller
    sink.add(detailMessage);
  });

  //validation for hyper link field
  final _validateHyperlink = StreamTransformer<String, String>.fromHandlers(
      handleData: (hyperLink, sink) {
    //check if the hyper link is null or not
    if (hyperLink == null) {
      sink.addError('Please add the required field hyperlink !');
      return;
    }
    //check if hyperlink is empty or not
    if (hyperLink.isEmpty) {
      sink.addError('Hyperlink field cannot be empty !');
      return;
    }

    //if hyperlink is not null and non empty than add hyperlink back to the same stream controller
    sink.add(hyperLink);
  });

  //function to close all the stream controller when the widget get disposed
  void dispose() async {
    await _titleFieldController.drain();
    _titleFieldController.close();
    await _abstractMessageController.drain();
    _abstractMessageController.close();
    await _detailedMessageController.drain();
    _detailedMessageController.close();
    await _hyperLinkController.drain();
    _hyperLinkController.close();
    await _showProgressBarController.drain();
    _showProgressBarController.close();
  }

  bool validateAllForm() {
    String title = _titleFieldController.value;
    String abstractMessage = _abstractMessageController.value;
    String detailedMessage = _detailedMessageController.value;
    String hyperlink = _hyperLinkController.value;

    if (title == null || title.isEmpty) {
      setTitle(title);
      return false;
    }
    if (abstractMessage == null || abstractMessage.isEmpty) {
      setAbstractMessage(abstractMessage);
      return false;
    }
    if (hyperlink == null || hyperlink.isEmpty) {
      setHyperlink(hyperlink);
      return false;
    }
    if (detailedMessage == null || detailedMessage.isEmpty) {
      setDetailedMessage(detailedMessage);
      return false;
    }

    return true;
  }
}
