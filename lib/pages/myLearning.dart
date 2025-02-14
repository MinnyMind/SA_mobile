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
              imagePath: ['assets/Images/marketing.png',
              'assets/Images/juanjo-jaramillo-mZnx9429i94-unsplash-1024x683.jpg',
              'assets/Images/math.png',
              'assets/Images/science.png',
              ],
              menu: "All Courses",
            ),
             Mylearningitem(
              imagePath: [
                'assets/images/c++.png',
              ],
              menu: "Playlist",
            ),
             Mylearningitem(
              imagePath: [
               'assets/images/javascript.png',
              ],
              menu: "Wishlist",
            ),
             Mylearningitem(
              imagePath: [
               'assets/images/mongodb.png',
              ],
              menu: "Archived",
            ),
            
          ],
        ),
      ),
    );
  }
}
