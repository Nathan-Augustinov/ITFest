class Account {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  String photoURL;

  Account(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.photoURL});
}
