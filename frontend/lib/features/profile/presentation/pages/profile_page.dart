import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/core/widgets/avatar_image.dart';
import 'package:frontend/core/widgets/previous_page_button.dart';
import 'package:frontend/features/authentication/domain/entities/student_entity.dart';
import 'package:frontend/features/grades/presentation/bloc/grades/grades_cubit.dart';
import 'package:frontend/features/profile/presentation/bloc/profile_cubit/profile_cubit.dart';
import 'package:frontend/features/profile/presentation/bloc/profile_cubit/profile_states.dart';
import 'package:frontend/features/profile/presentation/widgets/logout_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/common_page_wrapper.dart';
import '../widgets/profile_data_field.dart';
import '../widgets/save_button.dart';

class ProfilePageArgs {
  final StudentEntity student;

  ProfilePageArgs({required this.student});
}

class ProfilePage extends StatefulWidget {
  final StudentEntity student;

  const ProfilePage({Key? key, required this.student}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _imagePicker = ImagePicker();
  bool editingPassword = false;
  bool editingEmail = false;
  File? newProfileImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameTextEditingController;
  late TextEditingController _emailTextEditingController;
  late TextEditingController _gradeYearTextEditingController;
  late TextEditingController _departmentTextEditingController;
  late TextEditingController _passwordTextEditingController;
  late TextEditingController _currentPasswordTextEditingController;
  late TextEditingController _newPasswordTextEditingController;

  @override
  void initState() {
    _nameTextEditingController =
        TextEditingController(text: widget.student.name);
    _emailTextEditingController =
        TextEditingController(text: widget.student.email);
    _gradeYearTextEditingController =
        TextEditingController(text: "Grade ${widget.student.gradeYear}");
    _departmentTextEditingController =
        TextEditingController(text: widget.student.majorName);
    _passwordTextEditingController =
        TextEditingController(text: "*********************");
    _newPasswordTextEditingController = TextEditingController();
    _currentPasswordTextEditingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _gradeYearTextEditingController.dispose();
    _departmentTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _newPasswordTextEditingController.dispose();
    _currentPasswordTextEditingController.dispose();

    super.dispose();
  }

  void saveProfileData(BuildContext context) async {
    ProfileCubit profileCubit = context.read<ProfileCubit>();
    if (newProfileImage != null) {
      GradesCubit gradesCubit = context.read<GradesCubit>();
      await profileCubit.updateStudentProfileImage(image: newProfileImage!);
      gradesCubit.refresh();
    }
    if (!editingPassword && !editingEmail) return;
    if (!_formKey.currentState!.validate()) return;

    if (editingEmail) {
      await profileCubit.updateStudent(email: _emailTextEditingController.text);
    }

    if (editingPassword) {
      await profileCubit.updateStudentPassword(
        currentPassword: _currentPasswordTextEditingController.text,
        newPassword: _newPasswordTextEditingController.text,
      );
    }
  }

  Future<CroppedFile?> cropImageForMobile(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      maxHeight: 200,
      maxWidth: 200,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      cropStyle: CropStyle.circle,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Crop your image",
            toolbarColor: context.colorScheme.onSurface,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            toolbarWidgetColor: context.colorScheme.onBackground,
            activeControlsWidgetColor: context.colorScheme.tertiary,
            initAspectRatio: CropAspectRatioPreset.square,
            showCropGrid: false,
            lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: "Crop your image",
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    return croppedFile;
  }

  void chooseImageForWindows() async {
    final filePicker = OpenFilePicker()
      ..filterSpecification = {
        'Image (*.jpg, *.png, *.jpeg)': '*.jpg; *.png; *.jpeg',
      }
      ..defaultFilterIndex = 0
      ..title = 'Select an image';

    final image = filePicker.getFile();
    if (image == null) return;

    setState(() {
      newProfileImage = File(image.path);
    });
  }

  void chooseImageForMobile(ImageSource source) async {
    XFile? image = await _imagePicker.pickImage(source: source);

    if (image == null) return;

    CroppedFile? croppedFile = await cropImageForMobile(image.path);

    if (croppedFile == null) return;

    setState(() {
      newProfileImage = File(croppedFile.path);
    });
  }

  void showChooseImageDialog(BuildContext context) {
    if (Platform.isWindows) {
      chooseImageForWindows();
      return;
    }

    showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: context.theme.scaffoldBackgroundColor,
            children: [
              SimpleDialogOption(
                child: Text(
                  "Gallery",
                  style: context.theme.textTheme.subtitle2,
                ),
                onPressed: () {
                  context.navigator.pop();
                  chooseImageForMobile(ImageSource.gallery);
                },
              ),
              const Divider(
                color: Colors.black,
                thickness: 2,
              ),
              SimpleDialogOption(
                  child: Text(
                    "Camera",
                    style: context.theme.textTheme.subtitle2,
                  ),
                  onPressed: () {
                    context.navigator.pop();
                    chooseImageForMobile(ImageSource.camera);
                  }),
              const Divider(
                color: Colors.black,
                thickness: 2,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: context.theme.textTheme.subtitle2?.copyWith(
                    color: Colors.red
                  ),
                ),
                onPressed: () {
                  context.navigator.pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      buildWhen: (oldState, newState) => oldState != newState,
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is ProfileFailedState) {
          showToastMessage(
            state.message,
            context.colorScheme.error,
            context,
          );
        }

        if (state is UpdateStudentPasswordSucceededState) {
          editingPassword = false;
        }

        if (state is UpdateStudentProfileSucceededState) {
          editingEmail = false;
        }

        if (state is UpdateStudentProfileFailedState) {
          _emailTextEditingController.text = widget.student.email;
        }

        if (state is UpdateStudentProfileImageFailedState) {
          newProfileImage = null;
        }
      },
      builder: (context, state) {
        return CommonPageWrapper(
          onRefresh: () async {},
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  Row(
                    children: [
                      const PreviousPageButton(),
                      const Spacer(),
                      Text(
                        "Profile Page",
                        style: context.theme.textTheme.headline1?.copyWith(
                          fontSize: 36.sp,
                        ),
                      ),
                      const Spacer(),
                      const LogOutButton(),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      AvatarImage(
                        imageUrl: widget.student.imageUrl,
                        width: 110.w,
                        height: 110.w,
                        image: newProfileImage,
                      ),
                      GestureDetector(
                        onTap: () => showChooseImageDialog(context),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: context.theme.scaffoldBackgroundColor,
                                  width: 3,
                                  strokeAlign: StrokeAlign.outside),
                              color: context.colorScheme.tertiary),
                          child: Icon(
                            Icons.edit,
                            color: context.colorScheme.onTertiary,
                            size: 25.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ProfileDataField(
                    fieldName: 'Name',
                    isPassword: false,
                    textEditingController: _nameTextEditingController,
                    enabled: false,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  ProfileDataField(
                    fieldName: 'E-mail',
                    isPassword: false,
                    textEditingController: _emailTextEditingController,
                    enabled: editingEmail,
                    editable: !editingEmail,
                    validator: emailValidator,
                    editCallback: () {
                      setState(() {
                        editingEmail = true;
                      });
                    },
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  ProfileDataField(
                    fieldName: 'Grade Year',
                    isPassword: false,
                    textEditingController:
                    _gradeYearTextEditingController,
                    enabled: false,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  ProfileDataField(
                    fieldName: 'Department',
                    isPassword: false,
                    textEditingController:
                    _departmentTextEditingController,
                    enabled: false,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  editingPassword
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 145.w,
                        child: ProfileDataField(
                          fieldName: 'Current',
                          isPassword: true,
                          textEditingController:
                          _currentPasswordTextEditingController,
                          enabled: true,
                        ),
                      ),
                      SizedBox(
                        width: 21.w,
                      ),
                      SizedBox(
                        width: 145.w,
                        child: ProfileDataField(
                          fieldName: 'New',
                          isPassword: true,
                          validator: passwordValidator,
                          textEditingController:
                          _newPasswordTextEditingController,
                          enabled: true,
                        ),
                      )
                    ],
                  )
                      : ProfileDataField(
                    fieldName: 'Password',
                    isPassword: true,
                    textEditingController:
                    _passwordTextEditingController,
                    enabled: false,
                    editable: true,
                    editCallback: () {
                      setState(() {
                        editingPassword = true;
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SaveButton(
                      onPressed: () => saveProfileData(context),
                      enabled: state is! ProfileLoadingState)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
