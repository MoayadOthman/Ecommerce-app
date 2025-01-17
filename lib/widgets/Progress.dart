import 'package:flutter/material.dart';

Container circularProgress(){
  return Container(
    alignment: Alignment.center,
    padding:const EdgeInsets.only(top: 10.0) ,
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.greenAccent
      ),
    ),
  );
}

Container linerProgress(){
  return Container(
    padding:const EdgeInsets.only(bottom: 10.0) ,
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
          Colors.greenAccent
      ),
    ),
  );
}