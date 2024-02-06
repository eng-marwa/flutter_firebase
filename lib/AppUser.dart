class AppUser {
  String uid = '';
  String email = '';
  String phone = '';
  String name = '';

  AppUser(this.uid, this.email, this.phone, this.name);

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(map['uid'], map['email'], map['phone'], map['name']);
  }

  Map<String, dynamic> toMap() =>
      {'uid': uid, 'email': email, 'phone': phone, 'name': name};

  @override
  String toString() {
    return 'AppUser{uid: $uid, email: $email, phone: $phone, name: $name}';
  }
}
