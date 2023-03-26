import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingCustomWidget extends StatefulWidget {
  final IconData icon;
  final Color color;
  final TextEditingController controller;
  final bool isLocked;

  const RatingCustomWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.controller,
    required this.isLocked,
  });

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<RatingCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
        child: RatingBar.builder(
          ignoreGestures: widget.isLocked,
          glow: true,
          glowColor: Colors.pinkAccent,
          glowRadius: 3,
          unratedColor: Colors.white,
          initialRating: double.parse(widget.controller.text),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, _) => Icon(
            widget.icon,
            color: widget.color,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              widget.controller.text = rating.toString();
            });
          },
        ),
      ),
    );
  }
}
