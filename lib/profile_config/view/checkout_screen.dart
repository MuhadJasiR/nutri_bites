import 'dart:developer';

import 'package:diet_diet_done/auth/sign_up/view/otp_succuss_screen.dart';
import 'package:diet_diet_done/core/constraints/const_colors.dart';
import 'package:diet_diet_done/core/constraints/constraints.dart';
import 'package:diet_diet_done/profile_config/api_service/create_subscription_service.dart';
import 'package:diet_diet_done/profile_config/controller/coupon_controller.dart';
import 'package:diet_diet_done/profile_config/controller/subscription_plan_controller.dart';
import 'package:diet_diet_done/profile_config/view/payment_gateway_webview.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key, required this.subscriptionCardIndex});
  final int subscriptionCardIndex;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subscriptionPlanController = Get.find<SubscriptionPlanController>();
    final couponController = Get.find<CouponController>();
    log(subscriptionPlanController.transactionUrl.value,
        name: "transaction url payment screen");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 41,
                height: 41,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: borderColor,
                  ),
                  color: kWhiteColor,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
            kWidth(20),
            Text(
              "Checkout",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.language,
                      color: kPrimaryColor,
                    )),
                Text(
                  "English",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(
              width: double.infinity,
              child: const Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Summer pack",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text("Weight loss"),
                      Text(
                        "20.000kd",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              "Payment Method",
              style: theme.textTheme.titleLarge,
            ),
            Column(
              children: [
                Card(
                  color: kWhiteColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.deepOrange,
                            ),
                            kWidth(10),
                            const Text(
                              "KNET",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          height: 40,
                          child: const Image(
                              image: AssetImage(
                            "assets/logo/knet-logo-2360944FA2-seeklogo.com.png",
                          )),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  color: kWhiteColor,
                  child: Row(
                    children: [
                      kWidth(10),
                      const Text(
                        "Coupon Code",
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => TextFormField(
                            controller:
                                subscriptionPlanController.couponController,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                                suffixIcon: couponController.isLoading.value
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.deepOrange,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ))
                                    : InkWell(
                                        onTap: () {
                                          couponController.verifyCoupon();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                            Icons.check,
                                            color: kWhiteColor,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 7)),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "Payment Summary",
              style: theme.textTheme.titleLarge,
            ),

            // final couponsValue = couponController.couponsList[0];

            Obx(
              () {
                return Card(
                  color: kWhiteColor,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        PaymentSummaryText(
                          amount: couponController.couponsList.isEmpty
                              ? "${subscriptionPlanController.subscriptionPlan[subscriptionCardIndex].price}"
                              : "${couponController.couponsList[0].total}",
                          text: 'Sub Total',
                        ),
                        PaymentSummaryText(
                          amount: couponController.couponsList.isEmpty
                              ? '0.00 KD'
                              : "${couponController.couponsList[0].discount}",
                          text: 'Discount',
                        ),
                        PaymentSummaryText(
                          amount: couponController.couponsList.isEmpty
                              ? "${subscriptionPlanController.subscriptionPlan[subscriptionCardIndex].price}"
                              : "${couponController.couponsList[0].grandTotal}",
                          text: 'Total',
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            ElevatedButton(
                onPressed: () {
                  if (subscriptionPlanController
                          .subscriptionPlan[subscriptionCardIndex].price ==
                      0.0) {
                    Get.snackbar("Success", "Payment capture success");
                    Get.off(const OTPSuccessScreen(screenName: true))!
                        .then((value) => null);
                  } else {
                    log(subscriptionPlanController.transactionUrl.toString(),
                        name: "transaction Url name");
                    Get.to(const PaymentGatewayWebview());
                  }
                },
                child: Text(
                  "Checkout",
                  style: theme.textTheme.labelLarge,
                ))
          ],
        ),
      ),
    );
  }
}

class PaymentSummaryText extends StatelessWidget {
  const PaymentSummaryText(
      {super.key, required this.amount, required this.text, this.color});

  final String text;
  final String amount;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          amount,
          style: TextStyle(fontSize: 18, color: color),
        )
      ],
    );
  }
}
