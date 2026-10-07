import 'package:flutter/material.dart';
import '../models/property.dart';
import 'detail_screen.dart';

/// Home screen with search bar, property type filter dropdown, and property cards list.
class HomeScreen extends StatefulWidget {
  final List<Property> properties;

  const HomeScreen({super.key, required this.properties});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedType = 'All';

  final List<String> _types = ['All', 'Flat', 'House', 'Villa'];

  // Helper method to format Indian currency
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
    // Filter properties based on search query and type dropdown
    final filteredProperties = widget.properties.where((p) {
      final matchesQuery = p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.city.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == 'All' || p.type.toLowerCase() == _selectedType.toLowerCase();
      return matchesQuery && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Property Finder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Filter Bar Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by title or city (e.g. Pune, 3BHK)...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                ),
                const SizedBox(height: 10),
                // Type Dropdown Row
                Row(
                  children: [
                    const Text(
                      'Property Type: ',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedType,
                          items: _types.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            if (newVal != null) {
                              setState(() {
                                _selectedType = newVal;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${filteredProperties.length} found',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Property Cards List
          Expanded(
            child: filteredProperties.isEmpty
                ? const Center(
                    child: Text(
                      'No properties found matching your criteria.',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      final property = filteredProperties[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // Navigate to detail screen and refresh on return
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(property: property),
                              ),
                            ).then((_) {
                              setState(() {}); // refresh favorite state
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Placeholder Image Container with Type Icon
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _getTypeIcon(property.type),
                                    size: 40,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Property Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        property.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                          const SizedBox(width: 2),
                                          Text(
                                            property.city,
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.bed, size: 14, color: Colors.grey),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${property.bedrooms} BHK',
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _formatPrice(property.price),
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          if (property.isFavorite)
                                            const Icon(Icons.favorite, size: 18, color: Colors.redAccent),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
