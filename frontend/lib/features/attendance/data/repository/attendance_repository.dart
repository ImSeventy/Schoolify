import 'package:dartz/dartz.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/errors/exceptions.dart';

import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/network/network_info.dart';
import 'package:frontend/features/attendance/data/data_provider/attendance_data_provider.dart';
import 'package:frontend/features/attendance/data/models/absence_model.dart';

import 'package:frontend/features/attendance/domain/entities/absence_entity.dart';

import '../../domain/repository/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final NetworkInfo networkInfo;
  final AttendanceDataProvider attendanceDataProvider;

  AttendanceRepositoryImpl({required this.networkInfo, required this.attendanceDataProvider});
  @override
  Future<Either<Failure, List<AbsenceEntity>>> getStudentAbsences() async {
    if (!await networkInfo.isConnected()) {
      return Left(NetworkFailure());
    }

    if (AuthInfo.accessTokens == null) {
      return Left(InvalidAccessTokenFailure());
    }

    try {
      List<AbsenceModel> absenceModels = await attendanceDataProvider.getStudentAbsences();
      return Right(absenceModels);
    } on ServerException {
      return Left(ServerFailure());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenFailure());
    }

  }

}