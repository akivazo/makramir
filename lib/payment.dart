import 'package:flutter/material.dart';

class PaymentManager {

  Widget getPaymentTerminalView(Map<String, String> clientDetails, int amount){
    return PaymentTerminalView(clientDetails:  clientDetails, amount: amount,);
  }
}

class PaymentTerminalView extends StatelessWidget {
  Map<String, String> clientDetails;
  int amount;

  PaymentTerminalView({super.key, required this.clientDetails, required this.amount});
  
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("This app is in the demo stage. No payment currently."),
        Text("client details:"),
        Text(clientDetails.toString()),
        Text("amount:"),
        Text(amount.toString())
      ],
    ),);
  }
}