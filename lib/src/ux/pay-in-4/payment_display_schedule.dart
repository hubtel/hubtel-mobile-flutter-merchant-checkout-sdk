import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';
import 'package:hubtel_merchant_checkout_sdk/src/utils/currency_formatter.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/amount_display_component.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/repayment_schedule_table.dart';

class PaymentScheduleDisplay extends StatelessWidget {
  final List<RepaymentScheduleObj> repaymentSchedules;

  const PaymentScheduleDisplay({Key? key, required this.repaymentSchedules})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildRepaymentScheduleHeader();
          }

          final item = repaymentSchedules[index - 1];
          if (index == 1) {
            return Container(
              padding: const EdgeInsets.all(Dimens.paddingNano),
              color: Colors.grey,
              child: AmountDisplayComponent(
                  faintText: item.repaymentTime, amount: item.repaymentAmount),
            );
          }
          return AmountDisplayComponent(
              faintText: item.repaymentTime, amount: item.repaymentAmount, showBottomLine: true,);
        },
        separatorBuilder: (context, index) {
          if(index == 0){
            return const SizedBox(
              height: Dimens.paddingNano,
            );
          }
          return const SizedBox(
            height: Dimens.paddingDefault,
          );
        },
        itemCount: repaymentSchedules.length + 1);
  }

  double _getTotalAmountPayable() {
    final double totalAmount = repaymentSchedules.fold(
        0, (double sum, RepaymentScheduleObj obj) => sum + obj.repaymentAmount);
    return totalAmount;
  }

  Widget _buildRepaymentScheduleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pay-In-4",
          style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTotalHolder(double total) {
    return Container(
      color: Colors.teal,
      padding: EdgeInsets.symmetric(vertical: Dimens.paddingNano),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total",
            style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            total.formatMoney(),
            style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
