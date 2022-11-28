import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/progress_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: const Color(0xFF131524),
          ),
          Transform.translate(
            offset: const Offset(-10, 0),
            child: SvgPicture.asset("assets/login_icons_1.svg",
                color: const Color(0xFFF06482)),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 193.w,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 51.h,
                        ),
                        CircleAvatar(
                          radius: 40.r,
                          backgroundColor: const Color(0xFFCCC1F0),
                          child: Icon(Icons.person),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 9.w,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 65.h,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Welcome!\n",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontSize: 16.sp,
                                  color: Colors.white.withOpacity(0.8)),
                              children: const [
                                TextSpan(
                                    text: "Ahmed",
                                    style: TextStyle(color: Colors.white))
                              ]),
                        )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          "ST Page",
                          style: TextStyle(
                              color: const Color(0xFFCCC1F0),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Icon(
                          Icons.settings,
                          size: 28.sp,
                          color: Colors.white,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10.w,
                    )
                  ],
                ),
                SizedBox(height: 16.h,),
                Row(
                  children: [
                    SizedBox(
                      width: 270.w,
                    ),
                    Container(
                      width: 138.w,
                      height: 32.h,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                         Color(0xFF4D4395),
                         Color(0xFF100848)
                        ],
                      )),
                      child: Row(
                        children: [
                          Text(
                            "Last",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: "Poppins"
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Year",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontFamily: "Poppins"
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_sharp, color: Color(0xFF9C8D8D)),
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    SizedBox(
                      width: 270.w,
                    ),
                    Container(
                      width: 138.w,
                      height: 32.h,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF4D4395),
                              Color(0xFF100848)
                            ],
                          )),
                      child: Row(
                        children: [
                          const Spacer(),
                          Text(
                            "Smart Manager",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontFamily: "Poppins"
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_sharp, color: Color(0xFF9C8D8D)),
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 30.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.h),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.topRight,
                        child: FancyProgressIndicator(
                          percentage: 80,
                          backgroundColor: Color(0xFF306767),
                          colors: [
                            Color(0xFFEE6482),
                            Color(0xFF40E1D1),
                            Color(0xFFF3CFC5),
                          ],
                          name: "Attendance",
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, 150.h),
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: FancyProgressIndicator(
                            percentage: 100,
                            backgroundColor: Color(0xFF306767),
                            colors: [
                              Color(0xFFEE6482),
                              Color(0xFF40E1D1),
                              Color(0xFFF3CFC5),
                            ],
                            name: "Grades",
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, 280.h),
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: FancyProgressIndicator(
                            percentage: 70,
                            backgroundColor: Color(0xFF306767),
                            name: "Superiority",
                            colors: [
                              Color(0xFFEE6482),
                              Color(0xFF40E1D1),
                              Color(0xFFF3CFC5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
