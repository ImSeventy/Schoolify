import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/widgets/loading_indicator.dart';
import 'package:frontend/dependency_container.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';
import 'package:frontend/features/certifications/presentation/bloc/certifications_cubit/certifications_cubit.dart';
import 'package:frontend/features/certifications/presentation/bloc/certifications_cubit/certifications_states.dart';
import 'package:frontend/features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'package:frontend/features/warnings/presentation/bloc/warnings_cubit/warnings_states.dart';

import '../../../../core/auth_info/auth_info.dart';
import '../../../../core/constants/error_messages.dart';
import '../../../../core/use_cases/use_case.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/common_page_wrapper.dart';
import '../../../../core/widgets/previous_page_button.dart';
import '../../../../router/routes.dart';
import '../../../authentication/domain/use_cases/logout_use_case.dart';
import '../../../grades/presentation/widgets/data_options_list_widget.dart';
import '../widgets/certification_widget.dart';

class CertificationsPage extends StatelessWidget {
  const CertificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        CertificationsCubit certificationsCubit = getIt<CertificationsCubit>();
        certificationsCubit.getStudentCertifications();
        return certificationsCubit;
      },
      child: BlocConsumer<CertificationsCubit, CertificationsState>(
        listenWhen: (oldState, newState) => oldState != newState,
        buildWhen: (oldState, newState) => oldState != newState,
        listener: (context, state) {
          if (state is CertificationsFailedState) {
            showToastMessage(
              state.message,
                Theme.of(context).colorScheme.error,
              context
            );

            if (state.message == ErrorMessages.invalidAccessTokenFailure || state.message == ErrorMessages.invalidRefreshTokenFailure) {
              getIt<LogOutUseCase>().call(NoParams());
              Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (route) => false);
            }
          }
        },
        builder: (context, state) {
          CertificationsCubit certificationsCubit = context.read<CertificationsCubit>();
          DataHandlerCubit dataHandlerCubit = context.watch<DataHandlerCubit>();
          List<CertificationEntity> certifications = dataHandlerCubit.filterCertifications(certificationsCubit.certifications);
          return CommonPageWrapper(
            onRefresh: () async {
              await certificationsCubit.getStudentCertifications();
            },
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  Row(
                    children: [
                      const PreviousPageButton(),
                      const Spacer(),
                      Text(
                        "Certifications",
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 36.sp,
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                      )
                    ],
                  ),
                  SizedBox(height: 75.h,),
                  DataOptionsListWidget.yearOptions(
                    onChanged: (yearMode) {
                      if (yearMode == null) return;
                      dataHandlerCubit.changeYearMode(yearMode);
                    },
                    studentGradeYear: AuthInfo.currentStudent!.gradeYear,
                    currentValue: dataHandlerCubit.currentYearMode,
                  ),
                  SizedBox(height: 10.h),
                  DataOptionsListWidget.semesterOptions(
                    onChanged: (semesterMode) {
                      if (semesterMode == null) return;
                      dataHandlerCubit.changeSemesterMode(semesterMode);
                    },
                    currentValue: dataHandlerCubit.currentSemesterMode,
                  ),
                  SizedBox(height: 21.h,),
                  state is GetStudentWarningsLoadingState
                      ? const Center(child: LoadingIndicator())
                      : Column(
                    children: certifications.map((certification) => CertificationWidget(certificationEntity: certification,)).toList(),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
