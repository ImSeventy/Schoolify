import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/use_cases/use_case.dart';
import 'package:frontend/core/utils/extensions.dart';
import 'package:frontend/core/widgets/text_with_stroke.dart';
import 'package:frontend/dependency_container.dart';
import 'package:frontend/features/onboarding/domain/use_cases/mark_onboarding_shown.dart';
import 'package:frontend/router/routes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/images_paths.dart';
import '../widgets/next_button.dart';
import '../widgets/onboarding_sub_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Widget> subPages = [
    const OnBoardingSubPage(
      imagePath: ImagesPaths.progressIndicatorsChain,
      text: "Take control of your learning and monitor your progress from home with ease",
    ),
    const OnBoardingSubPage(
      imagePath: ImagesPaths.post,
      text: "Stay connected and informed about your school's latest news and updates from the comfort of your own home!",
    ),
    const OnBoardingSubPage(
      imagePath: ImagesPaths.yearSemesterSelector,
      text: "Maximize your potential and reach your academic goals by keeping track of your grades, attendance, certificates, and warnings for specific years and semesters!",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 23.w,
              vertical: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWithStroke(
                  text: "Schoolify",
                  style: context.theme.textTheme.headline1,
                  strokeWidth: 3,
                  strokeColor: const Color(0xFF12A8D8),
                ),
                SizedBox(height: 29.h),
                SizedBox(
                  height: 640.h,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: subPages,
                  ),
                ),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count:  subPages.length,
                    axisDirection: Axis.horizontal,
                    effect: const ExpandingDotsEffect(
                        spacing:  8,
                        radius:  20,
                        dotWidth:  15,
                        dotHeight:  15,
                        expansionFactor: 3,
                        dotColor:  Colors.grey,
                        activeDotColor:  Color(0xFF0064D9)
                    ),
                  )  ,
                ),
                SizedBox(height: 30.h,),
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: NextButton(
                    onPressed: () {
                      if (_pageController.page == subPages.length - 1) {
                        getIt<MarkOnBoardingShownUseCase>().call(NoParams());
                        context.pushNamedAndRemove(Routes.login);
                        return;
                      }

                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );

                      setState(() {
                        _currentPage++;
                      });
                    },
                    isLastPage: _currentPage == subPages.length - 1,
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
