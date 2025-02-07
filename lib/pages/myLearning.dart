import 'package:flutter/material.dart';
import '../Widgets/myLearningItem.dart';

class MyLearning extends StatelessWidget {
  const MyLearning({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logoSA.png',
          height: 70,
        ),
        backgroundColor: const Color.fromRGBO(20, 18, 24, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Mylearningitem(
              imagePath: ['assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              'assets/images/littleGirl.jpg',
              ],
              menu: "All Courses",
            ),
             Mylearningitem(
              imagePath: [
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
              ],
              menu: "Playlist",
            ),
             Mylearningitem(
              imagePath: [
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
              ],
              menu: "Wishlist",
            ),
             Mylearningitem(
              imagePath: [
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
                'assets/images/littleGirl.jpg',
              ],
              menu: "Archived",
            ),
            
          ],
        ),
      ),
    );
  }
}
