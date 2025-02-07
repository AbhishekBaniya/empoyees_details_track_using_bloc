import 'package:flutter/material.dart';

import '../utils/enum/button_type_enum.dart';

class AppCustomButtonWidget extends StatelessWidget {
  final Enum buttonType;
  final VoidCallbackAction? onCancelClicked, onSavedClicked;
  const AppCustomButtonWidget({super.key, required this.buttonType, this.onCancelClicked, this.onSavedClicked});

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.opacity:
        return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width:  73,
              decoration: BoxDecoration(
                color: Colors.blue.shade100.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("Cancel", style: TextStyle(color: Colors.blue),),
            ),

        );
      case ButtonType.filled:
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width:  73,
              decoration: BoxDecoration(
                color: Colors.blue.shade500,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("Save", style: TextStyle(color: Colors.white),),
            ),
        );
    }
    return SizedBox.shrink();
  }
}

