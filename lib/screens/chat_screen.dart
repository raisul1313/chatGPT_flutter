import 'dart:developer';

import 'package:chatgpt_flutter/constants/constant.dart';
import 'package:chatgpt_flutter/models/chat_model.dart';
import 'package:chatgpt_flutter/providers/chat_provider.dart';
import 'package:chatgpt_flutter/providers/models_provider.dart';
import 'package:chatgpt_flutter/services/api_service.dart';
import 'package:chatgpt_flutter/services/assets_manager.dart';
import 'package:chatgpt_flutter/services/services.dart';
import 'package:chatgpt_flutter/widgets/chat_widget.dart';
import 'package:chatgpt_flutter/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  //List<ChatModel> chatList = [];

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text('ChatGPT'),
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: chatProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      message: chatProvider.getChatList[index].message,
                      //chatList[index].message,
                      chatIndex: chatProvider.getChatList[index]
                          .chatIndex, //chatList[index].chatIndex,
                    );
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],

            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                color: cardColor,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        focusNode: focusNode,
                        onSubmitted: (value) async {
                          await sendMessages(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: 'How can i help you...',
                            hintStyle: TextStyle(color: Colors.grey)),
                      )),
                      IconButton(
                        onPressed: () async {
                          await sendMessages(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }


  Future<void> sendMessages(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: 'You cant send message at a time'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: 'Please type a message'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      String message = textEditingController.text;
      setState(() {
        _isTyping = true;
        //chatList.add(ChatModel(message: textEditingController.text, chatIndex: 0));
        chatProvider.assUserMessage(message: message);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
         chosenModelId: modelsProvider.getCurrentModel, message: message);
      /*chatList.addAll(await ApiService.sendMessage(
          message: textEditingController.text,
          modelId: modelsProvider.getCurrentModel));*/
      setState(() {});
    } catch (error) {
      log('error: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(label: error.toString()),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }
}
