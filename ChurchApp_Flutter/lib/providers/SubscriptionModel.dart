import 'package:flutter/foundation.dart';
import 'dart:async';
import '../utils/StringsUtils.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionModel with ChangeNotifier {
  final InAppPurchaseConnection connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> subscription;
  List<String> notFoundIds = [];
  List<ProductDetails> products = [];
  List<PurchaseDetails> userPurchases = [];
  bool isAvailable = false;
  bool purchasePending = false;
  bool loading = true;
  String queryProductError;
  bool isSubscribed = false;

  SubscriptionModel() {
    initInAppPurchases();
  }

  //inapp purchases
  initInAppPurchases() {
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await connection.isAvailable();
    if (!isAvailable) {
      this.isAvailable = isAvailable;
      products = [];
      userPurchases = [];
      notFoundIds = [];
      purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await connection.queryProductDetails(StringsUtils.productIds.toSet());
    if (productDetailResponse.error != null) {
      queryProductError = productDetailResponse.error.message;
      this.isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      userPurchases = [];
      notFoundIds = productDetailResponse.notFoundIDs;
      purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      queryProductError = null;
      this.isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      userPurchases = [];
      notFoundIds = productDetailResponse.notFoundIDs;
      purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    this.isAvailable = isAvailable;
    products = productDetailResponse.productDetails;
    userPurchases = verifiedPurchases;
    notFoundIds = productDetailResponse.notFoundIDs;
    purchasePending = false;
    loading = false;
    if (userPurchases.length > 0) {
      isSubscribed = true;
    }
    notifyListeners();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    userPurchases.add(purchaseDetails);
    print("userPurchases item = " + userPurchases[0].productID);
    purchasePending = false;
    isSubscribed = true;
    notifyListeners();
  }

  void handleError(IAPError error) {
    purchasePending = false;
    notifyListeners();
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }
}
