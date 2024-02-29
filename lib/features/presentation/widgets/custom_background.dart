//import 'dart:math' show pi;
import 'package:flutter/material.dart';

class GymBackground extends StatelessWidget {
  final Widget child;
  const GymBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final borderSize = size.width / 7; // Este es el tamaño para colocar 7 elementos

    final gymWidgets = [
      _Dumbbell(borderSize),
      _WeightScale(borderSize),
      _Treadmill(borderSize),
      _YogaMat(borderSize),
      _WaterBottle(borderSize),
      _GymBag(borderSize),
      _JumpRope(borderSize),
    ];

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(child: Container(color: backgroundColor)),

          // Background with gym elements
          Container(
              height: size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                children: [
                  GymElementRow(gymWidgets: gymWidgets),
                  GymElementRow(gymWidgets: gymWidgets),
                  GymElementRow(gymWidgets: gymWidgets),
                  GymElementRow(gymWidgets: gymWidgets),
                  GymElementRow(gymWidgets: gymWidgets),
                  GymElementRow(gymWidgets: gymWidgets),
                  GymElementRow(gymWidgets: gymWidgets),
                ],
              )),

          // Child widget
          child,
        ],
      ),
    );
  }
}

class GymElementRow extends StatefulWidget {
  const GymElementRow({
    Key? key,
    required this.gymWidgets,
  }) : super(key: key);

  final List<Widget> gymWidgets;

  @override
  State<GymElementRow> createState() => _GymElementRowState();
}

class _GymElementRowState extends State<GymElementRow> {
  late List<Widget> gymMixedUp;

  @override
  void initState() {
    super.initState();
    gymMixedUp = [...widget.gymWidgets];
    gymMixedUp.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: gymMixedUp);
  }
}

class _Dumbbell extends StatelessWidget {
  final double borderSize;

  const _Dumbbell(this.borderSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: borderSize,
      height: borderSize / 2,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.fitness_center, color: Colors.black),
    );
  }
}

class _WeightScale extends StatelessWidget {
  final double borderSize;

  const _WeightScale(this.borderSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: borderSize,
      height: borderSize,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.scale, color: Colors.black),
    );
  }
}

class _Treadmill extends StatelessWidget {
  final double borderSize;

  const _Treadmill(this.borderSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: borderSize * 1.5,
      height: borderSize / 2,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.directions_walk, color: Colors.black),
    );
  }
}

class _YogaMat extends StatelessWidget {
  final double borderSize;

  const _YogaMat(this.borderSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: borderSize * 2,
      height: borderSize / 2,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.spa, color: Colors.black),
    );
  }
}

class _WaterBottle extends StatelessWidget {
  final double borderSize;

  const _WaterBottle(this.borderSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: borderSize / 2,
      height: borderSize,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.local_drink, color: Colors.black),
    );
  }
}

class _GymBag extends StatelessWidget {
  final double borderSize;

  const _GymBag(this.borderSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: borderSize,
      height: borderSize,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.sports_basketball, color: Colors.black),
    );
  }
}

class _JumpRope extends StatelessWidget {
  final double borderSize;

  const _JumpRope(this.borderSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: borderSize * 2,
      height: borderSize / 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.accessibility, color: Colors.black),
    );
  }
}
