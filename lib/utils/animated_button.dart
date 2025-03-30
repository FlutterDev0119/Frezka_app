 // import 'package:nb_utils/nb_utils.dart';
//
// import '../colors.dart';
// import 'library.dart';
//
// class AnimatedButton extends StatefulWidget {
//   final VoidCallbak onTap;
//   final String text;
//
//   const AnimatedButton({required this.onTap, required this.text, Key? key})
//       : super(key: key);
//
//   @override
//   _AnimatedButtonState createState() => _AnimatedButtonState();
// }
//
// class _AnimatedButtonState extends State<AnimatedButton>
//     with SingleTickerProviderStateMixin {
//   bool isPressed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) => setState(() => isPressed = true),
//       onTapUp: (_) {
//         setState(() => isPressed = false);
//         widget.onTap();
//       },
//       onTapCancel: () => setState(() => isPressed = false),
//       child: AnimatedScale(
//         scale: isPressed ? 0.90 : 1.0,
//         duration: const Duration(milliseconds: 100),
//         child: Container(
//           width: double.infinity,
//           color: appColorSecondary,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//           alignment: Alignment.center,
//           child: Text(
//             widget.text.toUpperCase(),
//             style: boldTextStyle(size: 12, color: white, letterSpacing: 0.8),
//           ),
//         ),
//       ),
//     );
//   }
// }