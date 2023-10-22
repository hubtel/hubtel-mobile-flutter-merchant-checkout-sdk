


import 'package:flutter/material.dart';

import '../core_ui.dart';

class HBButtonLarge extends StatefulWidget {

  bool isEnabled;

  String title;


  Color enabledBgColor;

  Color disabledBgColor;

  Color enabledTitleColor;

  Color disabledTitleColor;

  VoidCallback? buttonAction;

  double? buttonPaddings;

  HBButtonLarge({
    Key? key,
    required this.title,
    required this.enabledBgColor,
    required this.disabledBgColor,
    required this.enabledTitleColor,
    required this.disabledTitleColor,
    this.isEnabled = true,
    required this.buttonAction,
    this.buttonPaddings
  }) : super(key: key);

  @override
  State<HBButtonLarge> createState() => _HBButtonLargeState();

  factory HBButtonLarge.createTealButton({
    required String title,
    required VoidCallback? buttonAction,
    required bool isEnabled,
    double? padding
  }){

    return HBButtonLarge(
        title: title,
        enabledBgColor: HubtelColors.teal,
        disabledBgColor: HubtelColors.neutral,
        enabledTitleColor: HubtelColors.neutral.shade100,
        disabledTitleColor: HubtelColors.neutral.shade300,
        buttonAction: buttonAction,
        buttonPaddings: padding,
        isEnabled: isEnabled,
    );

  }

}

class _HBButtonLargeState extends State<HBButtonLarge> {
  @override
  Widget build(BuildContext context) {



    return Padding(
      padding:  EdgeInsets.all(widget.buttonPaddings ?? 16),
      child: SizedBox(

        width:  double.infinity,

        child: TextButton(

          onPressed: widget.isEnabled ? widget.buttonAction : null,

          style: TextButton.styleFrom(
              backgroundColor: widget.isEnabled ? widget.enabledBgColor : widget.disabledBgColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
          ),

          child: Text(widget.title, style: TextStyle(
              color: widget.isEnabled ? widget.enabledTitleColor : widget.disabledTitleColor,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),


          ),
        ),
      ),
    );
  }

  void enableButton({required bool activate}){
    setState(() {
      widget.isEnabled = activate;
    });
  }


}
