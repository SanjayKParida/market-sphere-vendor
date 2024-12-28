import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_sphere_vendor/services/snackbar_service.dart';

void manageHttpResponse(
    {required http.Response response,
    required BuildContext context,
    required VoidCallback onSuccess}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackbar(context, json.decode(response.body)['message']);
      break;
    case 500:
      showSnackbar(context, json.decode(response.body)['message']);
      break;
    case 201:
      onSuccess();
      break;
    default:
  }
}
