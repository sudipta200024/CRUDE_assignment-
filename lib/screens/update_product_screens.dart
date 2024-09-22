import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductScreens extends StatefulWidget {
  final String productId;
  final String productName;
  final String productCode;
  final String productPrice;
  final String productQuantity;
  final String productTotalPrice;

  const UpdateProductScreens({
    super.key,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.productPrice,
    required this.productQuantity,
    required this.productTotalPrice,
  });

  @override
  State<UpdateProductScreens> createState() => _UpdateProductScreensState();
}

class _UpdateProductScreensState extends State<UpdateProductScreens> {
  late TextEditingController _productNameTEController;
  late TextEditingController _productPriceTEController;
  late TextEditingController _productQuantityTEController;
  late TextEditingController _productCodeTEController;
  late TextEditingController _productTotalPriceTEController;
  final GlobalKey<FormState> _formkey = GlobalKey();
  bool _inprogress = false;

  @override
  void initState() {
    super.initState();
    _productNameTEController = TextEditingController(text: widget.productName);
    _productPriceTEController = TextEditingController(text: widget.productPrice);
    _productQuantityTEController = TextEditingController(text: widget.productQuantity);
    _productCodeTEController = TextEditingController(text: widget.productCode);
    _productTotalPriceTEController = TextEditingController(text: widget.productTotalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Product")),
      body: buildForm(),
    );
  }

  Form buildForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: _productNameTEController,
            decoration: InputDecoration(
              hintText: "Name",
              labelText: "Product Name",
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _productPriceTEController,
            decoration: InputDecoration(
              hintText: "Price",
              labelText: "Unit Price",
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _productQuantityTEController,
            decoration: InputDecoration(
              hintText: "Quantity",
              labelText: "Unit Quantity",
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _productCodeTEController,
            decoration: InputDecoration(
              hintText: "Code",
              labelText: "Product Code",
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _productTotalPriceTEController,
            decoration: InputDecoration(
              hintText: "Total",
              labelText: "Total Price",
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid value';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _inprogress
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
            onPressed: _onTapUpdateProductButton,
            child: Text("Update Product"),
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromWidth(double.maxFinite),
            ),
          )
        ],
      ),
    );
  }

  void _onTapUpdateProductButton() {
    if (_formkey.currentState!.validate()) {
      updateProduct();
    }
  }

  Future<void> updateProduct() async {
    _inprogress = true;
    setState(() {});
    Uri uri = Uri.parse("http://164.68.107.70:6060/api/v1/UpdateProduct/${widget.productId}");
    Map<String, dynamic> requestBody = {
      "ProductName": _productNameTEController.text,
      "ProductCode": _productCodeTEController.text,
      "UnitPrice": _productPriceTEController.text,
      "Qty": _productQuantityTEController.text,
      "TotalPrice": _productTotalPriceTEController.text,
    };
    Response response = await post(uri,
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(requestBody));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully updated")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update failed")));
    }
    _inprogress = false;
    setState(() {});
  }

  @override
  void dispose() {
    _productTotalPriceTEController.dispose();
    _productCodeTEController.dispose();
    _productQuantityTEController.dispose();
    _productPriceTEController.dispose();
    _productNameTEController.dispose();
    super.dispose();
  }
}
