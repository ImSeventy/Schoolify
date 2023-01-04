import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/core/constants/images_paths.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/core/widgets/avatar_image.dart';
import 'package:frontend/features/authentication/domain/entities/sutdent_rfid_entity.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:frontend/features/authentication/presentation/bloc/login_cubit/login_states.dart';
import 'package:frontend/features/authentication/presentation/widgets/credentials_field.dart';
import 'package:frontend/features/authentication/presentation/widgets/submit_button.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/utils/extensions.dart';
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
          setCubitsData(context);
          showToastMessage("Logged in successfully", Colors.green, context);
          context.pushNamedAndRemove(Routes.home);
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
                ImagesPaths.rfidBackground,
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
                    context.navigator.pop();
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
                            style: context.theme.textTheme.headline2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      AvatarImage(
                        imageUrl: widget.student.imageUrl,
                        width: 156.w,
                        height: 161.h,
                      ),
                      SizedBox(
                        height: 83.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: context.theme.textTheme.headline1,
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
