
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:last/utils/appconstant.dart';

class CustomHeading extends StatelessWidget {
  final String headingTitle;
  final String buttonText;
  final VoidCallback press;
  const CustomHeading({super.key, required this.headingTitle, required this.buttonText, required this.press});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
      child: Padding(
        padding:const EdgeInsets.all(8.0),
      child:Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          Text(headingTitle,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey.shade800),),
          TextButton(onPressed:press,child: Text(buttonText,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.grey), ),)
        ],
      ),),
    );
  }
}
