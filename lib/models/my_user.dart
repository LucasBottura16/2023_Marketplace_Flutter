
class MyUser{

  String? _idUser;
  String? _name;
  String? _email;
  String? _password;

  MyUser();

  Map<String, dynamic> tpMap(){
    Map<String, dynamic> map = {
      "idUser" : idUser,
      "name" : name
    };

    return map;
  }

  String get password => _password!;

  set password(String value) {
    _password = value;
  }

  String get email => _email!;

  set email(String value) {
    _email = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  String get idUser => _idUser!;

  set idUser(String value) {
    _idUser = value;
  }
}