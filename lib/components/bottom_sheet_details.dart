import 'package:flutter/material.dart';

class BottomSheetDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: const Text('Modal BottomSheet'),
      ),
    );
  }
}

void showBottomSheetDetails(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return BottomSheetDetails();
    },
  );
}
