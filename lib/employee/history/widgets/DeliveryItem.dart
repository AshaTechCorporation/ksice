import 'package:flutter/material.dart';
import 'package:ksice/constants.dart';

class DeliveryItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  DeliveryItem({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      color: textWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['time'],
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      data['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        SizedBox(height: 4),
                        Text(
                          data['title'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.red),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                data['address'],
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    data['status'],
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 11
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}