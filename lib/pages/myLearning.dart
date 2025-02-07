import 'package:flutter/material.dart';
import '../Widgets/myLearningItem.dart';

class MyLearning extends StatelessWidget {
  const MyLearning({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Image.asset('assets/images/logoSA.png', 
          height: 60,),
        ),
        backgroundColor: Color.fromRGBO(20, 18, 24, 1),
      ),
      body: Center(
      child: Mylearningitem(imagePath: 'assets/images/littleGirl.jpg')

      ),
    );
    
  }
}
