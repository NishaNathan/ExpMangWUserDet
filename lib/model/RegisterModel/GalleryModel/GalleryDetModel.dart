class GalleryModel {
  final String id;
  final String photoUrl;
  final String title;
  final String description;
  final int user;

  GalleryModel({
    required this.id,
    required this.photoUrl,
    required this.title,
    required this.description,
    required this.user,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: json['id'].toString(),
      photoUrl: json['url'],
      title: json['title'],
      description: json['description'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': photoUrl,
      'title': title,
      'description': description,
      'user': user,
    };
  }
}
