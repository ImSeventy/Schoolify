import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataOptionsListWidget extends StatefulWidget {
  final List<String> optionValues;
  final void Function(String?) onChanged;
  final String prefixMsg;
  const DataOptionsListWidget(
      {Key? key, required this.optionValues, required this.onChanged, required this.prefixMsg})
      : super(key: key);

  @override
  State<DataOptionsListWidget> createState() => _DataOptionsListWidgetState();
}

class _DataOptionsListWidgetState extends State<DataOptionsListWidget> {
  int currentValueIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 250.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      width: 138.w,
      height: 32.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4D4395), Color(0xFF100848)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            widget.prefixMsg,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 15.sp,
                fontFamily: "Poppins"),
          ),
          const Spacer(),
          DropdownButton<String>(
            items: widget.optionValues.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            } ).toList(),
            onChanged: (String? value) {
              if (value == null) return;
              int index = widget.optionValues.indexOf(value);
              widget.onChanged(value);
              setState(() {
                currentValueIndex = index;
              });
            },
            value: widget.optionValues[currentValueIndex],
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 15.sp,
                fontFamily: "Poppins"
            ),
            dropdownColor: const Color(0xFF100848),
            borderRadius: BorderRadius.circular(8),
            underline: Container(),
            icon: const Icon(Icons.arrow_drop_down_sharp, color: Color(0xFF9C8D8D)),
          ),
        ],
      ),
    );
  }
}
