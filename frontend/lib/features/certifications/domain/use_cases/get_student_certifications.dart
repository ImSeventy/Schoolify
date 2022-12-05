import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';
import 'package:frontend/features/certifications/domain/repository/certifications_repository.dart';

class GetStudentCertificationsUseCase extends UseCase<List<CertificationEntity>, NoParams> {
  final CertificationsRepository certificationsRepository;

  GetStudentCertificationsUseCase({required this.certificationsRepository});

  @override
  Future<Either<Failure, List<CertificationEntity>>> call(NoParams params) {
    return certificationsRepository.getStudentCertifications();
  }
}