import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:hubtel_merchant_checkout_sdk/src/core_ui/core_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../platform/models/models.dart';
import '../../resources/html_strings.dart';
import 'bank_pay_status_screen.dart';

class BankPayReceiptScreen extends StatefulWidget {
  String generatedPdfFilePath = '';

  BankPayReceiptScreen(
      {Key? key,
      required this.mobileMoneyResponse,
      required this.businessDetails})
      : super(key: key);

  final MomoResponse mobileMoneyResponse;

  final HtmlRequirements businessDetails;

  @override
  State<BankPayReceiptScreen> createState() => _BankPayReceiptScreenState();
}

class _BankPayReceiptScreenState extends State<BankPayReceiptScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadHtmlString(HTMLStrings.generateString(
          widget.businessDetails, widget.mobileMoneyResponse));
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Download Pdf",
      pageDecoration: PageDecoration(
        backgroundColor: HubtelColors
            .neutral.shade300, // Theme.of(context).scaffoldBackgroundColor,
      ),
      hideBackNavigation: false,
      bottomNavigation: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: CustomButton(
            title: 'Download Pdf'.toUpperCase(),
            isEnabled: true,
            buttonAction: () => {
                  generatePdfFromHtml(HTMLStrings.generateString(
                      widget.businessDetails, widget.mobileMoneyResponse))
                },
            loading: false,
            isDisabledBgColor: HubtelColors.lighterGrey,
            disabledTitleColor: HubtelColors.grey,
            style: HubtelButtonStyle.solid,
            isEnabledBgColor: ThemeConfig.themeColor),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generatePdfFromHtml(String htmlContent) async {
    log('${widget.mobileMoneyResponse}', name: '$runtimeType');

    widget.showLoadingDialog(context: context, text: "Downloading");
    Directory? appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final targetFileName =
        "${widget.businessDetails.businessName}_${widget.mobileMoneyResponse.customerName}_${DateTime.now()}";

    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath ?? "", targetFileName);
    log('$generatedPdfFile', name: '$runtimeType');

    final openFile = await OpenFilex.open(generatedPdfFile.path);

    if (!mounted) return;

    Navigator.pop(context);

    if (openFile != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BankPayStatusScreen()));
    }
  }
}
