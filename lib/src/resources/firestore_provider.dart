import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:push_notification_admin/src/models/push_to_firebase_model.dart';
import 'package:push_notification_admin/src/utils/strings_constants.dart';

class FireStoreProvider {
  //get instance of firestore
  Firestore _firestore = Firestore.instance;

  //get if there is user stored in database
  Future<int> getUser(String email, String password) async {
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  //store user in firestore database
  Future<void> storeUser(String email, String password) async {
    return _firestore
        .collection("users")
        .document(email)
        .setData({'email': email, 'password': password});
  }

  //send data to firestore database
  Future<int> sendDataToFireStoreDatabase(
      PushToFireBaseModel pushToFireBaseModel) async {
    return await _firestore
        .collection(StringsConstants.pushNotificationDataBaseName)
        .document(pushToFireBaseModel.title)
        .setData({
      StringsConstants.titleKey: pushToFireBaseModel.title,
      StringsConstants.abstractMessageKey: pushToFireBaseModel.abstractMessage,
      StringsConstants.detailedMessageKey: pushToFireBaseModel.detailedMessage,
      StringsConstants.hyperlinkKey: pushToFireBaseModel.hyperlink,
      StringsConstants.publisDateKey: pushToFireBaseModel.datePublished,
      StringsConstants.userEmailKey: pushToFireBaseModel.userEmail,
    }).then(
      (value) {
        //return 1 to verify if data is sent to database or not
        return 1;
      },
    );
  }
}
