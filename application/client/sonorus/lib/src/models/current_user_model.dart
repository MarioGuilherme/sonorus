class CurrentUserModel {
  int? userId;
  String? fullName;
  String? nickname;
  String? email;
  String? picture;

  CurrentUserModel({
    this.userId,
    this.fullName,
    this.nickname,
    this.email,
    this.picture
  });

  void setCurrentUser(Map<String, dynamic> userJson) {
    this.userId = int.parse(userJson["UserId"]);
    this.fullName = userJson["Fullname"];
    this.nickname = userJson["Nickname"];
    this.email = userJson["Email"];
    this.picture = userJson["Picture"];
  }

  void setNewPicturePath(String path) => this.picture = path;

  void logout() {
    this.userId = null;
    this.fullName = null;
    this.nickname = null;
    this.email = null;
    this.picture = null;
  }
}