import 'package:dartz/dartz.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';

import '../../../../core/errors/failures.dart';

abstract class CertificationsRepository {
  Future<Either<Failure, List<CertificationEntity>>> getStudentCertifications();
}