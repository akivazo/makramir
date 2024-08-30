import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentManager {
  Widget getPaymentTerminalView(Map<String, String> clientDetails, int amount) {
    return PaymentTerminalView(
      clientDetails: clientDetails,
      amount: amount,
    );
  }
}

class PaymentTerminalView extends StatelessWidget {
  Map<String, String> clientDetails;
  int amount;

  PaymentTerminalView(
      {super.key, required this.clientDetails, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.paymentPageTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
          child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.paymentDemoStage),
                  SelectableText("miryam334@gmail.com")
                ],
              ))),
    );
  }
}
