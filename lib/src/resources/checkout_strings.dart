// import 'package:feature_checkout/ux/models/web_checkout_state.dart';

enum CheckoutHtmlState {
  failed, // loading of html has failed
  success, //meaning loading is successful
  loadingBegan, // means loading has began
  htmlLoadingFailed, // means htmlLoading failed
}

class CheckoutStrings {
  static const package = 'unified_checkout_sdk';
  static const checkout = 'Checkout';
  static const String ghanaCardHeading = 'Ghana Card Details';
  static const youWillBeCharged = "You will be charged";
  static const String titleVerification = 'Verification';
  static const selectPaymentMethod = "Select payment method";

  static const payWith = "Pay with";

  // payment methods
  static const card = "card";
  static const mobilemoney = "mobilemoney";

  static const mtnMobileMoney = "MTN Mobile Money";

  static const mobileMoney = "Mobile Money";

  static const mobileNumber = "Mobile Number";

  static const addMobileMoneyWallet = "Add Mobile Money Wallet";
  static const addWalletScreenTitle = "Add Mobile Wallet";

  static const mobileNetwork = "Mobile Network";

  static var mandateIdHint = 'Enter Mandate ID';

  static String gMoneyInstructionsHeading = 'Steps to generate a mandate ID on G-Money';
  static String gMoneySteps = '''
1 Dial *422#

2 Select Option 2 (G-Money)

3 Select Option 4 (Payment Services)

4 Select Option 6 (Mandate)

5 Select Option 1 (Create Mandate)
  ''';

  static const paymentWithMomoInfoHead =
      "You will be required to enter your MTN "
      "Mobile Money PIN to authorise this payment.\n\nIf you don't receive any authorisation prompt, dial ";

  static const paymentWithMomoInfoTail =
      " go to My Account and select Approvals";

  static const vodafoneCash = "Vodafone Cash";

  static const airtelTigoMoney = "AirtelTigo Cash";

  static const mtnMomoShortCode = "*170#";

  static const mtn = "mtn";

  static const vodafone = "vodafone";

  static const airtelTigo = "airteltigo";

  static const airtelDashTigo = "Airtel-Tigo";

  static const airtel = "airtel";

  static const atMoney = "at";

  static const bankCard = "Bank Card";

  static const hubtelBalance = "Hubtel Balance";

  static const useNewCard = "Use a new card";

  static const useSavedCard = "Use a saved card";

  static const invalidCardNumber = "Invalid card number";

  static const bankCardHintText = "1234 **** **** 7890";

  static const saveCardForFuture = "Save this card for future use";

  static const save = "Save";

  static const monthAndYearDateHint = "MM / YYYY";

  static const monthAndYearBankHint = "MM/YY";

  static const cvv = "CVV";

  static const invalidDateFormat = "Invalid date format";

  static const invalidCardCvv = "Invalid card cvv";

  static const youHaveNoSavedCards = "You have no saved cards";

  static const String visa = "Visa";

  static const String masterCard = "Master Card";

  static const collectionSuccessUrl =
      "https://hubtelappproxy.hubtel.com/3ds/collection/Success/redirect/";

  static String mobileMoneyNumber = 'Mobile Money Number';
  static String selectNetwork = 'Select Mobile Network';

  static var addNumberHint = 'eg 054 025 6631';
  static var ghanaCardNumberHint = 'ABC-XXXXXXXXXX-X';

  static String getPaymentPromptMessage({required String walletNumber}) {
    return "A bill prompt has been sent to you on $walletNumber, please authorise the payment.";
  }

  static String pleaseWait = "Please wait";

  static String loading = "loading";

  static String somethingWentWrong = "Something Went Wrong";

  static String hubtelBalanceInfo =
      'Your balance on Hubtel will be debited immediately you confirm payment.\n\n'
      'No authorisation prompt will be sent to you.';

  static String amount = "Amount";
  static String fees = "Fees";
  static String eLevy = "E-Levy";

  static String cancel = "Cancel";
  static String iHavePaid = "I HAVE PAID";
  static String processingPayment = "Processing Payment";
  static String done = "Done";
  static String checkAgain = 'Check Again';
  static String successWithdrawal = 'Success Withdrawal';
  static String hubtel = "hubtel";

  static String momo = "momo";

  static String incorrectPin = "Incorrect Pin";

  static String transactionSuccessful = "Transaction Successful";

  static String payAtBankBranch = 'Pay at your bank branch via ';
  static String ghanaGov = 'Ghana.GOV';
  static String paymentPlatform = '\npayment platform.';
  static String bankPayStatusSteps1 = 'Once complete you may check the status';
  static String bankPayStatusSteps2 = '\nof this pay-in-slip in your payment';
  static String bankPayStatusSteps3 = '\nhistory or dial ';
  static String bankPayShortCode = '*718*108#';

  static String makeHtmlString(String accessToken) {
    return '''
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta http-equiv="X-UA-Compatible" content="IE=edge">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title></title>
                </head>
                <body>
                <iframe id="cardinal_collection_iframe" name="collectionIframe" height="10" width="10"
                        style="display: none;">
                </iframe>
                <form id="cardinal_collection_form"
                      method="POST" target="collectionIframe"
                      action="https://centinelapi.cardinalcommerce.com/V1/Cruise/Collect">
                    <input id="cardinal_collection_form_input"
                           type="hidden" name="JWT"
                           value="$accessToken">
                </form>
                </body>
                <script>
                    window.onload = function () {
                        var cardinalCollectionForm = document.querySelector('#cardinal_collection_form');
                        if (cardinalCollectionForm) {
                         cardinalCollectionForm.submit();
                         }
                    }

                    window.addEventListener("message", function (event) {
                        if (event.origin === "https://centinelapi.cardinalcommerce.com") {
                            console.log(event.data);
                            window.location = "${CheckoutStrings.collectionSuccessUrl}"
                            DeviceCollectionComplete.postMessage('${CheckoutHtmlState.loadingBegan}');
                        }else{
                            DeviceCollectionComplete.postMessage('${CheckoutHtmlState.htmlLoadingFailed}')
                            }
                    }, false);
            </script>
        </html>
''';
  }

  static String continueCheckout(String orderId, String reference, String jwt,
      [String? customData]) {
    String htmlString = '''
          <!DOCTYPE html>
          <html lang="en">
            <head>
              <meta charset="UTF-8" />
              <meta http-equiv="X-UA-Compatible" content="IE=edge" />
              <meta name="viewport" content="width=device-width, initial-scale=1.0" />
              <title></title>
              <style>
                iframe {
                  display: block;
                  border: none;
                  height: 100vh;
                  width: 100vw;
                }
              </style>
            </head>
            <body>
              <div>
                <iframe name="step-up-iframe"></iframe>
                <form
                  id="step_up_form"
                  target="step-up-iframe"
                  method="POST"
                  action="https://centinelapi.cardinalcommerce.com/V2/Cruise/StepUp"
                >
                  <input
                    name="JWT"
                    class="form-control"
                    type="hidden"
                    value="$jwt"
                  />
                  <input id="md-input" type="hidden" name="MD" />
                  <button class="btn btn-success" style="display: none">Step up</button>
                </form>
              </div>
              <script type="text/javascript">
                        window.onload = function() {
                  let mdInput = document.querySelector("#md-input");
                  mdInput.value = `${customData ?? ""}`
                  window.addEventListener("message", function handler(event) {
                    if (event.origin === "https://cybersourcecallbacks.hubtel.com") {
                      DeviceCollectionComplete.postMessage('${CheckoutHtmlState.success}');
                      this.removeEventListener("message", handler);
                    }else{
                     DeviceCollectionComplete.postMessage('${CheckoutHtmlState.failed}');
                     this.removeEventListener("message", handler);
                   }
                  });
                  let stepUpForm = document.querySelector("#step_up_form");
                  if (stepUpForm) {
                    stepUpForm.submit();
                  }
                }
              </script>
            </body>
          </html>


  ''';

    return htmlString;
  }

  static String vodafoneCashString = "Vodafone Cash";

  static String airtelTigoMoneyString = "Airtel Tigo Money";

  static String checkAgainTimeLeft({required int timeLeft}) {
    return 'Check Again (00:0$timeLeft)';
  }

  static const yourPaymentIsBeingProcessed =
      "Your payment is being processed. Tap the button below to check payment status";

  static const yourPaymentIsBeingProcessedCheckAgain =
      r'Your Payment is being processed. Tap on the "Check Again" button to confirm your final payment status ';
  static const pay = 'Pay';

  static const forgot_pin = "Forgot Pin";

  static const hubtel_pin_desc = "Please enter your Hubtel PIN \n to proceed";

  static const resetString =
      "For security reasons, all your debit/credit accounts will be removed. You would have to sign in again and set a new pin";

  static const okay = "Okay";

  static const secureHubtelPin = "Set Your Hubtel Pin";

  static const secureHubtelPinMessage =
      "Secure your Hubtel Balance transactions by approving each one with your own pin";

  static const success = "Success";

  static const cancelTransaction = "Cancel Transaction?";

  static const doYouWantToCancelTransaction =
      'Do you want to cancel this transaction?';

  static const keepYourTransactionSecure = "Keep your account secure";

  static const setHubtelPin = "Set your hubtel account pin";

  static const confirmYourPin = "Confirm Your Pin";

  static const renterYourPin = "Re-enter your Hubtel account PIN to confirm";

  static const keepYourAccountSecure = "Keep your account secure";

  static const setYourAccountPin = "Set your hubtel account pin";

  static const resetPin = "Reset PIN";

  static const pinSettings = "PIN Settings";

  static const unexpectedMessage = "Something went wrong";

  static const navigationString = "feature_onboarding/login";

  static const mtnShortString = 'mtn';

  static const atRegex = r'(airtel|tigo)';

  static const mtnGh = 'mtn-gh';

  static const vodafone_gh_ussd = 'vodafone-gh-ussd';

  static const tigoGh = 'tigo-gh';

  static const cardNotPresentVisa = "cardnotpresent-visa";

  static const cardnotpresent_mastercard = "cardnotpresent-mastercard";

  static const card_not_present = "cardnotpresent";

  static const four = "4";

  static const five = "5";

  static const BankCard = "Bank Card";

  static const bankPay = "bankpay";

  static const bank_pay = "Bank Pay";

  static String getChannelNameForBankPayment(String cardNumber) {
    return cardNumber.startsWith(CheckoutStrings.four)
        ? CheckoutStrings.cardNotPresentVisa
        : CheckoutStrings.cardnotpresent_mastercard;
  }

  static const String fullName = 'Full Name';
  static const String cardDetailsTitle = 'Card Details';
  static const String cardNumber = 'Card Number';
  static const String scrambledCardSample = '**** **** **** 5809';
  static const String expires = 'Expires';
  static const String expiresSample = '06/23';
  static const String personalId = 'Personal ID Number';
  static const String birthDate = 'DOB';
  static const String gender = 'Gender';
  static const String fullNameSample = 'Frimpong Darkwa Kwame';
  static const String personalIdSample = 'GHA-000338531-5';
  static const birthDateSample = '10/06/1995';
  static const genderSample = 'Male';
  static const orderMessage = 'Your order has been placed';
  static const ordersAndDelivery = 'Orders and Delivery';
  static const confirmationMessage =
      'Your {walletName} will be debited with {GHS 0.00} after your order is confirmed';
  static const String verificationSuccess =
      'Your account has been verified successfully';

  static const other = "Others";

}
