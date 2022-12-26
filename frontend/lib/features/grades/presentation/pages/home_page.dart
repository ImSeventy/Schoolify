import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/constants/error_messages.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/core/widgets/loading_indicator.dart';
import 'package:frontend/core/widgets/refresh_page_handler.dart';
import 'package:frontend/dependency_container.dart';
import 'package:frontend/features/attendance/presentation/bloc/attendance_cubit/attendance_cubit.dart';
import 'package:frontend/features/attendance/presentation/pages/attendance_page.dart';
import 'package:frontend/features/authentication/domain/use_cases/logout_use_case.dart';
import 'package:frontend/features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'package:frontend/features/grades/presentation/bloc/grades/grades_cubit_states.dart';
import 'package:frontend/features/posts/presentation/pages/posts_page.dart';
import 'package:frontend/features/profile/presentation/pages/profile_page.dart';
import 'package:frontend/router/routes.dart';

import '../../../../core/constants/images_paths.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/avatar_image.dart';
import '../bloc/grades/grades_cubit.dart';
import '../widgets/data_options_list_widget.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/sub_page_nav_item.dart';
import 'grades_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  void changePageIndex(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      MainHomePage(),
      AttendancePage(),
      GradesPage(),
      PostsPage()
    ];

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:
            CustomNavigationBar(onTap: changePageIndex, initialIndex: 0),
        body: Stack(
          children: [
            Transform.translate(
              offset: const Offset(-10, 0),
              child: SvgPicture.asset(
                ImagesPaths.firstLoginIcons,
                color: context.colorScheme.onSurface,
                width: 170,
              ),
            ),
            IndexedStack(
              index: pageIndex,
              children: pages,
            ),
          ],
        ),
      ),
    );
  }
}

class MainHomePage extends StatelessWidget {
  const MainHomePage({Key? key}) : super(key: key);

  void changeSemesterMode(BuildContext context, String? semesterMode) {
    if (semesterMode == null) return;
    DataHandlerCubit dataHandlerCubit = context.read<DataHandlerCubit>();
    dataHandlerCubit.changeSemesterMode(semesterMode);
  }

  void changeYearMode(BuildContext context, String? yearMode) {
    if (yearMode == null) return;
    DataHandlerCubit dataHandlerCubit = context.read<DataHandlerCubit>();
    dataHandlerCubit.changeYearMode(yearMode);
  }

  double calculateSuperiorityPercentage(BuildContext context) {
    DataHandlerCubit dataHandlerCubit = context.read<DataHandlerCubit>();
    GradesCubit gradesCubit = context.read<GradesCubit>();
    AttendanceCubit attendanceCubit = context.read<AttendanceCubit>();

    double gradesPercentage =
        dataHandlerCubit.calculateGradesPercentage(gradesCubit.grades);
    double attendancePercentage = dataHandlerCubit
        .calculateAttendancePercentage(attendanceCubit.absences);

    return (gradesPercentage * 75 / 100) + (attendancePercentage * 25 / 100);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GradesCubit, GradesState>(
      buildWhen: (oldState, newState) => oldState != newState,
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is GradesFailedState) {
          showToastMessage(state.message, context.colorScheme.error, context);

          if (state.message == ErrorMessages.invalidAccessTokenFailure ||
              state.message == ErrorMessages.invalidRefreshTokenFailure) {
            getIt<LogOutUseCase>().call(NoParams());
            context.pushNamedAndRemove(Routes.login);
          }
        }
      },
      builder: (context, state) {
        DataHandlerCubit dataHandlerCubit = context.watch<DataHandlerCubit>();
        AttendanceCubit attendanceCubit = context.read<AttendanceCubit>();
        GradesCubit gradesCubit = context.read<GradesCubit>();

        return RefreshPageHandler(
          onRefresh: () async {
            await gradesCubit.getStudentGrades();
            await attendanceCubit.getStudentAbsences();
          },
          child: state is GetStudentGradesLoadingState
              ? const LoadingIndicator()
              : SingleChildScrollView(
                  clipBehavior: Clip.none,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 170.w,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    Routes.profile,
                                    arguments: ProfilePageArgs(
                                      student: AuthInfo.currentStudent!,
                                    ),
                                  );
                                },
                                child: AvatarImage(
                                  imageUrl: AuthInfo.currentStudent!.imageUrl,
                                  width: 70.w,
                                  height: 70.h,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 9.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 29.h,
                                ),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: "Welcome!\n",
                                      style: context.theme.textTheme.headline3,
                                      children: [
                                        TextSpan(
                                            text: AuthInfo.currentStudent!.name,
                                            style: TextStyle(
                                                color: context.colorScheme.onBackground,))
                                      ]),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "ST Page",
                                style: context.theme.textTheme.bodyText2,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.settings,
                                  size: 28.sp,
                                  color: context.colorScheme.onBackground,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10.w,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      DataOptionsListWidget.yearOptions(
                          onChanged: (yearMode) {
                            changeYearMode(context, yearMode);
                          },
                          studentGradeYear: AuthInfo.currentStudent!.gradeYear,
                          currentValue: dataHandlerCubit.currentYearMode),
                      SizedBox(height: 10.h),
                      DataOptionsListWidget.semesterOptions(
                        onChanged: (semesterMode) {
                          changeSemesterMode(context, semesterMode);
                        },
                        currentValue: dataHandlerCubit.currentSemesterMode,
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Stack(
                          children: [
                            Transform.translate(
                              offset: Offset(-5.w, 0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: FancyProgressIndicator(
                                  percentage: dataHandlerCubit
                                      .calculateGradesPercentage(
                                          gradesCubit.grades),
                                  backgroundColor: context.colorScheme.outline,
                                  name: "Grades",
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, 130.h),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: FancyProgressIndicator(
                                  percentage: dataHandlerCubit
                                      .calculateAttendancePercentage(
                                          attendanceCubit.absences),
                                  backgroundColor: context.colorScheme.outline,
                                  name: "Attendance",
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, 290.h),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: FancyProgressIndicator(
                                  percentage:
                                      calculateSuperiorityPercentage(context),
                                  backgroundColor: context.colorScheme.outline,
                                  name: "Superiority",
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 420.h,
                                ),
                                SubPageNavItem(
                                  label: "Warnings",
                                  iconColor: context.colorScheme.error,
                                  iconPath: ImagesPaths.pin,
                                  onTap: () {
                                    context.pushNamed(Routes.warnings);
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SubPageNavItem(
                                  label: "Certifications",
                                  iconColor: Colors.green,
                                  iconPath: ImagesPaths.pin,
                                  onTap: () {
                                    context.pushNamed(Routes.certifications);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
