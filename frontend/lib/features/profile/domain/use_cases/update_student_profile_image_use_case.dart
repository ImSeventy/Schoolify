import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/profile/domain/repository/profile_repository.dart';

class UpdateStudentProfileImageUseCase
    extends UseCase<String, UpdateStudentProfileImageParams> {
  final ProfileRepository profileRepository;

  UpdateStudentProfileImageUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, String>> call(
      UpdateStudentProfileImageParams params) async {
    final response = await profileRepository.updateStudentProfileImage(
      image: params.image,
    );

    response.fold(
      (_) => null,
      (imageUrl) {
        if (AuthInfo.currentStudent == null) return;
        AuthInfo.currentStudent = AuthInfo.currentStudent!.copyWith(
          imageUrl: imageUrl,
        );
      },
    );

    return response;
  }
}

class UpdateStudentProfileImageParams {
  final File image;

  UpdateStudentProfileImageParams({required this.image});
}
