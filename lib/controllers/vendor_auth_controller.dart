import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_sphere_vendor/core/constants.dart';
import 'package:market_sphere_vendor/models/vendor/vendor_model.dart';
import 'package:http/http.dart' as http;
import 'package:market_sphere_vendor/provider/vendor_provider.dart';
import 'package:market_sphere_vendor/services/manage_http_response.dart';
import 'package:market_sphere_vendor/services/snackbar_service.dart';
import 'package:market_sphere_vendor/views/screens/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  //SIGNUP FUNCTION
  Future<void> signUpVendor(
      {required String fullName,
      required String email,
      required String password,
      required context}) async {
    try {
      VendorModel vendor = VendorModel(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: '',
        password: password,
      );

      http.Response response = await http.post(
          Uri.parse('$URI/api/vendor/signup'),
          body: vendor.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Account Created!');
        },
      );
    } catch (e) {
      showSnackbar(context, 'Error: $e');
    }
  }

  //SIGNIN FUNCTION
  Future<void> signInVendor(
      {required String email,
      required String password,
      required context}) async {
    try {
      http.Response response = await http.post(
          Uri.parse('$URI/api/vendor/signin'),
          body: jsonEncode(
            {"email": email, "password": password},
          ),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            //EXTRACT THE AUTHENTICATION TOKEN FROM THE RESPONSE BODY
            String token = jsonDecode(response.body)['token'];

            //STORE THE AUTHENTICATION TOKEN IN SHARED PREFERENCES
            await prefs.setString('auth_token', token);

            //ENCODE THE VENDOR DATA RECEIVED FROM THE BACKEND AS JSON
            final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);

            //UPDATE THE APPLICATION STATE WITH THE USER DATA USING RIVERPOD
            providerContainer
                .read(vendorProvider.notifier)
                .setVendor(vendorJson);
            
            await prefs.setString('vendor', vendorJson);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                (route) => false);
            showSnackbar(context, 'Successfully Logged In!');
          });
    } catch (e) {
      showSnackbar(context, 'Error Occurred: $e');
    }
  }
}
