class ItemModel{
  final String userid;
  final String title;
  final String description;

  ItemModel({
    required this.userid,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'title': title,
      'description': description,
    };
  }

}