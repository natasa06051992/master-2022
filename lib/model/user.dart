class UserModel {
  String uid;
  String? displayName;
  String? avatarUrl;
  String? email;
  String? phoneNumber;
  String? location;

  bool isHandyman = false;
  set setAvatarUrl(String avatarUrl) {
    this.avatarUrl = avatarUrl;
  }

  UserModel(this.uid,
      {this.displayName,
      this.avatarUrl,
      this.email,
      this.phoneNumber,
      this.location});
  UserModel.create(this.uid, this.displayName, this.email, this.phoneNumber);

  void setLocation(String loc) {
    this.location = loc;
  }
}

class HandymanModel extends UserModel {
  String? service;
  HandymanModel(String uid, displayName, email, phoneNumber, service,
      String selectedLocation)
      : super(uid,
            displayName: displayName,
            email: email,
            phoneNumber: phoneNumber,
            location: selectedLocation) {
    this.service = service;
  }

  void setService(String service) {
    this.service = service;
  }
}

class CustomerModel extends UserModel {
  CustomerModel(
      String uid, displayName, email, phoneNumber, String selectedLocation)
      : super(uid,
            displayName: displayName,
            email: email,
            phoneNumber: phoneNumber,
            location: selectedLocation);
}
