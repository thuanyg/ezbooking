import 'package:ezbooking/core/utils/storage.dart';
import 'package:ezbooking/presentation/pages/login/login_page.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:ezbooking/core/config/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  static String routeName = "/Onboarding";

  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 230),
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: (idx) {
                setState(() {
                  _currentPage = idx;
                  _pageController.jumpToPage(idx);
                  _pageController.animateToPage(idx,
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 300));
                });
              },
              itemCount: onboardings.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Center(
                        child: ImageHelper.loadAssetImage(
                      onboardings[index].imageLink,
                      height: 200,
                    )),
                  ],
                );
              },
            ),
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            height: 288,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(38),
                topRight: Radius.circular(38),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    onboardings[_currentPage].title,
                    style: AppStyles.h5.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    textAlign: TextAlign.center,
                    onboardings[_currentPage].desc,
                    style: AppStyles.title1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              saveGuess();
                              Navigator.pushReplacementNamed(
                                  context, LoginPage.routeName);
                            },
                            child: Text(
                              "Skip",
                              style: AppStyles.title1
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              onboardings.length,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _pageController.animateToPage(
                                      index,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: _currentPage == index
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_currentPage == onboardings.length - 1) {
                                saveGuess();
                                Navigator.pushReplacementNamed(
                                    context, LoginPage.routeName);
                              }
                              setState(() {
                                if (_currentPage < onboardings.length - 1) {
                                  _currentPage++;
                                  _pageController.jumpToPage(_currentPage);
                                }
                              });
                            },
                            child: Text(
                              _currentPage == onboardings.length - 1
                                  ? "Start"
                                  : "Next",
                              style: AppStyles.title1
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> saveGuess() async {
    await StorageUtils.storeValue(key: "isFirstRun", value: "No");
  }
}
