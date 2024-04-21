import 'package:flutter/material.dart';
import 'dart:math';

class ParallaxSun extends StatefulWidget {
  ParallaxSun({
    this.key,
    this.numberOfSunrays = 25,
    this.sunrayLength = 50,
    this.sunrayColors = const [Colors.yellow],
    this.trailStartFraction = 0.3,
    this.distanceBetweenLayers = 1,
    this.child,
    this.sunIsInBackground = true,
    this.trail = false,
  })  : assert(
          sunrayColors.isNotEmpty,
          "The sunray colors list cannot be empty",
        ),
        assert(
          distanceBetweenLayers > 0,
          "The distance between layers cannot be 0, try setting the number of layers to 1 instead",
        ),
        super(key: key);

  @override
  // ignore: overridden_fields
  final Key? key;

  final int numberOfSunrays;

  final double sunrayLength;

  final List<Color> sunrayColors;

  final double trailStartFraction;

  final double distanceBetweenLayers;

  final bool sunIsInBackground;

  final bool trail;

  final Widget? child;

  @override
  State<StatefulWidget> createState() {
    return ParallaxSunState();
  }
}

class ParallaxSunState extends State<ParallaxSun> {
  final ValueNotifier notifier = ValueNotifier(false);
  // ignore: prefer_typing_uninitialized_variables
  late final parallaxSunPainter;

  runAnimation() async {
    while (true) {
      notifier.value = !notifier.value;
      await Future.delayed(const Duration());
    }
  }

  @override
  void initState() {
    super.initState();
    runAnimation();
    parallaxSunPainter = ParallaxSunPainter(
      numberOfSunrays: widget.numberOfSunrays,
      sunrayLength: widget.sunrayLength,
      sunrayColors: widget.sunrayColors,
      trailStartFraction: widget.trailStartFraction,
      distanceBetweenLayers: widget.distanceBetweenLayers,
      notifier: notifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: (widget.sunIsInBackground) ? parallaxSunPainter : null,
        foregroundPainter: (widget.sunIsInBackground) ? null : parallaxSunPainter,
        child: Container(
          child: widget.child,
        ),
      ),
    );
  }
}

class ParallaxSunPainter extends CustomPainter {
  final int numberOfSunrays;
  List<Sunray> sunrayList = <Sunray>[];
  late Paint paintObject;
  final double sunrayLength;
  final List<Color> sunrayColors;
  final double trailStartFraction;
  final double distanceBetweenLayers;
  late final ValueNotifier notifier;
  Random random = Random();

  ParallaxSunPainter({
    required this.numberOfSunrays,
    required this.sunrayLength,
    required this.sunrayColors,
    required this.trailStartFraction,
    required this.distanceBetweenLayers,
    required this.notifier,
  }) : super(repaint: notifier);

  void initialize(Canvas canvas, Size size) {
    paintObject = Paint()
      ..color = sunrayColors[0]
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (int i = 0; i < numberOfSunrays; i++) {
      double angle = random.nextDouble() * 2 * pi;
      double startX = size.width / 2 + cos(angle) * (size.width / 4);
      double startY = size.height / 2 + sin(angle) * (size.height / 4);
      double endX = startX + cos(angle) * sunrayLength;
      double endY = startY + sin(angle) * sunrayLength;
      sunrayList.add(
        Sunray(
          start: Offset(startX, startY),
          end: Offset(endX, endY),
          color: sunrayColors[random.nextInt(sunrayColors.length)],
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (sunrayList.isEmpty) {
      initialize(canvas, size);
    }

    for (int i = 0; i < numberOfSunrays; i++) {
      canvas.drawLine(
        sunrayList[i].start,
        sunrayList[i].end,
        paintObject,
      );
    }
  }

  @override
  bool shouldRepaint(ParallaxSunPainter oldDelegate) => true;
}

/// Model class for sunrays in ParallaxSun
class Sunray {
  /// The start point of the sunray
  final Offset start;

  /// The end point of the sunray
  final Offset end;

  /// The color of the sunray
  final Color color;

  Sunray({
    required this.start,
    required this.end,
    required this.color,
  });
}
