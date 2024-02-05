

import 'package:flutter/material.dart';

class configAppBar extends StatelessWidget {
  const configAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.devices_other_sharp, 
          color: Colors.black, 
          size: 30,
          ),
        const SizedBox(width: 10,),
        const Text(
          'Devices',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.lightBlue.shade200,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.add_sharp, 
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}