import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';
import 'package:hubtel_merchant_checkout_sdk/src/custom_components/saved_bank_card_form.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/amount_and_interest_display.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/repayment_schedule_table.dart';

enum SectionType { boldedTextInfo, interestTerms, repaymentSchedule }

class ConfirmationScreenDisplayObject {
  final SectionType sectionType;
  final List<RepaymentScheduleObj>? interestTerms;
  final List<RepaymentScheduleObj>? repaymentSchedule;
  final String? boldedTextNote;

  ConfirmationScreenDisplayObject({required this.sectionType,
    this.interestTerms,
    this.repaymentSchedule,
    this.boldedTextNote});
}

class AmountDisplayConfirmationScreen extends StatelessWidget {
  AmountDisplayConfirmationScreen({Key? key}) : super(key: key);

  final screenViewObj = [
    ConfirmationScreenDisplayObject(
      sectionType: SectionType.interestTerms,
      interestTerms: [
        RepaymentScheduleObj(repaymentTime: "Amount", repaymentAmount: 1000),
        RepaymentScheduleObj(repaymentTime: "Interest", repaymentAmount: 80),
        RepaymentScheduleObj(repaymentTime: "Interest Rate", repaymentAmount: 8)
      ],
    ),
    ConfirmationScreenDisplayObject(
      sectionType: SectionType.boldedTextInfo,
      boldedTextNote: "Note that interest of 80 will be paid on your first Installment",
    ),
    ConfirmationScreenDisplayObject(
      sectionType: SectionType.repaymentSchedule,
      repaymentSchedule: [
        RepaymentScheduleObj(repaymentTime: "now", repaymentAmount: 100),
        RepaymentScheduleObj(
            repaymentTime: "12/11/1920", repaymentAmount: 100),
        RepaymentScheduleObj(
            repaymentTime: "13/12/1990", repaymentAmount: 100)
      ],
    ),
    ConfirmationScreenDisplayObject(
      sectionType: SectionType.boldedTextInfo,
      boldedTextNote: "You are obligated to make payments as outlined within this period of time. Failure to make payments on time may lead to increased interest rates, damage to your credit score and potential legal action",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 700,
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingDefault),
            child: AnimatedBuilder(
              builder: (context, child) {
                return CustomButton(
                  title: "CONFIRM AND PAY",
                  isEnabled: true,
                  buttonAction: () {
                    Navigator.pop(context, true);
                  },
                  loading: false,
                  isDisabledBgColor: HubtelColors.lighterGrey,
                  disabledTitleColor: HubtelColors.grey,
                  style: HubtelButtonStyle.solid,
                  isEnabledBgColor: ThemeConfig.themeColor,
                );
              },
              animation: Listenable.merge([
                // checkoutHomeScreenState.isButtonEnabled,
                // checkoutHomeScreenState.isLoadingFees
              ]),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: ListView.separated(itemBuilder: (context, index) {
            final item = screenViewObj[index];
            switch (item.sectionType){
              case SectionType.repaymentSchedule:
                return RepaymentScheduleTable(repaymentSchedules: item.repaymentSchedule ?? []);
              case SectionType.interestTerms:
                return AmountAndInterestDisplay(repaymentSchedules: item.interestTerms ?? []);
              case SectionType.boldedTextInfo:
                return Text(item.boldedTextNote ?? "", style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),);
            }
          },
              separatorBuilder: (context, index) {
                return SizedBox(height: 24,);
              },
              itemCount: screenViewObj.length)
          ,
        ),
      ),
    );
  }
}
