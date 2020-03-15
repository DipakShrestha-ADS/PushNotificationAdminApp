import 'package:push_notification_admin/src/models/push_to_firebase_model.dart';
import 'package:push_notification_admin/src/resources/firestore_provider.dart';

class PushToFireBaseRepository {
  final _fireStoreProvider = FireStoreProvider();

  Future<int> sendDataToFireStoreDatabase(
      PushToFireBaseModel pushToFireBaseModel) {
    return _fireStoreProvider.sendDataToFireStoreDatabase(pushToFireBaseModel);
  }
}
