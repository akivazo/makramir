import 'package:flutter/material.dart';
import 'item.dart';
import 'payment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutManager {
  final Set<Item> itemsToCheckout;

  CheckoutManager({required this.itemsToCheckout});

  CheckoutView getCheckoutView(BuildContext context) {
    void openPaymentTerminalDelegate(Map<String, String> clientDetails) {
      var paymentManager = PaymentManager();
      var paymentView = paymentManager.getPaymentTerminalView(clientDetails,
          itemsToCheckout.fold(0, (cost, item) => item.cost + cost));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => paymentView));
    }

    return CheckoutView(openPaymentTerminal: openPaymentTerminalDelegate);
  }
}

abstract class FormField extends StatelessWidget {
  final void Function(String, String) saveFieldValue;

  const FormField({super.key, required this.saveFieldValue});
}

class FirstNameField extends FormField {
  FirstNameField({required super.saveFieldValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration:
          InputDecoration(labelText: AppLocalizations.of(context)!.firstName),
      autofocus: true,
      onSaved: (value) => saveFieldValue("first_name", value ?? ''),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.firstNameInvalid;
        }
        return null;
      },
    );
  }
}

class LastNameField extends FormField {
  LastNameField({required super.saveFieldValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration:
          InputDecoration(labelText: AppLocalizations.of(context)!.lastName),
      autofocus: false,
      onSaved: (value) => saveFieldValue("last_name", value ?? ''),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.lastNameInvalid;
        }
        return null;
      },
    );
  }
}

class EmailField extends FormField {
  EmailField({required super.saveFieldValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration:
          InputDecoration(labelText: AppLocalizations.of(context)!.email),
      autofocus: true,
      onSaved: (value) => saveFieldValue("email", value ?? ''),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.emailInvalid;
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return AppLocalizations.of(context)!.emailInvalid;
        }
        return null;
      },
    );
  }
}

class AddressField extends FormField {
  AddressField({required super.saveFieldValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration:
          InputDecoration(labelText: AppLocalizations.of(context)!.address),
      autofocus: false,
      onSaved: (value) => saveFieldValue("address", value ?? ''),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.addressInvalid;
        }
        return null;
      },
    );
  }
}

class CheckoutForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _fieldsMap = {};
  final void Function(Map<String, String> clientDetails) paymentMethod;

  CheckoutForm({super.key, required this.paymentMethod});

  void _setFieldValue(String key, String value) {
    _fieldsMap[key] = value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Text(
          AppLocalizations.of(context)!.checkoutFormTitle,
          style: TextStyle(fontSize: 20),
        )),
        Form(
            key: _formKey,
            child: Card(
              child: ListView(
                shrinkWrap: true,
                children: [
                  FirstNameField(saveFieldValue: _setFieldValue),
                  LastNameField(saveFieldValue: _setFieldValue),
                  EmailField(saveFieldValue: _setFieldValue),
                  AddressField(saveFieldValue: _setFieldValue)
                ],
              ),

            )),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            /**if (saveForm()) {
                paymentMethod(_fieldsMap);
                }**/
            paymentMethod(_fieldsMap);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.checkoutSaveButton,
                style: TextStyle(color: Colors.black),
              ),
              Icon(Icons.navigate_next)
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
        ),
      ],
    );
  }

  bool saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      return true;
    }
    return false;
  }

  Map<String, String> getFieldsValues() {
    return _fieldsMap;
  }
}

class CheckoutView extends StatelessWidget {
  final void Function(Map<String, String>) openPaymentTerminal;

  CheckoutView({super.key, required this.openPaymentTerminal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.checkoutPageTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 500,
            child: CheckoutForm(
              paymentMethod: openPaymentTerminal,
            ),
          )),
    );
  }
}
