import 'package:intl/intl.dart';

import '../platform/models/models.dart';

class HtmlRequirements {
  final String imageUrl;
  final String clientName;
  final String customerMsisdn;
  final String slipId;
  final String email;
  final String businessName;

  HtmlRequirements({
    required this.imageUrl,
    required this.clientName,
    required this.customerMsisdn,
    required this.slipId,
    required this.email,
    required this.businessName,
  });
}

class HTMLStrings {
  static String generateTodayDate() {
    final dateFormatter = DateFormat("d MMMM yyyy");
    final today = DateTime.now();
    final formattedDate = dateFormatter.format(today);
    return formattedDate;
  }

  static String generateTodayTime() {
    final dateFormatter = DateFormat("h:mm a");
    final currentTime = DateTime.now();
    final formattedTime = dateFormatter.format(currentTime);
    return formattedTime;
  }

  static String generateString(
      HtmlRequirements requirements, MomoResponse? checkoutResponse) {
    print("heere${checkoutResponse.toString()}");
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:opsz,wght@6..12,300;6..12,400;6..12,500;6..12,600;6..12,700;6..12,800;6..12,900&display=swap" rel="stylesheet">
    <title>Processing Payment</title>
    <style>
      body {
        min-width: 330px;
        margin: 0;
        font-family: 'Nunito Sans', sans-serif;
      }
      h1, h2, h3, h4, h5, h6, p {
        margin: 0;
      }
      header {
        text-align: center;
        border-bottom: 1px solid #eee;
        position: relative;
        box-shadow: 2px 2px #eee;
        padding: 40px 20px 10px 20px;
      }
      header h2 {
        font-weight: 400;
      }
      header p {
        font-weight: 700;
      }
      section {
        padding: 30px 13px 20px;
        border: 1px solid #eee;
        margin: auto;
        box-shadow: 2px 4px #eee;
        border-radius: 8px;
        display: flex;
        justify-content: center;
        max-width: 500px;
        flex-direction: column;
      }
      .border-thin {
        border-bottom: 1px solid #eee;
      }
      .border-thick {
        border-bottom: 2px solid #eee;
      }
      .bottom-padding p, h1, h2, h3, h4, h5, h6 {
        padding-bottom: 10px;
      }
      button {
        padding: 20px;
        text-transform: uppercase;
        background-color: #01c7b1;
        color: #ffffff;
        border-radius: 8px;
        border: none;
        width: 100%;
        font-size: 18px;
        font-weight: 400;
      }
      .cancel {
        color: #ff0000;
        position: absolute;
        top: 45px;
        right: 16px;
      }
      .center {
        text-align: center;
      }
      .fixed-bottom {
        position: fixed;
        bottom: 0;
      }
      .flex-between {
        display: flex;
        justify-content: space-between;
        margin-bottom: 30px;
      }
      .flex-between:last-child {
        margin-bottom: 0;
      }
      .no-space {
        white-space: nowrap;
      }
      ol {
        padding-inline-start: 13px;
      }
      ol li {
        padding-bottom: 10px;
      }
      ol li:last-child {
        padding-bottom: 0;
      }
      .place-end {
        text-align: end;
      }
      .place-end span {
        background-color: #ffd7d5;
        color: #b22922;
        border-radius: 15px;
        padding: 5px 10px;
        font-weight: 700;
      }
      .page-margin-x {
        margin: 0 14px;
      }
      .steps {
        margin-top: 30px;
      }
      .smaller {
        font-size: 10px;
      }
      .small {
        font-size: 14px;
      }
      table {
        width: 100%;
        margin-top: 30px;
        border-bottom: 2px solid #e6e6e6;
      }
      tfoot tr:first-child {
        border-top: 1px solid #eee;
      }
    </style>
  </head>
  <body class="">
    <section>
      <div class="">
        <div class="flex-between">
          <div>
            <img src="${requirements.imageUrl}" alt="logo" width="120px" height="64px">
          </div>
          <div class="place-end bottom-padding">
            <h4>Cash/Cheque Pay-In-Slip</h4>
            <p class="small">${requirements.slipId}</p>
            <span class="smaller">Unpaid</span>
          </div>
        </div>
        <div class="flex-between">
          <div class="bottom-padding">
            <h5 class="">${requirements.businessName}</h5>
          </div>
          <div class="place-end bottom-padding">
            <p class="text-muted small">To:</p>
            <h6 class="small">${requirements.clientName}</h6>
            <p class="small">${requirements.email}</p>
            <p class="small">${requirements.customerMsisdn}</p>
          </div>
        </div>
        <div class="flex-between">
          <div class="bottom-padding">
            <p class="small text-muted">Payment Method</p>
            <h6 class="small">Bankpay at Any bank</h6>
          </div>
          <div class="place-end bottom-padding">
            <p class="text-muted small">Date • Time</p>
            <p class="small">${HTMLStrings.generateTodayDate()} • ${HTMLStrings.generateTodayTime()}</p>
          </div>
        </div>
      </div>
      <div>
        <table class="small">
          <thead>
            <tr>
              <th><p>Description</p></th>
              <th><p class="no-space">Amount</p></th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><p>${checkoutResponse?.description ?? ""}</p></td>
              <td><p class="no-space">GHS ${checkoutResponse?.amountAfterCharges ?? 0.00}</p></td>
            </tr>
            <tr>
              <td><p>Fees</p></td>
              <td><p class="no-space">GHS ${checkoutResponse?.charges ?? 0.00}</p></td>
            </tr>
          </tbody>
          <tfoot>
            <tr>
              <td><h4>Amount to pay</h4></td>
              <td><h4 class="no-space">GHS ${checkoutResponse?.amountCharged ?? 0.00}</h4></td>
            </tr>
          </tfoot>
        </table>
      </div>
      <div class="steps">
        <h5>
          To complete your transaction, please pay for this invoice with the following steps
        </h5>
        <ol>
          <li class="small">
            <p>
              Pay at your bank branch via Ghana.GOV Payment Platform or send this invoice to your relationship manager at your bank
            </p>
          </li>
          <li class="small">
            <p>
              Mention the Ghana.GOV Pay-In-Slip Number : ${requirements.slipId} to pay at the teller of your bank
            </p>
          </li>
          <li class="small">
            <p>
              Once complete, you may check the status of this Pay-In-Slip in your payment history
            </p>
          </li>
        </ol>
      </div>
    </section>
  </body>
</html>
''';
  }
}
