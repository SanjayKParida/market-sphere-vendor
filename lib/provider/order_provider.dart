import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order/order_model.dart';

class OrderProvider extends StateNotifier<List<OrderModel>> {
  OrderProvider() : super([]);

  //SET THE LIST OF ORDERS
  void setOrders(List<OrderModel> orders) {
    state = orders;
  }

  void updateOrderStatus(String orderId, {bool? processing, bool? delivered}) {
    //UPDATE THE STATE OF THE PROVIDER WITH A NEW LIST OF ORDERS
    state = [
      //ITERATE THROUGH EXISTING
      for (final order in state)
        //CHECK IF CURRENT ORDER ID MATCHES THE ID WE WANT TO UPDATE
        if (order.id == orderId)
          //CREATE NEW ORDER OBJECT WITH THE UPDATED STATUS
          OrderModel(
            id: order.id,
            fullName: order.fullName,
            email: order.email,
            state: order.state,
            city: order.city,
            locality: order.locality,
            productName: order.productName,
            productPrice: order.productPrice,
            quantity: order.quantity,
            category: order.category,
            image: order.image,
            buyerId: order.buyerId,
            vendorId: order.vendorId,
            //USE THE NEW PROCESSING IF PROVIDED
            processing: processing ?? order.processing,
            delivered: delivered ?? order.delivered,
          )
        //IF CURRENT ORDER ID DOESN'T MATCH
        else
          order
    ];
  }
}

final orderProvider =
    StateNotifierProvider<OrderProvider, List<OrderModel>>((ref) {
  return OrderProvider();
});
