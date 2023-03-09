import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_flutter/constants/constant.dart';
import 'package:chatgpt_flutter/widgets/text_widget.dart';
import 'package:chatgpt_flutter/services/assets_manager.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key? key,
    required this.message,
    required this.chatIndex,
  }) : super(key: key);

  final String message;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: chatIndex == 0
                        ? TextWidget(
                            label: message,
                          )
                        : DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0.0,8.0,20.0,8.0),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                repeatForever: false,
                                displayFullTextOnTap: true,
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    textAlign: TextAlign.justify,
                                    message.trim(),
                                  )
                                ],
                              ),
                            ),
                          )),
               /* chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          )
                        ],
                      )*/
              ],
            ),
          ),
        )
      ],
    );
  }
}
