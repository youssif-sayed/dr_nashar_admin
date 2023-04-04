import 'package:flutter/material.dart';

PreferredSizeWidget CustomAppBar() {
  return AppBar(
    title: Container(
      child: const Image(
        image: AssetImage(
          'images/Icons/appIcon.png',
        ),
        height: 50,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
    shadowColor: Colors.transparent,
  );
}
