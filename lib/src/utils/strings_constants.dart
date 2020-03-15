class StringsConstants {
  // app main title constant
  static const String appTitle = "Publish To Firebase";

  //constant related to login and signup
  static const String emailHint = "Enter Email ID";
  static const String passwordHint = "Enter Password";
  static const String login = "Login";
  static const String signUp = "Signup";
  static const String emailValidateErrorMsg = "Please enter a valid email id !";
  static const String passwordValidateErrorMsg =
      "Password length must be greater than or equal to 6 !";

  //constant related to push to firebase screen
  static const String titleLabel = "Title";
  static const String abstractLabel = "Abstract Message";
  static const String detailedMessageLabel = "Detailed Message";
  static const String hyperLinkLabel = "Hyperlink";
  static const String publishButtonText = "Publish";

  //constant relatedd to profile card inside push to firebase screeen
  static const String welcomeText = "Welcome";
  static const String nameText = "Name";

  //appbar action's logout constant
  static const String logoutText = "Logout";

  //firebase database: firestore related constant
  //these constant is the key for the firestore database in firebase
  static const String pushNotificationDataBaseName = "pushData";
  static const String titleKey = "title";
  static const String abstractMessageKey = "abstractMessage";
  static const String detailedMessageKey = "detailedMessage";
  static const String hyperlinkKey = "hyperlink";
  static const String publisDateKey = "publishDate";
  static const String userEmailKey = "userEmail";
}
