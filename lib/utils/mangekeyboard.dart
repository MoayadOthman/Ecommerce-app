import 'package:flutter/cupertino.dart';

class KeyboardUti{
  static void hideKeyboard(BuildContext context){
    FocusScopeNode currentFocus=FocusScope.of(context);
    if(!currentFocus.hasPrimaryFocus){
      currentFocus.unfocus();
    }
  }
}

