import 'package:flutter/material.dart';

class PropertyPostCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String imageUrl;
  final String postType;

  const PropertyPostCard({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.postType,
  });

  @override
  Widget build(BuildContext context) {
    bool isOffer = postType == 'offer';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isOffer ? Colors.white.withOpacity(0.04) : Colors.amber.withOpacity(0.03), 
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isOffer ? Colors.white.withOpacity(0.08) : Colors.amber.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isOffer && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.network(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price, 
                      style: TextStyle(
                        color: isOffer ? const Color(0xFF2196F3) : Colors.amber, 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        fontFamily: 'Cairo'
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isOffer ? Colors.white.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isOffer ? "عرض بيع" : "مطلوب عقار",
                        style: TextStyle(
                          color: isOffer ? Colors.white70 : Colors.amber, 
                          fontSize: 11, 
                          fontFamily: 'Cairo'
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title, 
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white38, size: 16),
                    const SizedBox(width: 5),
                    Text(location, style: const TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'Cairo')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}