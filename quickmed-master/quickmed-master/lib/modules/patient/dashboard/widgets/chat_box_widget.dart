import 'package:flutter/material.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

class ChatBoxWidget extends StatelessWidget {
  final String chat;
  final bool isReceived;

  const ChatBoxWidget({required this.chat, this.isReceived = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: 290,
          child: Align(
            alignment: isReceived
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isReceived?QColors.lightGray400:QColors.chartreuse700,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Text(
                  chat,
                  style: TAppTextStyle.inter(
                    color: QColors.lightBackground,
                    fontSize: 20,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
