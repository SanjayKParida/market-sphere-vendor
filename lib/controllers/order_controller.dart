import 'dart:convert';

import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/order/order_model.dart';
import '../services/manage_http_response.dart';
import '../services/snackbar_service.dart';

class OrderController {
  //METHOD TO GET ORDERS BY VENDOR ID
  Future<List<OrderModel>> loadOrders({required String vendorId}) async {
    try {
      //SEND AN HTTP GET REQUEST
      http.Response response = await http.get(
          Uri.parse("$URI/api/orders/vendors/$vendorId"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });

      if (response.statusCode == 200) {
        //PARSE THE JSON RESPONSE BODY TO DYNAMIC LIST
        List<dynamic> ordersData = jsonDecode(response.body);
        //MAP THE DYNAMIC LIST
        List<OrderModel> orders =
            ordersData.map((order) => OrderModel.fromJson(order)).toList();
        return orders;
      } else {
        throw Exception("Failed to load orders :(");
      }
    } catch (e) {
      throw Exception("Failed :( $e");
    }
  }

  //METHOD TO DELETE ORDER BY ID
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      //SEND HTTP DELETE REQUEST TO DELETE ORDER
      http.Response response = await http
          .delete(Uri.parse("$URI/api/orders/$id"), headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      });

      //MANAGE RESPONSE
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackbar(context, "Order Deleted Successfully");
          });
    } catch (e) {
      showSnackbar(context, "$e");
    }
  }

  Future<void> updateStatusDelivered(
      {required String id, required context}) async {
    try {
      http.Response response =
          await http.patch(Uri.parse("$URI/api/orders/$id/delivered"),
              headers: <String, String>{
                "Content-Type": "application/json; charset=UTF-8",
              },
              body: jsonEncode({
                "delivered": true,
              }));

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackbar(context, "Status updated");
          });
    } catch (e) {
      showSnackbar(context, "$e");
    }
  }

  Future<void> cancelOrder({required String id, required context}) async {
    try {
      http.Response response =
          await http.patch(Uri.parse("$URI/api/orders/$id/processing"),
              headers: <String, String>{
                "Content-Type": "application/json; charset=UTF-8",
              },
              body: jsonEncode({
                "processing": false,
              }));

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackbar(context, "Order Cancelled.");
          });
    } catch (e) {
      showSnackbar(context, "$e");
    }
  }
}
