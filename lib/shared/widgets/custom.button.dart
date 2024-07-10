import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.black,
        shape: const StadiumBorder(),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: height ?? 55,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize ?? 17,
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final void Function()? onPressed;
//   const CustomButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.black,
//         shape: const StadiumBorder(),
//         elevation: 2,
//       ),
//       onPressed: onPressed,
//       child: SizedBox(
//         width: double.infinity,
//         height: 55,
//         child: Center(
//           child: Text(
//             text,
//             style: const TextStyle(color: Colors.white, fontSize: 17),
//           ),
//         ),
//       ),
//     );
//   }
// }
