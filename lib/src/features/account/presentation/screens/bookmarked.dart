import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class BookmarkedScreen extends StatelessWidget {
  const BookmarkedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Your blurred background
          const BlurHash(
            hash: "LNECfc=_-7\$y}?%Mn~qxR-kC9Fof",
            imageFit: BoxFit.cover,
          ),
          // Your home screen content
          Center(
              child: GestureDetector(
            onLongPressStart: (LongPressStartDetails details) {
              _showPopupMenu(context, details.globalPosition);
            },
            child: const Icon(
              Icons.fingerprint,
              color: Colors.white,
              size: 100,
            ),
          )),
        ],
      ),
    );
  }

  void _showPopupMenu(BuildContext context, Offset tapPosition) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(tapPosition.dx, tapPosition.dy, 0, 0),
      items: [
        const PopupMenuItem(
          value: 'option1',
          child: Text('Optisfon 1'),
        ),
        const PopupMenuItem(
          value: 'option2',
          child: Text('Option 2'),
        ),
        // Add more options as needed
      ],
      elevation: 8.0,
    );
  }
}
