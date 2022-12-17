import 'package:frontend/features/posts/domain/entities/posts_entity.dart';

class PostsModel extends PostsEntity {
  const PostsModel({
    required super.id,
    required super.content,
    required super.by,
    required super.likeCount,
    required super.byName,
    required super.byImageUrl,
    required super.imageUrl,
    required super.date,
    required super.liked
  });

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    return PostsModel(
      id: json["id"],
      content: json["content"],
      by: json["by"],
      likeCount: json["like_count"],
      byName: json["by_name"],
      byImageUrl: json["by_image_url"],
      imageUrl: json["image_url"],
      liked: json["liked"],
      date: DateTime.fromMicrosecondsSinceEpoch(
          (json["date"] * 1000000.0).round()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "image_url": imageUrl,
      "by": by,
      "like_count": likeCount,
      "by_name": byName,
      "by_image_url": byImageUrl,
      "date": date,
      "liked": liked
    };
  }

  PostsModel copyWith({
    int? id,
    String? content,
    int? by,
    String? imageUrl,
    int? likeCount,
    String? byName,
    String? byImageUrl,
    DateTime? date,
    bool? liked
  }) {
    return PostsModel(
        id: id ?? this.id,
        content: content ?? this.content,
        by: by ?? this.by,
        imageUrl: imageUrl ?? this.imageUrl,
        likeCount: likeCount ?? this.likeCount,
        byName: byName ?? this.byName,
        byImageUrl: byImageUrl ?? this.byImageUrl,
        date: date ?? this.date,
        liked: liked ?? this.liked
    );
  }
}
