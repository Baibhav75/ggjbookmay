import 'dart:math';
import 'package:flutter/material.dart';

class SchoolLoader extends StatefulWidget {
  final double size;
  final Color color;

  const SchoolLoader({
    super.key,
    this.size = 60,
    this.color = Colors.indigo,
  });

  @override
  State<SchoolLoader> createState() => _SchoolLoaderState();
}

class _SchoolLoaderState extends State<SchoolLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int dotCount = 8;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// 📚 CENTER ICON (BOOK)
          Icon(
            Icons.menu_book,
            size: widget.size / 2,
            color: widget.color,
          ),

          /// 🔄 ROTATING DOTS
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: List.generate(dotCount, (index) {
                  final angle = (2 * pi / dotCount) * index;

                  final progress =
                  (_controller.value * dotCount - index)
                      .clamp(0.0, 1.0);

                  final scale = 0.4 + (0.6 * progress);

                  return Transform.translate(
                    offset: Offset(
                      cos(angle) * (widget.size / 2.3),
                      sin(angle) * (widget.size / 2.3),
                    ),
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: widget.size / 10,
                        height: widget.size / 10,
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(progress),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}