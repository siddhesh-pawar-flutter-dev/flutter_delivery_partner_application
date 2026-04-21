import 'package:flutter_delivery_partner_application/core/utils/map_utils.dart';
import 'package:get/get.dart';

class TshirtSelectionController extends GetxController {
  final double lat = 22.3171414;
  final double lng = 73.1681651;
  var selectedSize = "".obs;
  var quantity = 1.obs;
  final String address =
      'Ozone, Sarabhai Campus, Dr Vikram Sarabhai Marg, Subhanpura, Vadodara, Gujarat';

  Future<void> openGoogleMaps() async {
    await MapUtils.openGoogleMaps(lat: lat, lng: lng);
  }

  final Map<String, bool> sizeStock = {
    "S": true,
    "M": true,
    "L": true,
    "XL": true,
    "XXL": false,
  };

  void selectSize(String size) {
    if (sizeStock[size] == false) return;
    selectedSize.value = size;
  }

  void increaseQty() => quantity.value++;

  void decreaseQty() {
    if (quantity.value > 1) quantity.value--;
  }

  int get price => 199 * quantity.value;
}
