import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  String formatCurrency(double price) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(price);
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Product Details',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 40), // To balance the AppBar
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          duration: Duration(milliseconds: 500),
                          child: Text(
                            product.name,
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        FadeInUp(
                          duration: Duration(milliseconds: 500),
                          delay: Duration(milliseconds: 100),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade800,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              formatCurrency(product.price),
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildSection(
                          title: 'Product Description',
                          icon: Icons.description,
                          content: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in velit vel justo bibendum bibendum. Sed euismod, nunc sit amet aliquam tincidunt, nunc nisl aliquam nisl, eget aliquam nunc nisl sit amet nisl.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildSection(
                          title: 'Product Details',
                          icon: Icons.info_outline,
                          content: Column(
                            children: [
                              _buildDetailRow(
                                  Icons.category, 'Category', 'Electronics'),
                              _buildDetailRow(
                                  Icons.inventory, 'Stock', '10 units'),
                              _buildDetailRow(
                                  Icons.star, 'Rating', '4.5 (200 reviews)'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FadeInUp(
        duration: Duration(milliseconds: 500),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // Add to cart functionality
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue.shade800,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart),
                SizedBox(width: 8),
                Text(
                  'Add to Cart',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required IconData icon,
      required Widget content}) {
    return FadeInUp(
      duration: Duration(milliseconds: 500),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.blue.shade800),
                  SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade800, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
