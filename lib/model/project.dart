class Project {
  late DateTime date;
  late String description;
  late String imageOfCustomer;
  late String location;
  late String name;
  late String service;
  late String title;
  late String uid;
  Project({
    required this.uid,
    required this.date,
    required this.description,
    required this.imageOfCustomer,
    required this.location,
    required this.name,
    required this.service,
    required this.title,
  });

  Project.fromDocumentSnapshot(Map<String, dynamic> snapshot) {
    name = snapshot['name'];
    date = snapshot['date'] as DateTime;
    uid = snapshot['uid'];
    description = snapshot['description'];
    imageOfCustomer = snapshot['imageOfCustomer'];
    location = snapshot['location'];
    service = snapshot['service'];
    title = snapshot['title'];
  }
}
