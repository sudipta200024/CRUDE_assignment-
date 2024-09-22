import 'package:flutter/material.dart';
import 'package:loginlogoutpage/models/product.dart';
import 'package:http/http.dart' as http;
import '../screens/update_product_screens.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key, required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.white70,
          title: Text(product.productName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Product code: ${product.productCode}"),
              Text("Product price: \$${product.unitPrice}"),
              Text("Product quantity: ${product.quantity}"),
              Text("Product Total Price: \$${product.totalPrice}"),
              const Divider(),
              ButtonBar(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProductScreens(
                                productId: product.id,
                                productName: product.productName,
                                productCode: product.productCode,
                                productPrice: product.unitPrice,
                                productQuantity: product.quantity,
                                productTotalPrice: product.totalPrice,
                              )));
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                  TextButton.icon(
                    onPressed: () => _showDeleteConfirmation(context),
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    label: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Show a confirmation dialog before deleting
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              _deleteProduct(context, product.id);
            },
          ),
        ],
      ),
    );
  }

  // Delete product and provide feedback
  Future<void> _deleteProduct(BuildContext context, String id) async {
    try {
      final response = await http.get(
        Uri.parse('http://164.68.107.70:6060/api/v1/DeleteProduct/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // Close the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
      } else {
        Navigator.of(context).pop(); // Close the dialog
        print("Response: ${response.body}"); // Log the server response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product: ${response.statusCode}, ${response.body}')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

}
