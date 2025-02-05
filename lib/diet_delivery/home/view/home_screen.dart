import 'package:diet_diet_done/core/constraints/const_colors.dart';
import 'package:diet_diet_done/core/constraints/constraints.dart';
import 'package:diet_diet_done/diet_delivery/calendar/api/get_calendar_dates_service.dart';
import 'package:diet_diet_done/diet_delivery/calendar/controller/diet_menu_controller.dart';
import 'package:diet_diet_done/diet_delivery/home/api/get_support_service.dart';
import 'package:diet_diet_done/diet_delivery/home/api/pass_device_token.dart';
import 'package:diet_diet_done/diet_delivery/home/controller/getProfileController.dart';
import 'package:diet_diet_done/diet_delivery/home/controller/home_screen_controller.dart';
import 'package:diet_diet_done/diet_delivery/home/widgets/custom_app_bar.dart';
import 'package:diet_diet_done/diet_delivery/home/widgets/custom_elevated_button.dart';
import 'package:diet_diet_done/diet_delivery/home/widgets/floating_action_button.dart';
import 'package:diet_diet_done/diet_delivery/home/widgets/profile_card_image.dart';
import 'package:diet_diet_done/diet_delivery/home/widgets/profile_diet_card.dart';
import 'package:diet_diet_done/food_delivery/menu/api/show_menu_api_service.dart';
import 'package:diet_diet_done/profile_config/controller/subscription_plan_controller.dart';
import 'package:diet_diet_done/profile_config/view/plan_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final PassDeviceTokenToBackEnd passDeviceTokenToBackEnd =
        PassDeviceTokenToBackEnd();
    final getProfileController = Get.find<GetProfileController>();
    final homeScreenController = Get.find<HomeController>();
    final subscriptionController = Get.find<SubscriptionPlanController>();
    final calendarController = Get.find<DietMenuController>();

    await Future.wait<void>([
      getProfileController.fetchProfileData(),
      GetCalendarDatesApiService().getCalendarDates(),
      homeScreenController.fetchNotification(),
      subscriptionController.getSubscriptionDetails(),
      ShowMenuApiService().showMenu(),
      calendarController.fetchDietMeals(),
      GetSupportNumberApiService().getSupportNumber(),
      passDeviceTokenToBackEnd.sendDeviceToken(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionController = Get.find<SubscriptionPlanController>();
    final homeScreenController = Get.find<HomeController>();
    final getProfileController = Get.find<GetProfileController>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
            child: Image.asset(
          "assets/background_image/pexels-oziel-gвmez-1667427.jpg",
          fit: BoxFit.cover,
        )),
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        CustomAppBarTile(
          size: size,
          profileController: getProfileController,
          homeController: homeScreenController,
        ),
        Container(
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      subscriptionController.subscriptionDetails.isEmpty
                          ? ProfileDietCardShimmer()
                          : ProfileDIetCard(
                              size: size,
                              profileController: getProfileController,
                              subscriptionController: subscriptionController,
                            ),
                      kHeight(5),
                      ElevatedButton2(
                        size: size,
                        backgroundColor: kWhiteColor,
                        textColor: kPrimaryColor,
                        text: "Subscription renewal",
                        onPressed: () => Get.to(PlanSelectionScreen()),
                      ),
                      kHeight(5),
                      ElevatedButton2(
                        size: size,
                        backgroundColor: kPrimaryColor,
                        textColor: kWhiteColor,
                        text: 'Book appointment',
                        onPressed: () async {
                          await PassDeviceTokenToBackEnd().sendDeviceToken();
                          Get.dialog(AlertDialog(
                            title: const Text("Book a Dietician?"),
                            content: const Text(
                                "You can request a consultation by pressing yes. Our representative will contact you soon."),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    Get.back();
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: kPrimaryColor),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("No")),
                            ],
                          ));
                        },
                      )
                    ],
                  ),
                ),
                ProfileCardImage(
                  size: size,
                  profileController: getProfileController,
                ),
                const CustomFloatingActionButton()
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class ProfileDietCardShimmer extends StatelessWidget {
  const ProfileDietCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250,
        width: 250,
        child: Shimmer.fromColors(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
            ),
            baseColor: Colors.grey,
            highlightColor: kWhiteColor),
      ),
    );
  }
}
