

import '../platform/models/checkout_requirements.dart';
import 'checkout_endpoints.dart';

class EndPoints {
  CheckoutEndPoint get checkoutEndPoint => CheckoutEndPoint(
        merchantId: CheckoutRequirements.merchantId,
        apiKey: CheckoutRequirements.apiKey,
        customerMsisdn: CheckoutRequirements.customerMsisdn
      );
}
