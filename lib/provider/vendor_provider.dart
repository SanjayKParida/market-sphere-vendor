import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_sphere_vendor/models/vendor/vendor_model.dart';

//STATE NOTIFIER IS PROVIDED BY RIVERPOD THAT HELPS IN
//MANAGING THE STATE. IT IS DESIGNED TO NOTIFY LISTENERS ABOUT THE STATE CHANGE
class VendorProvider extends StateNotifier<VendorModel?> {
  VendorProvider()
      : super(
          VendorModel(
            id: '',
            fullName: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            role: '',
            password: '',
          ),
        );

  //GETTER METHOD TO EXTRACT VALUE FROM OBJECT
  VendorModel? get vendor => state;

  //METHOD TO SET VENDOR USER STATE
  //TO UPDATE THE USER STATE BASED ON JSON STRING REPRESENTATION OF THE VENDOR OBJECT

  void setVendor(String vendorJson) {
    state = VendorModel.fromJson(vendorJson);
  }

  //METHOD TO CLEAR VENDOR USER STATE
  void signOut() {
    state = null;
  }
}

//MAKE THE DATA ACCESSIBLE WITHIN THE APPLICATION
final vendorProvider =
    StateNotifierProvider<VendorProvider, VendorModel?>((ref) {
  return VendorProvider();
});
