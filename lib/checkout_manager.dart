import 'package:flutter/material.dart';
import 'item.dart';

class CheckoutManager {
  final Set<Item> itemsToCheckout;

  CheckoutManager({required this.itemsToCheckout});

  CheckoutView getCheckoutView() {
    return CheckoutView(
      itemsToCheckout: itemsToCheckout,
    );
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
      decoration: InputDecoration(labelText: 'First Name'),
      autofocus: true,
      onSaved: (value) => saveFieldValue("first_name", value ?? ''),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your first name';
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
      decoration: InputDecoration(labelText: 'Last Name'),
      autofocus: false,
      onSaved: (value) => saveFieldValue("last_name", value ?? ''),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
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
      decoration: InputDecoration(labelText: 'Email'),
      autofocus: true,
      onSaved: (value) => saveFieldValue("email", value ?? ''),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
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
      decoration: InputDecoration(labelText: 'Address'),
      autofocus: false,
      onSaved: (value) => saveFieldValue("address", value ?? ''),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your address';
        }
        return null;
      },
    );
  }
}

class CheckoutForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _fieldsMap = {};

  void _setFieldValue(String key, String value) {
    _fieldsMap[key] = value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 20,
        child: LayoutBuilder(builder: (context, constraint) {
          return Container(
            width: constraint.maxWidth / 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                    child: Text(
                  "Enter your information:",
                  style: TextStyle(fontSize: 20),
                )),
                Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                      children: [
                        FirstNameField(saveFieldValue: _setFieldValue),
                        LastNameField(saveFieldValue: _setFieldValue),
                        EmailField(saveFieldValue: _setFieldValue),
                        AddressField(saveFieldValue: _setFieldValue)
                      ],
                    )),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (saveForm()){

                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [Text("Payment", style: TextStyle(color: Colors.black),), Icon(Icons.navigate_next)],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
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
  final Set<Item> itemsToCheckout;

  CheckoutView({super.key, required this.itemsToCheckout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(child: CheckoutForm()),
    );
  }
}
