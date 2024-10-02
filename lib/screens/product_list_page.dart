import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/product.dart';
import './product_form_page.dart';
import './product_detail_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/api/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  String formatCurrency(double price) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(price);
  }

  void _navigateToAddProduct() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProductFormPage()))
        .then((_) {
      setState(() {
        futureProducts = _fetchProducts();
      });
    });
  }

  void _navigateToEditProduct(Product product) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ProductFormPage(product: product)))
        .then((_) {
      setState(() {
        futureProducts = _fetchProducts();
      });
    });
  }

  void _navigateToDetailProduct(Product product) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade800, Colors.purple.shade800],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Product List',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: futureProducts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Product>? products = snapshot.data;
                      return AnimationLimiter(
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: products!.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Card(
                                    elevation: 5,
                                    margin: EdgeInsets.only(bottom: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(16),
                                      title: Text(
                                        products[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        formatCurrency(products[index].price),
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 16),
                                      ),
                                      onTap: () => _navigateToDetailProduct(
                                          products[index]),
                                      trailing: IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => _navigateToEditProduct(
                                            products[index]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text("${snapshot.error}",
                              style: TextStyle(color: Colors.white)));
                    }
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
