import 'package:bloc/bloc.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';
import 'package:frontend/features/certifications/presentation/bloc/certifications_cubit/certifications_states.dart';

import '../../../../../core/use_cases/use_case.dart';
import '../../../domain/use_cases/get_student_certifications.dart';

class CertificationsCubit extends Cubit<CertificationsState> {
  final GetStudentCertificationsUseCase getStudentCertificationsUseCase;

  CertificationsCubit({required this.getStudentCertificationsUseCase}) : super(CertificationsInitialState());

  List<CertificationEntity> certifications = [];

  Future<void> getStudentCertifications() async {
    emit(GetStudentCertificationsLoadingState());
    final response = await getStudentCertificationsUseCase.call(NoParams());
    response.fold(
      (failure) => emit(GetStudentCertificationsFailedState(msg: failure.message)),
      (certifications) {
        this.certifications = certifications;
        emit(GetStudentCertificationsSucceededState());
      }
    );
  }
}