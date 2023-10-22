
import 'package:flutter/material.dart';
import 'core_ui.dart';


enum HubtelButtonStyle { outlined, solid }

class CustomButton extends StatefulWidget {
  String title;

  HubtelButtonStyle style;

  Color? isEnabledBgColor;

  Color? isDisabledBgColor;

  bool isEnabled;

  Color? enabledTitleColor;

  Color? disabledTitleColor;

  Function buttonAction;

  double? width;

  bool loading;

  CustomButton({
    Key? key,
    required this.title,
    this.isEnabled = true,
    this.loading = false,
    this.style = HubtelButtonStyle.solid,
    this.isEnabledBgColor = Colors.black,
    this.isDisabledBgColor = Colors.yellow,
    required this.buttonAction,
    this.enabledTitleColor,
    this.disabledTitleColor,
    this.width,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return _createButton(style: widget.style);
  }

  Widget _createButton({required HubtelButtonStyle style}) {
    switch (style) {
      case HubtelButtonStyle.solid:
        return SizedBox(width: widget.width, child: _buildSolidButton());
      case HubtelButtonStyle.outlined:
        return SizedBox(width: widget.width, child: _buildOutlinedButton());
    }
  }

  Widget _buildOutlinedButton() {
    final enabledColor = widget.isEnabled
        ? widget.isEnabledBgColor ?? HubtelColors.teal
        : widget.isDisabledBgColor ?? HubtelColors.neutral.shade400;
    return OutlinedButton(
      onPressed: widget.isEnabled ? widget.buttonAction() : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: enabledColor,
        side: BorderSide(color: enabledColor, width: 1),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        widget.title,
        style: AppTextStyle.body1().copyWith(
          fontWeight: FontWeight.bold,
          color: enabledColor,
        ),
      ),
    );
  }

  Widget _buildSolidButton() {
    return TextButton(
      onPressed: widget.isEnabled ? () => widget.buttonAction() : null,
      style: TextButton.styleFrom(
        backgroundColor: widget.isEnabled
            ? widget.isEnabledBgColor
            : widget.isDisabledBgColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: widget.loading
          ? const SizedBox(
        height: Dimens.paddingDefault,
        width: Dimens.paddingDefault,
        child: LoadingIndicator(
          loaderColor: HubtelColors.white,
          strokeWidth: Dimens.two,
        ),
      )
          : Text(
        widget.title,
        style: AppTextStyle.body1().copyWith(
          color: widget.isEnabled
              ? widget.enabledTitleColor ?? HubtelColors.neutral.shade100
              : widget.disabledTitleColor ?? HubtelColors.neutral,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void activateButton(bool value) {
    setState(() {
      widget.isEnabled = value;
    });
  }
}
