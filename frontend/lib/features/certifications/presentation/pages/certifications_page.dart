import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/core/widgets/loading_indicator.dart';
import 'package:frontend/dependency_container.dart';
import 'package:frontend/features/certifications/domain/entities/certification_entity.dart';
import 'package:frontend/features/certifications/presentation/bloc/certifications_cubit/certifications_cubit.dart';
import 'package:frontend/features/certifications/presentation/bloc/certifications_cubit/certifications_states.dart';
import 'package:frontend/features/grades/presentation/bloc/data_handler/data_handler_cubit.dart';
import 'package:frontend/features/warnings/presentation/bloc/warnings_cubit/warnings_states.dart';
import 'package:toast/toast.dart';

import '../../../../core/auth_info/auth_info.dart';
import '../../../../core/constants/error_messages.dart';
import '../../../../core/constants/images_paths.dart';
import '../../../../core/use_cases/use_case.dart';
import '../../../../core/utils/utils.dart';
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
              Colors.red,
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
          return RefreshIndicator(
            onRefresh: () async {
              await certificationsCubit.getStudentCertifications();
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
                    ImagesPaths.firstLoginIcons,
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
                                "Certifications",
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
                            children: certifications.map((certification) => CertificationWidget(certificationEntity: certification,)).toList(),
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
