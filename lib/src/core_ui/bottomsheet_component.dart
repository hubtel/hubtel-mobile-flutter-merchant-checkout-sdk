

import 'package:flutter/material.dart';
import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';

Future showAppBottomSheet(
    {required BuildContext context,
      required Widget child,
      String? title,
      String? subtitle,
      String? closeText,
      bool showCloseButton = true,
      bool isDismissible = true,
      bool isScrollControlled = true,
      bool hideTitle = false,
      double? bottomPadding}) async {
  var res = await showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.paddingDefault),
        topRight: Radius.circular(Dimens.paddingDefault),
      ),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
// content
                Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimens.paddingDefault),
                      topRight: Radius.circular(Dimens.paddingDefault),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
//
                      Padding(
                        padding: bottomPadding == null
                            ? const EdgeInsets.all(Dimens.paddingDefault)
                            : EdgeInsets.only(
                          top: Dimens.paddingDefault,
                          bottom: bottomPadding,
                          right: Dimens.paddingDefault,
                        ),
                        child: Visibility(
                          visible: !hideTitle,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon( Icons.close_outlined, color: Colors.black,),
                                ),
                              ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title ?? "",
                                      style: AppTextStyle.body1()
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(subtitle ?? ""),
                                    const SizedBox(height: Dimens.paddingNano,),
                                    Container(height: 1, width: double.infinity,color: HubtelColors.grey.shade100,)
                                  ],
                                )
                              ]
                          ),
                        ),
                      ),

                      SafeArea(child: child),

// space
                      const SizedBox(
                        height: Dimens.paddingDefault,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  return res;
}
