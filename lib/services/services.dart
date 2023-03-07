import 'package:chatgpt_flutter/constants/constant.dart';
import 'package:chatgpt_flutter/widgets/drop_down.dart';
import 'package:chatgpt_flutter/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: TextWidget(
                    label: 'Chosen Model',
                    fontSize: 16,
                  ),
                ),
                Flexible(
                  flex: 2,
                    child: DropDownWidget()),
              ],
            ),
          );
        });
  }
}
