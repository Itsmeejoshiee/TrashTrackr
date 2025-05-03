import 'package:flutter/material.dart';

class NeoBox extends StatelessWidget {
  const NeoBox({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(1.00, 1.00),
          colors: [Colors.white, Color(0xFFF2F2F2)],
        ),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0xE5E0E0E0),
            blurRadius: 13,
            offset: Offset(5, 5),
          ),
          BoxShadow(
            color: Color(0xE5FFFFFF),
            blurRadius: 10,
            offset: Offset(-5, -5),
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(5, -5),
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(-5, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
