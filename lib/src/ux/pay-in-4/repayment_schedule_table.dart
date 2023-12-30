import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';
import 'package:hubtel_merchant_checkout_sdk/src/utils/currency_formatter.dart';
import 'package:hubtel_merchant_checkout_sdk/src/ux/pay-in-4/amount_display_component.dart';


enum AmountType{
  paymentAmount,
  interestRate
}
class RepaymentScheduleObj {
  String repaymentTime;
  double repaymentAmount;
  AmountType type;

  RepaymentScheduleObj(
      {required this.repaymentTime, required this.repaymentAmount, this.type = AmountType.paymentAmount});
}

class RepaymentScheduleTable extends StatelessWidget {
  final List<RepaymentScheduleObj> repaymentSchedules;

  const RepaymentScheduleTable({Key? key, required this.repaymentSchedules})
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
          if (index == repaymentSchedules.length + 1) {
            return _buildTotalHolder(_getTotalAmountPayable());
          }
          final item = repaymentSchedules[index - 1];
          return AmountDisplayComponent(
              faintText: item.repaymentTime,
              amount: item.repaymentAmount);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: Dimens.paddingDefault,
          );
        },
        itemCount: repaymentSchedules.length + 2);
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
          "Repayment Schedule",
          style: AppTextStyle.body2().copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8,),
        Container(
          width: double.infinity,
          color: Colors.black,
          height: 2,
        )
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
