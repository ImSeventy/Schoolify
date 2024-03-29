import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/core/widgets/refresh_page_handler.dart';
import 'package:frontend/features/attendance/domain/entities/absence_entity.dart';
import 'package:frontend/features/attendance/presentation/bloc/attendance_cubit/attendance_cubit.dart';
import 'package:frontend/features/attendance/presentation/bloc/attendance_cubit/attendance_states.dart';

import '../../../../core/auth_info/auth_info.dart';
import '../../../../core/constants/error_messages.dart';
import '../../../../core/use_cases/use_case.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../dependency_container.dart';
import '../../../../router/routes.dart';
import '../../../authentication/domain/use_cases/logout_use_case.dart';
import '../../../grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import '../../../grades/presentation/widgets/data_options_list_widget.dart';
import '../../../grades/presentation/widgets/progress_indicator.dart';
import '../widgets/absence_widget.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendanceCubit, AttendanceState>(
      listenWhen: (oldState, newState) => oldState != newState,
      buildWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is GetStudentAbsencesFailedState) {
          showToastMessage(
            state.message,
              context.colorScheme.error,
            context
          );

          if (state.message == ErrorMessages.invalidAccessTokenFailure || state.message == ErrorMessages.invalidRefreshTokenFailure) {
            getIt<LogOutUseCase>().call(NoParams());
            context.pushNamedAndRemove(Routes.login);
          }
        }
      },
      builder: (context, state) {
        AttendanceCubit attendanceCubit = context.read<AttendanceCubit>();
        DataHandlerCubit dataHandlerCubit = context.watch<DataHandlerCubit>();
        List<AbsenceEntity> absences =
            dataHandlerCubit.filterAbsences(attendanceCubit.absences);
        return RefreshPageHandler(
          onRefresh: () async {
            await attendanceCubit.getStudentAbsences();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  SizedBox(
                    height: 75.h,
                  ),
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
                  SizedBox(
                    height: 49.h,
                  ),
                  state is GetStudentAbsencesLoadingState
                      ? const Center(child: LoadingIndicator())
                      : Column(
                          children: [
                            FancyProgressIndicator(
                              percentage: dataHandlerCubit
                                  .calculateAttendancePercentage(
                                      attendanceCubit.absences),
                              backgroundColor: context.colorScheme.outline,
                              name: "Attendance",
                            ),
                            SizedBox(height: 16.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 17.w),
                              child: GridView.builder(
                                itemCount: absences.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  childAspectRatio: 1.34,
                                  mainAxisSpacing: 15.h,
                                  crossAxisSpacing: 6.w,
                                  maxCrossAxisExtent: 126.w,
                                ),
                                itemBuilder: (_, index) {
                                  return AbsenceWidget(
                                    absenceEntity: absences[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
