import 'package:flutter/material.dart';

class Mylearningitem extends StatelessWidget {
  final List<String> imagePath;
  final String menu;
  final VoidCallback? onPressed;

  const Mylearningitem({
    super.key,
    required this.imagePath,
    required this.menu,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  menu,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            TextButton(
                onPressed: onPressed, // ใช้ onPressed ที่รับมาจาก Parameter
                child: const Text("see all",
                    style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: imagePath.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CoursesImg(imagePath : imagePath[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CoursesImg extends StatelessWidget {
  final String imagePath;

  const CoursesImg({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          )
        ]
      ),
    );

  }
}
