class UserModel {
  String uid;
  String displayName;
  String? avatarUrl;
  String email;
  String? phoneNumber;
  String? location;
  String? service;
  bool isHandyMan = false;
  set setAvatarUrl(String avatarUrl) {
    this.avatarUrl = avatarUrl;
  }

  UserModel(this.uid, this.displayName, this.avatarUrl, this.email,
      this.phoneNumber, this.location);
  UserModel.create(this.uid, this.displayName, this.email, this.phoneNumber);

  void setLocation(String loc) {
    this.location = loc;
  }

  void setRole(bool isHandyMan) {
    this.isHandyMan = isHandyMan;
  }

  void setService(String service) {
    this.service = service;
  }
}
