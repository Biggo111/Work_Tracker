class UserModel{

  final String? id;
  final String name;
  final String email;

  UserModel({this.id, required this.name, required this.email});

  toJson(){
    return {
      "name": name,
      "email": email
    };
  }
}