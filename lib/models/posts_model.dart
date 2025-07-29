class PostsModel {
  final int id;
  final String title;
  final String body;
  PostsModel({required this.id, required this.title, required this.body});

  PostsModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      body = json['body'];
}
