import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class Glassbox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Widget child;

  const Glassbox({
    Key? key,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              GlassmorphicContainer(
                child: Center(
                  child: child),
                width: width, 
                height: height, 
                borderRadius: borderRadius, 
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                border: 1.5, 
                blur: 25, 
                borderGradient: 
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.1)
                      ],
                    ),),
            ],
          )),
    );
  }
}
