
import 'package:flutter/material.dart';
import '/src/extensions/widget_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core_ui/core_ui.dart';
import '../../resources/resources.dart';
import '../view_model/checkout_view_model.dart';

class WebCheckoutPageData {
  String jwt, orderId, reference;
  String? customData, html;

  WebCheckoutPageData({
    required this.jwt,
    required this.orderId,
    required this.reference,
    this.customData,
    this.html
  });
}

class CheckoutWebViewWidget extends StatefulWidget {
  // CheckoutPurchase checkoutPurchase;
  WebCheckoutPageData pageData;

  CheckoutWebViewWidget({
    Key? key,
    required this.pageData,
  }) : super(key: key);

  @override
  State<CheckoutWebViewWidget> createState() => _CheckoutWebViewWidgetState();
}

class _CheckoutWebViewWidgetState extends State<CheckoutWebViewWidget> {
  late final WebViewController controller;

  late CheckoutViewModel viewModel;

  @override
  void initState() {
    super.initState();


    controller = WebViewController()
      ..loadHtmlString(
        widget.pageData.html ?? ""
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'TransactionComplete',
        onMessageReceived: (message) {
          if (message.message == CheckoutHtmlState.transactionComplete.toString()) {
            // TODO : Go back and go to the check status screen
            Navigator.pop(context, true);


          } else if (message.message == CheckoutHtmlState.htmlLoadingFailed) {
            if (!mounted) return;
           Navigator.pop(context);

            widget.showErrorDialog(
              context: context,
              message: "Something unexpected happened",
              onOkayTap: (){Navigator.pop(context);}
            );
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      pageDecoration: PageDecoration(backgroundColor: Colors.transparent),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
