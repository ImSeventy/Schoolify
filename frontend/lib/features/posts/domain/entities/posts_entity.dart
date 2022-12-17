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
