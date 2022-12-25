import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataOptionsListWidget extends StatefulWidget {
  final List<String> optionValues;
  final void Function(String?) onChanged;
  final String prefixMsg;
  final String currentValue;
  const DataOptionsListWidget({
    Key? key,
    required this.optionValues,
    required this.onChanged,
    required this.prefixMsg,
    required this.currentValue,
  }) : super(key: key);

  @override
  State<DataOptionsListWidget> createState() => _DataOptionsListWidgetState();
}

class _DataOptionsListWidgetState extends State<DataOptionsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 250.w),
      width: 220.w,
      height: 32.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: widget.currentValue,
          items: widget.optionValues
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                  ),
                ),
              )
              .toList(),
          onChanged: widget.onChanged,
          icon:
              const Icon(Icons.arrow_drop_down_sharp, color: Color(0xFF9C8D8D)),
          style: Theme.of(context).textTheme.headline4,
          dropdownDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.secondaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          offset: const Offset(0, -5),
          dropdownMaxHeight: 250.h,
        ),
      ),
    );
  }
}
