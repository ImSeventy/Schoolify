import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final String email;
  final int id;
  final int rfId;
  final String name;
  final int entryYear;
  final int majorId;
  final String majorName;

  const StudentEntity({
    required this.email,
    required this.id,
    required this.rfId,
    required this.name,
    required this.entryYear,
    required this.majorId,
    required this.majorName,
  });

  @override
  List<Object?> get props => [
    email,
    id,
    rfId,
    name,
    entryYear,
    majorId,
    majorName
  ];
}
