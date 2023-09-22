class CurrentUserModel {
  int? idUser;
  String? fullName;
  String? nickname;
  String? email;
  String? picture;

  CurrentUserModel({
    this.idUser,
    this.fullName,
    this.nickname,
    this.email,
    this.picture
  });

  void setCurrentUser(Map<String, dynamic> userJson) {
    this.idUser = int.parse(userJson["IdUser"]);
    this.fullName = userJson["Fullname"];
    this.nickname = userJson["Nickname"];
    this.email = userJson["Email"];
    this.picture = userJson["Picture"];
  }
}