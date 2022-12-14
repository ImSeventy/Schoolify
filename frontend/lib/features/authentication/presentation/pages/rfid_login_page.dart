import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/features/authentication/domain/entities/sutdent_rfid_entity.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_states.dart';
import 'package:frontend/features/authentication/presentation/widgets/credentials_field.dart';
import 'package:frontend/features/authentication/presentation/widgets/submit_button.dart';

import '../../../../core/utils/utils.dart';
import '../../../../router/routes.dart';

class RfidLoginPageArgs {
  final StudentRfidEntity student;

  RfidLoginPageArgs({required this.student});
}

class RfidLoginPage extends StatefulWidget {
  final StudentRfidEntity student;
  const RfidLoginPage({Key? key, required this.student}) : super(key: key);

  @override
  State<RfidLoginPage> createState() => _RfidLoginPageState();
}

class _RfidLoginPageState extends State<RfidLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;

  @override
  void initState() {
    _emailTextEditingController = TextEditingController();
    _emailTextEditingController.text = widget.student.email;
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
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (oldState, newState) => newState != oldState,
      buildWhen: (oldState, newState) => newState != oldState,
      listener: (context, state) {
        if (state is LoginFailedState) {
          showToastMessage(state.message, Colors.red, context);
        } else if (state is LoginSucceededState) {
          showToastMessage("Logged in successfully", Colors.green, context);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.home, (route) => false);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              color: const Color(0xFF131524),
            ),
            SizedBox(
              width: 555.w,
              height: 1002.h,
              child: SvgPicture.asset(
                "assets/rf_id_background.svg",
                width: 555.w,
                height: 1002.h,
                fit: BoxFit.fill,
              ),
            ),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Center(
                        child: SizedBox(
                          width: 300.w,
                          child: Text(
                            "Welcome ${widget.student.name} !",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                fontSize: 30.sp,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 156.w,
                        height: 161.h,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFFCCC1F0),
                          foregroundImage: widget.student.imageUrl == null || widget.student.imageUrl == ""
                              ? Image.asset("assets/default_profile.png").image
                              : CachedNetworkImageProvider(
                                  widget.student.imageUrl!,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 83.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45.sp,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 210.w,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      CredentialsField(
                        isPassword: false,
                        hintText: "",
                        textEditingController: _emailTextEditingController,
                        enabled: false,
                        validator: passwordValidator,
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      CredentialsField(
                        isPassword: true,
                        hintText: "Enter your password",
                        textEditingController: _passwordTextEditingController,
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      LoginSubmitButton(
                        enabled: state is! LoginLoadingState,
                        onPressed: () => login(context),
                        colors: const [Color(0xFF0064D9), Color(0xFF0017E9)],
                      )
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ],
        );
      },
    );
  }
}