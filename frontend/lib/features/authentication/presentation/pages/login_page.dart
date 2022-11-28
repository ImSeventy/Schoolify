import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_states.dart';
import 'package:frontend/features/authentication/presentation/widgets/icons_group_widget.dart';
import 'package:frontend/router/routes.dart';
import 'package:toast/toast.dart';

import '../../../../dependency_container.dart';
import '../widgets/credentials_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;

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
        ToastContext().init(context);
        return getIt<LoginCubit>();
      },
      child: BlocConsumer<LoginCubit, LoginState>(
        buildWhen: (oldState, newState) => oldState != newState,
        listenWhen: (oldState, newState) => oldState != newState,
        listener: (oldState, newState) async {
          if (newState is LoginFailedState) {
            Toast.show(
              newState.message,
              duration: 3,
              backgroundColor: Colors.red
            );
          }

          if (newState is LoginSucceededState) {
            Toast.show(
              "Logged in successfully",
              duration: 3,
              backgroundColor: Colors.green
            );

            Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => false);
          }
        },
        builder: (context, state) {
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
                      "assets/logo.svg",
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
                      imagePath: "assets/login_icons_1.svg",
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(
                      height: 230.h,
                    ),
                    const IconsGroupWidget(
                      flex: 9,
                      imagePath: "assets/login_icons_2.svg",
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
                                      style: TextStyle(
                                          fontFamily: "Overpass",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 24.sp,
                                          color: const Color(0xFFA2FF81)),
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
                                Container(
                                  width: 310.w,
                                  height: 70.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xFF00E9CD),
                                        Color(0xFFF478FF),
                                      ])),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.transparent),
                                    onPressed: () => state is LoginLoadingState ? null : login(context),
                                    child: state is LoginLoadingState ? const FittedBox(child: CircularProgressIndicator(color: Colors.black,)) : Text(
                                      "login",
                                      style: TextStyle(
                                          fontFamily: "Overpass",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 35.sp,
                                          color: Colors.black),
                                    ),
                                  ),
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
