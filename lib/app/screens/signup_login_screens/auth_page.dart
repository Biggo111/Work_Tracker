import 'package:flutter/material.dart';
import 'package:work_tracker/app/constants/constants.dart';
import 'package:work_tracker/app/screens/signup_login_screens/login_tab.dart';
import 'package:work_tracker/app/screens/signup_login_screens/signup_tab.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

    // Create a TabController with 2 tabs
    TabController tabController = TabController(length: 2, vsync: this);
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async{
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: homeBackgroundColor,
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/images/background.png"),
                    fit: BoxFit.cover),
              ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 42,
                vertical: 140, //previous - 155
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40), color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        elevation: 5,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              //border: Border.all(),
                              color: Colors.white,
                            ),
                            child: TabBar(
                              // Customize the appearance of the TabBar
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: scaffoldBackgroundColor,
                              ),
                              controller: tabController,
                              isScrollable: true,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 35),
                              unselectedLabelColor: scaffoldBackgroundColor,
                              tabs: const[
                                Tab(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Jua',
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Signup',
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'Jua'),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: const [
                            LoginTab(),  //Login page Tab
                            SignupTab(), //Signup page Tab
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}