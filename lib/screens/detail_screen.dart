import 'package:flutter/material.dart';
import '../models/property.dart';

/// Detail screen displaying comprehensive property information, favorite toggle, and Contact Agent action.
class DetailScreen extends StatefulWidget {
  final Property property;

  const DetailScreen({super.key, required this.property});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Format price helper
  String _formatPrice(int price) {
    if (price >= 10000000) {
      double cr = price / 10000000;
      return '₹${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 2)} Cr';
    } else if (price >= 100000) {
      double l = price / 100000;
      return '₹${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 2)} Lakh';
    }
    return '₹$price';
  }

  // Choose icon based on property type
  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Flat':
        return Icons.apartment;
      case 'Villa':
        return Icons.villa;
      case 'House':
      default:
        return Icons.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.property;

    return Scaffold(
      appBar: AppBar(
        title: Text(prop.title),
        actions: [
          // Favorite toggle icon button
          IconButton(
            icon: Icon(
              prop.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: prop.isFavorite ? Colors.red : null,
              size: 28,
            ),
            tooltip: prop.isFavorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: () {
              setState(() {
                prop.isFavorite = !prop.isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    prop.isFavorite ? 'Added to favorites!' : 'Removed from favorites.',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image Placeholder banner
            Container(
              height: 220,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getTypeIcon(prop.type),
                    size: 90,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${prop.type} in ${prop.city}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          prop.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatPrice(prop.price),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        prop.city,
                        style: const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Property quick specifications grid / chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpecChip(Icons.category, 'Type', prop.type),
                      _buildSpecChip(Icons.bed, 'Bedrooms', '${prop.bedrooms} BHK'),
                      _buildSpecChip(Icons.square_foot, 'Area', '${prop.area} sq ft'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description Section
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prop.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Contact Agent Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.phone_in_talk),
                      label: const Text(
                        'Contact Agent',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // Display the requested SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Agent will contact you'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecChip(IconData icon, String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
