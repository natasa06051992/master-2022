class UserModel {
  String uid;
  String? displayName;
  String? avatarUrl;
  String? email;
  String? phoneNumber;
  String location;

  bool isHandyman = false;

  UserModel(this.uid,
      {this.displayName,
      this.avatarUrl,
      this.email,
      this.phoneNumber,
      required this.location});

  void setAvatarUrl(String url) {
    avatarUrl = avatarUrl;
  }
}

class HandymanModel extends UserModel {
  String? service;
  double? stars;
  int? startingPrice;
  String? description;
  int? yearsInBusiness;
  List<String>? urlToGallery;
  HandymanModel(String uid, displayName, email, phoneNumber, service,
      String selectedLocation, String? url)
      : super(uid,
            displayName: displayName,
            email: email,
            phoneNumber: phoneNumber,
            location: selectedLocation,
            avatarUrl: url) {
    this.service = service;
    urlToGallery = <String>[];
  }
  addToGallery(String url) {
    urlToGallery?.add(url);
  }

  void setStartingPrice(int price) {
    startingPrice = price;
  }

  void setYearsInBusiness(int years) {
    yearsInBusiness = years;
  }

  void setDescription(String description) {
    this.description = description;
  }

  void setService(String service) {
    this.service = service;
  }

  void setStars(double stars) {
    this.stars = stars;
  }
}

class CustomerModel extends UserModel {
  CustomerModel(String uid, displayName, email, phoneNumber,
      String selectedLocation, String? url)
      : super(uid,
            displayName: displayName,
            email: email,
            phoneNumber: phoneNumber,
            location: selectedLocation,
            avatarUrl: url);
}
