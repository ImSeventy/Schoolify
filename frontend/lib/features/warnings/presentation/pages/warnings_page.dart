import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/core/widgets/loading_indicator.dart';
import 'package:frontend/dependency_container.dart';
import 'package:frontend/features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'package:frontend/features/warnings/domain/entities/warning_entity.dart';
import 'package:frontend/features/warnings/presentation/bloc/warnings_cubit/warnings_cubit.dart';
import 'package:frontend/features/warnings/presentation/bloc/warnings_cubit/warnings_states.dart';

import '../../../../core/auth_info/auth_info.dart';
import '../../../grades/presentation/widgets/data_options_list_widget.dart';
import '../widgets/warning_widget.dart';

class WarningsPage extends StatelessWidget {
  const WarningsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        WarningsCubit warningsCubit = getIt<WarningsCubit>();
        warningsCubit.loadStudentWarnings();
        return warningsCubit;
      },
      child: BlocConsumer<WarningsCubit, WarningsState>(
        listenWhen: (oldState, newState) => oldState != newState,
        buildWhen: (oldState, newState) => oldState != newState,
        listener: (context, state) {},
        builder: (context, state) {
          WarningsCubit warningsCubit = context.read<WarningsCubit>();
          DataHandlerCubit dataHandlerCubit = context.watch<DataHandlerCubit>();
          List<WarningEntity> warnings = dataHandlerCubit.filterWarnings(warningsCubit.warnings);
          return RefreshIndicator(
            onRefresh: () async {
              await warningsCubit.loadStudentWarnings();
            },
            color: const Color(0xFF131524),
            backgroundColor: const Color(0xFF2d407b),
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
                SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SingleChildScrollView(
                      clipBehavior: Clip.none,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_sharp,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "Warnings",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    fontSize: 36.sp,
                                    color: Colors.white
                                ),
                              ),
                              SizedBox(
                                width: 50.w,
                              )
                            ],
                          ),
                          SizedBox(height: 75.h,),
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
                          SizedBox(height: 21.h,),
                          state is GetStudentWarningsLoadingState
                          ? const Center(child: LoadingIndicator())
                          : Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: "Number of warnings  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        fontSize: 24.sp
                                    ),
                                    children: [
                                      TextSpan(
                                          text: warnings.length.toString(),
                                          style: const TextStyle(
                                              color: const Color(0xFFE23939)
                                          )
                                      )
                                    ]
                                ),
                              ),
                              SizedBox(height: 21.h),
                              ...warnings.map((warning) => WarningWidget(warningEntity: warning,)).toList()
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
