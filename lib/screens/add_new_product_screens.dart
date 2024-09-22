import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
class AddNewProductScreens extends StatefulWidget {
  const AddNewProductScreens({super.key});

  @override
  State<AddNewProductScreens> createState() => _AddNewProductScreensState();
}

class _AddNewProductScreensState extends State<AddNewProductScreens> {
  final TextEditingController _productNameTEController=TextEditingController();
  final TextEditingController _productPriceTEController=TextEditingController();
  final TextEditingController _productQuantityTEController=TextEditingController();
  final TextEditingController _productCodeTEController=TextEditingController();
  final TextEditingController _productTotalPriceTEController=TextEditingController();
  final GlobalKey<FormState> _formkey=GlobalKey();
  bool _inprogress=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Add"),),
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
                labelText: "Product Name"
            ),
            validator: (String? value){
              if(value==null || value.isEmpty){
                return 'enter a valid value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _productPriceTEController,
            decoration: InputDecoration(
                hintText: "Price",
                labelText: "Unit Price"
            ),
            validator: (String? value){
              if(value==null || value.isEmpty){
                return 'enter a valid value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _productQuantityTEController,
            decoration: InputDecoration(
                hintText: "Quantity",
                labelText: "Unit Quantity"
            ),
            validator: (String? value){
              if(value==null || value.isEmpty){
                return 'enter a valid value';
              }
              return null;
            },
          ),
          TextFormField(
            controller:_productCodeTEController,
            decoration: InputDecoration(
                hintText: "Code",
                labelText: "Product Code"
            ),
            validator: (String? value){
              if(value==null || value.isEmpty){
                return 'enter a valid value';
              }
              return null;
            },
          ),
          TextFormField(
            controller:_productTotalPriceTEController,
            decoration: InputDecoration(
                hintText: "Total",
                labelText: "Total Price"
            ),
            validator: (String? value){
              if(value==null || value.isEmpty){
                return 'enter a valid value';
              }
              return null;
            },
          ),
          SizedBox(height: 20,),
          _inprogress ? const Center(child: CircularProgressIndicator(),): ElevatedButton(onPressed: _onTapAddProductButton, child: Text("Add New Item"),style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
          ),)

        ],
      ),
    );
  }

  void _onTapAddProductButton(){
    if(_formkey.currentState!.validate()){
      addNewProduct();
    }
  }
  Future<void> addNewProduct() async{
    _inprogress=true;
    setState(() {});
    Uri uri = Uri.parse("http://164.68.107.70:6060/api/v1/CreateProduct");
    Map<String,dynamic>requestBody={
      "ProductName": _productNameTEController.text,
      "ProductCode": _productCodeTEController.text,
      "UnitPrice": _productPriceTEController.text,
      "Qty": _productQuantityTEController.text,
      "TotalPrice": _productTotalPriceTEController.text,

    };
    Response response =await post(uri,
        headers: {
          "Content-Type":"application/json"
        },
        body: jsonEncode(requestBody));
    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200){
      _clearTEField();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully added ")));

    }
    _inprogress=false;
    setState(() {});
  }

  void _clearTEField(){
    _productTotalPriceTEController.clear();
    _productCodeTEController.clear();
    _productQuantityTEController.clear();
    _productPriceTEController.clear();
    _productNameTEController.clear();
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