import 'package:equatable/equatable.dart';

class PostsEntity extends Equatable {
  final int id;
  final String content;
  final int by;
  final String? imageUrl;
  final int likeCount;
  final String byName;
  final String? byImageUrl;
  final DateTime date;
  final bool liked;

  const PostsEntity({
    required this.id,
    required this.content,
    required this.by,
    required this.likeCount,
    required this.byName,
    required this.byImageUrl,
    required this.imageUrl,
    required this.date,
    required this.liked
  });

  PostsEntity copyWith({
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
    return PostsEntity(
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

  @override
  List<Object?> get props => [
    id,
    content,
    by,
    imageUrl,
    likeCount,
    byName,
    byImageUrl,
    date,
    liked
  ];

}
