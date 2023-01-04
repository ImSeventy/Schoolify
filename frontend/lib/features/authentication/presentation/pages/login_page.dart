import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/constants/fonts.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/core/utils/rfid_stream_handler.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_states.dart';
import 'package:frontend/features/authentication/presentation/pages/rfid_login_page.dart';
import 'package:frontend/features/authentication/presentation/widgets/icons_group_widget.dart';
import 'package:frontend/router/routes.dart';

import '../../../../core/constants/images_paths.dart';
import '../../../../core/utils/utils.dart';
import '../../../../dependency_container.dart';
import '../widgets/credentials_field.dart';
import '../widgets/submit_button.dart';

// String? currentRfid;

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;
  StreamSubscription? rfidStreamSub;
  String? currentRfid;

  @override
  void initState() {
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    rfidStreamSub?.cancel();
    super.dispose();
  }

  void login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      LoginCubit loginCubit = context.read<LoginCubit>();

      loginCubit.login(
        email: _emailTextEditingController.text,
        password: _passwordTextEditingController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return getIt<LoginCubit>();
      },
      child: BlocConsumer<LoginCubit, LoginState>(
        buildWhen: (oldState, newState) => oldState != newState,
        listenWhen: (oldState, newState) => oldState != newState,
        listener: (context, newState) async {
          if (newState is LoginFailedState) {
            showToastMessage(newState.message, Colors.red, context);
          } else if (newState is GetStudentByRfidFailedState) {
            currentRfid = null;
            showToastMessage(newState.message, Colors.red, context);
          } else if (newState is LoginSucceededState) {
            showToastMessage("Logged in successfully", Colors.green, context);
            setCubitsData(context);
            context.pushNamedAndRemove(Routes.home);
          } else if (newState is GetStudentByRfidSucceededState) {
            currentRfid = null;
            await context.pushNamed(Routes.rfidLogin,
                arguments: RfidLoginPageArgs(student: newState.student));
          }
        },
        builder: (context, state) {
          LoginCubit loginCubit = context.read<LoginCubit>();
          rfidStreamSub = RfidStreamHandler.getRfIdStream().listen((rfid) async {
            if (currentRfid != null) return;
            currentRfid = rfid;
            loginCubit.getStudentByRfid(rfid: int.parse(rfid));
          });
          return SafeArea(
            child: Stack(
              children: [
                Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0F5E75),
                        Color(0xFF12839C),
                        Color(0xFF0F5E75),
                      ],
                    ))),
                Row(
                  children: [
                    const Spacer(),
                    SvgPicture.asset(
                      ImagesPaths.logo,
                      width: 102.w,
                      height: 89.h,
                      alignment: Alignment.topRight,
                    ),
                    SizedBox(
                      height: 19.8.w,
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const IconsGroupWidget(
                      flex: 10,
                      imagePath: ImagesPaths.firstLoginIcons,
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(
                      height: 230.h,
                    ),
                    const IconsGroupWidget(
                      flex: 9,
                      imagePath: ImagesPaths.secondLoginIcons,
                      alignment: Alignment.bottomRight,
                    ),
                  ],
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 310.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 69.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "login ",
                                      style: context.theme.textTheme.subtitle1?.copyWith(
                                        fontFamily: Fonts.secondaryFont,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFA2FF81)
                                      ),
                                      children: const [
                                        TextSpan(
                                            text: "here",
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF)))
                                      ]),
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                CredentialsField(
                                  hintText: "Enter your E-mail",
                                  isPassword: false,
                                  textEditingController:
                                      _emailTextEditingController,
                                  validator: emailValidator,
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                CredentialsField(
                                  hintText: "Enter your password",
                                  isPassword: true,
                                  textEditingController:
                                      _passwordTextEditingController,
                                  validator: passwordValidator,
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                LoginSubmitButton(
                                  onPressed: () => login(context),
                                  enabled: state is! LoginLoadingState,
                                  colors: const [
                                    Color(0xFF00E9CD),
                                    Color(0xFFF478FF),
                                  ],
                                ),
                                SizedBox(
                                  height: 11.h,
                                ),
                              ],
                            ),
                          ),
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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
