import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loginlogoutpage/models/product.dart';
import 'package:loginlogoutpage/screens/add_new_product_screens.dart';
import '../widgets/Productitem.dart';

class ProductListScreens extends StatefulWidget {
  const ProductListScreens({super.key});

  @override
  State<ProductListScreens> createState() => _ProductListScreensState();
}

class _ProductListScreensState extends State<ProductListScreens> {
  List<Product> productList = [];
  bool _inprogress = false;

  @override
  void initState() {
    super.initState();
    getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        actions: [
          IconButton(
            onPressed: getProductList,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _inprogress
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return ProductItem(
              product: productList[index],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 4);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddNewProductScreens();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getProductList() async {
    setState(() {
      _inprogress = true;
    });

    Uri uri = Uri.parse("http://164.68.107.70:6060/api/v1/ReadProduct");
    try {
      Response response = await get(uri);

      if (response.statusCode == 200) {
        productList.clear(); // Clear the list before repopulating
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        for (var item in jsonResponse["data"]) {
          Product product = Product(
            id: item['_id'] ?? '',
            productName: item['ProductName'] ?? '',
            productCode: item['ProductCode'] ?? '',
            unitPrice: item['UnitPrice']?.toString() ?? '0',
            quantity: item['Qty']?.toString() ?? '0',
            totalPrice: item['TotalPrice']?.toString() ?? '0',
            createdAt: item['CreatedDate'] ?? '',
          );
          productList.add(product);
        }
      } else {
        print("Failed to load products. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching product list: $e");
    } finally {
      setState(() {
        _inprogress = false;
      });
    }
  }
}
