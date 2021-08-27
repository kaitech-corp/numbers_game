import 'package:crushai/services/constants.dart';
import 'package:flutter/material.dart';

class Robot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      color: Colors.grey.shade200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
      robot,
    ),
        ));
  }
}
