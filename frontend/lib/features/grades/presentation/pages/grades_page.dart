import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/attendance/presentation/bloc/attendance_cubit/attendance_states.dart';
import 'package:frontend/features/grades/domain/entities/grade.py.dart';
import 'package:frontend/features/grades/presentation/bloc/grades/grades_cubit.dart';
import 'package:frontend/features/grades/presentation/bloc/grades/grades_cubit_states.dart';

import '../../../../core/auth_info/auth_info.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import '../../../grades/presentation/widgets/data_options_list_widget.dart';
import '../../../grades/presentation/widgets/progress_indicator.dart';
import '../widgets/grades_group_widget.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({Key? key}) : super(key: key);

  List<List<GradeEntity>> getGradesGroups(List<GradeEntity> grades) {
    Map<String, List<GradeEntity>> groupedGrades = {};

    for (GradeEntity grade in grades) {
      String groupName = "${grade.gradeYear}-${grade.semester}";
      List<GradeEntity>? group = groupedGrades[groupName];
      if (group == null) {
        groupedGrades[groupName] = [grade];
      }else {
        group.add(grade);
      }
    }

    return groupedGrades.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GradesCubit, GradesState>(
      listenWhen: (oldState, newState) => oldState != newState,
      buildWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {},
      builder: (context, state) {
        GradesCubit gradesCubit = context.read<GradesCubit>();
        DataHandlerCubit dataHandlerCubit = context.watch<DataHandlerCubit>();
        List<GradeEntity> grades =
        dataHandlerCubit.filterGrades(gradesCubit.grades);
        List<List<GradeEntity>> gradesGroups = getGradesGroups(grades);
        return RefreshIndicator(
          onRefresh: () async {
            await gradesCubit.getStudentGrades();
          },
          color: const Color(0xFF131524),
          backgroundColor: const Color(0xFF2d407b),
          child: SafeArea(
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
                    DataOptionsListWidget(
                      onChanged: (yearMode) {
                        if (yearMode == null) return;
                        dataHandlerCubit.changeYearMode(yearMode);
                      },
                      optionValues: [
                        "All Years",
                        "This Year",
                        "Last Year",
                        ...List.generate(AuthInfo.currentStudent!.gradeYear,
                                (index) => "Grade ${index + 1}")
                      ],
                      prefixMsg: "",
                      currentValue: dataHandlerCubit.currentYearMode,
                    ),
                    SizedBox(height: 10.h),
                    DataOptionsListWidget(
                      onChanged: (semesterMode) {
                        if (semesterMode == null) return;
                        dataHandlerCubit.changeSemesterMode(semesterMode);
                      },
                      optionValues: const [
                        "Whole Year",
                        "1st Semester",
                        "2nd Semester"
                      ],
                      prefixMsg: "",
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
                              .calculateGradesPercentage(gradesCubit.grades),
                          backgroundColor: const Color(0xFF306767),
                          name: "Attendance",
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 19.w),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: gradesGroups.length,
                            itemBuilder: (_, index) {
                              return GradesGroupWidget(
                                grades: gradesGroups[index],
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(height: 26.h,),
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
