import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/auth_info/auth_info.dart';
import 'package:frontend/core/widgets/loading_indicator.dart';
import 'package:frontend/dependency_container.dart';
import 'package:frontend/features/attendance/presentation/bloc/attendance_cubit/attendance_cubit.dart';
import 'package:frontend/features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'package:frontend/features/grades/presentation/bloc/grades/grades_cubit_states.dart';

import '../bloc/grades/grades_cubit.dart';
import '../widgets/data_options_list_widget.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/sub_page_nav_item.dart';

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
    const List<Widget> pages = [
      Placeholder(),
      MainHomePage(),
      Placeholder(),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider<GradesCubit>(create: (_) {
          GradesCubit gradesCubit = getIt<GradesCubit>();
          gradesCubit.getStudentGrades();
          return gradesCubit;
        }),
        BlocProvider<AttendanceCubit>(create: (_) {
          AttendanceCubit attendanceCubit = getIt<AttendanceCubit>();
          attendanceCubit.getStudentAbsences();
          return attendanceCubit;
        }),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF131524),
          bottomNavigationBar: CustomNavigationBar(onTap: changePageIndex),
          body: IndexedStack(
            index: pageIndex,
            children: pages,
          ),
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

    double gradesPercentage = dataHandlerCubit.calculateGradesPercentage(gradesCubit.grades);
    double attendancePercentage = dataHandlerCubit.calculateAttendancePercentage(attendanceCubit.absences);

    return (gradesPercentage * 75 / 100) + (attendancePercentage * 25 / 100);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataHandlerCubit>(
      create: (_) {
        DataHandlerCubit dataHandlerCubit = getIt<DataHandlerCubit>();
        return dataHandlerCubit;
      },
      child: BlocConsumer<GradesCubit, GradesState>(
        buildWhen: (oldState, newState) => oldState != newState,
        listenWhen: (oldState, newState) => oldState != newState,
        listener: (context, state) {},
        builder: (context, state) {
          DataHandlerCubit dataHandlerCubit = context.watch<DataHandlerCubit>();
          AttendanceCubit attendanceCubit = context.read<AttendanceCubit>();
          GradesCubit gradesCubit = context.read<GradesCubit>();

          return RefreshIndicator(
            onRefresh: () async {
              await gradesCubit.getStudentGrades();
              await attendanceCubit.getStudentAbsences();
            },
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFF131524),
                ),
                Transform.translate(
                  offset: const Offset(-10, 0),
                  child: SvgPicture.asset(
                    "assets/login_icons_1.svg",
                    color: const Color(0xFF2d407b),
                    width: 170,
                  ),
                ),
                state is GetStudentGradesLoadingState
                    ? const LoadingIndicator()
                    : SingleChildScrollView(
                  clipBehavior: Clip.none,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                              CircleAvatar(
                                radius: 40.r,
                                backgroundColor: const Color(0xFFCCC1F0),
                                child: const Icon(Icons.person),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 9.w,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 29.h,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Welcome!\n",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 16.sp,
                                        color: Colors.white.withOpacity(0.8)),
                                    children: const [
                                      TextSpan(
                                          text: "Ahmed",
                                          style: TextStyle(color: Colors.white))
                                    ]),
                              )
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                "ST Page",
                                style: TextStyle(
                                    color: const Color(0xFFCCC1F0),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              Icon(
                                Icons.settings,
                                size: 28.sp,
                                color: Colors.white,
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
                      DataOptionsListWidget(
                        onChanged: (yearMode) {
                          changeYearMode(context, yearMode);
                        },
                        optionValues: [
                          "All Years",
                          "This Year",
                          "Last Year", ...List.generate(AuthInfo.currentStudent!.gradeYear, (index) => "Grade ${index + 1}")
                        ],
                        prefixMsg: "",
                        currentValue: dataHandlerCubit.currentYearMode
                      ),
                      SizedBox(height: 10.h),
                      DataOptionsListWidget(
                        onChanged: (semesterMode) {
                          changeSemesterMode(context, semesterMode);
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
                                  percentage: dataHandlerCubit.calculateGradesPercentage(gradesCubit.grades),
                                  backgroundColor: const Color(0xFF306767),
                                  name: "Grades",
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, 130.h),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: FancyProgressIndicator(
                                  percentage: dataHandlerCubit.calculateAttendancePercentage(attendanceCubit.absences),
                                  backgroundColor: const Color(0xFF306767),
                                  name: "Attendance",
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, 290.h),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: FancyProgressIndicator(
                                  percentage: calculateSuperiorityPercentage(context),
                                  backgroundColor: const Color(0xFF306767),
                                  name: "Superiority",
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, 420.h),
                              child: Column(
                                children: [
                                  SubPageNavItem(
                                    label: "Warnings",
                                    iconColor: Colors.red,
                                    iconPath: "assets/pin.svg",
                                    onTap: () {},
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  SubPageNavItem(
                                    label: "Certifications",
                                    iconColor: Colors.green,
                                    iconPath: "assets/pin.svg",
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
