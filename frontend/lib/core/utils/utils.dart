import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/attendance/presentation/bloc/attendance_cubit/attendance_cubit.dart';
import 'package:frontend/features/grades/presentation/bloc/grades/grades_cubit.dart';
import 'package:toast/toast.dart';

void showToastMessage(String message, Color color, BuildContext context) {
  ToastContext().init(context);
  Toast.show(message, duration: 3, backgroundColor: color);
}

Future<void> setCubitsData(BuildContext context) async {
  GradesCubit gradesCubit = context.read<GradesCubit>();
  AttendanceCubit attendanceCubit = context.read<AttendanceCubit>();

  await gradesCubit.getStudentGrades();
  await attendanceCubit.getStudentAbsences();
}