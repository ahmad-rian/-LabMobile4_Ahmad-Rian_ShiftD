import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../models/product.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({Key? key, this.product}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
    }
  }

  Future<void> _saveProduct() async {
    setState(() {
      _isLoading = true;
    });

    final product = Product(
      name: _nameController.text,
      price: double.parse(_priceController.text),
    );

    final url = widget.product == null
        ? 'http://localhost:8000/api/products'
        : 'http://localhost:8000/api/products/${widget.product!.id}';

    final response = widget.product == null
        ? await http.post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(product.toJson()),
          )
        : await http.put(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(product.toJson()),
          );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save product')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _deleteProduct() async {
    if (widget.product != null) {
      final url = 'http://localhost:8000/api/products/${widget.product!.id}';

      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 204) {
        _showDeleteSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product')),
        );
      }
    }
  }

  void _showDeleteSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Success',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Product has been deleted successfully.',
            style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK',
                style: GoogleFonts.poppins(color: Colors.blue.shade700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Add Product' : 'Edit Product',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade700, Colors.purple.shade700],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInDown(
                    duration: Duration(milliseconds: 500),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Product Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                prefixIcon: Icon(Icons.shopping_bag,
                                    color: Colors.blue.shade700),
                              ),
                              style: GoogleFonts.poppins(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter product name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            TextFormField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                labelText: 'Price',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                prefixIcon: Icon(Icons.attach_money,
                                    color: Colors.blue.shade700),
                              ),
                              style: GoogleFonts.poppins(),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter product price';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  FadeInUp(
                    duration: Duration(milliseconds: 500),
                    child: _isLoading
                        ? Center(
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveProduct();
                              }
                            },
                            icon: Icon(widget.product == null
                                ? Icons.add
                                : Icons.update),
                            label: Text(
                              widget.product == null
                                  ? 'Add Product'
                                  : 'Update Product',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue.shade700,
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                  ),
                  if (widget.product != null)
                    FadeInUp(
                      duration: Duration(milliseconds: 500),
                      delay: Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton.icon(
                          onPressed: _deleteProduct,
                          icon: Icon(Icons.delete),
                          label: Text(
                            'Delete Product',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red.shade600,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
