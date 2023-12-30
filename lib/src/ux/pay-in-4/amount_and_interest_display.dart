import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/amount_display_component.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/repayment_schedule_table.dart';

class AmountAndInterestDisplay extends StatelessWidget {

  final List<RepaymentScheduleObj> repaymentSchedules;

  const AmountAndInterestDisplay({Key? key, required this.repaymentSchedules})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      itemBuilder: (context, index) {
        final item = repaymentSchedules[index];
        return AmountDisplayComponent(faintText: item.repaymentTime, amount: item.repaymentAmount);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: Dimens.paddingDefault,
        );
      },
      itemCount: repaymentSchedules.length,
    );
  }
}
