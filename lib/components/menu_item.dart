import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.iconColor,
  });

  final String text;
  final IconData icon;
  final void Function()? onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 214, 212, 212), // 그림자 색상
                  spreadRadius: 0, // 그림자 확산 정도
                  blurRadius: 3, // 그림자 흐림 정도
                  offset: Offset(0, 0), // 그림자 위치 (가로, 세로)
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 0, // 그림자 높이 조정
                backgroundColor: Colors.white,
              ),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 35,
                      color: iconColor,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        text,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(221, 46, 46, 46),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
