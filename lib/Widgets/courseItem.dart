import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  final List<String> imagePath;
  final String courseName;
  final String courseDescription;
  final VoidCallback? onMorePressed;

  const CourseItem({
    super.key,
    required this.imagePath,
    required this.courseName,
    required this.courseDescription,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ใช้ SizedBox จำกัดขนาดรูปภาพ
          SizedBox(
            width: 85, // ป้องกันการขยายตัวมากเกินไป
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: imagePath.isNotEmpty
                    ? imagePath.map((url) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0), // ลด padding ลง
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              url,
                              width: 70, // ลดขนาดรูป
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/images/littleGirl.jpg",
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        );
                      }).toList()
                    : [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            "assets/images/littleGirl.jpg",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
              ),
            ),
          ),

          const SizedBox(width: 6), // ลดระยะห่างระหว่างรูปกับข้อความ

          // ข้อมูลคอร์ส
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  courseDescription,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onMorePressed,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
