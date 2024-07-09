import 'package:flutter/material.dart';

class LoginsScreen extends StatelessWidget {
  const LoginsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}


/**
 * 
 * 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: BackgroundForm(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 250),
            // Icon Banner

            Container(
              height: size.height - 260, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const LoginForm(),
            )
          ],
        ),
      ))),
    );
  }
 */