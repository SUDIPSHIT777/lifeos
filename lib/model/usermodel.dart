class Usermodel {
  String uid;
  String name;
  String email;
  Usermodel({required this.uid, required this.name, required this.email});

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      uid: map['uid'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'uid': uid, 'name': name, 'email': email};
  }
}
