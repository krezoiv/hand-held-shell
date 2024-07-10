import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController? textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomInput({
    super.key,
    required this.icon,
    required this.placeholder,
    this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5,
              )
            ],
          ),
          child: TextFormField(
            controller: textController,
            autocorrect: false,
            keyboardType: keyboardType,
            obscureText: isPassword,
            validator: validator,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: placeholder,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';

// class CustomInput extends StatelessWidget {
//   final IconData icon;
//   final String placeholder;
//   final TextEditingController textController;
//   final TextInputType keyboardType;
//   final bool isPassword;

//   const CustomInput({
//     super.key,
//     required this.icon,
//     required this.placeholder,
//     required this.textController,
//     this.keyboardType = TextInputType.text,
//     this.isPassword = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         return Container(
//           width: constraints.maxWidth, // Usa el ancho máximo disponible
//           padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
//           margin: const EdgeInsets.only(bottom: 20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: <BoxShadow>[
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 offset: const Offset(0, 5),
//                 blurRadius: 5,
//               )
//             ],
//           ),
//           child: TextField(
//             controller: textController,
//             autocorrect: false,
//             keyboardType: keyboardType,
//             obscureText: isPassword,
//             decoration: InputDecoration(
//               prefixIcon: Icon(icon),
//               focusedBorder: InputBorder.none,
//               border: InputBorder.none,
//               hintText: placeholder,
//               // Ajusta el contentPadding si es necesario
//               contentPadding: const EdgeInsets.symmetric(vertical: 15),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
