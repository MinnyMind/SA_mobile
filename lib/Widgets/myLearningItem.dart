import 'package:flutter/material.dart';

class Mylearningitem extends StatelessWidget {
  final List<String> imagePath; // List of image URLs
  final String menu;
  final VoidCallback onPressed;

  const Mylearningitem({
    Key? key,
    required this.imagePath,
    required this.menu,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, 
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16,bottom: 16),
                child: Text(
                  menu,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white), 
                ),
              ),
           
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imagePath.map((url) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(
                        url,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover, 
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
       
          Positioned(
            right: 0,
            child: TextButton(
              onPressed: onPressed, 
              child: const Text(
                "See all",
                style:
                    TextStyle(color: Colors.white,
                    fontSize: 16), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
