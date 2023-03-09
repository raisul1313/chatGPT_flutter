import 'package:chatgpt_flutter/models/chat_model.dart';
import 'package:chatgpt_flutter/services/api_service.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatList {
    return chatList;
  }

  void assUserMessage({required String message}) {
    chatList.add(ChatModel(message: message, chatIndex: 0));
    notifyListeners();
  }

  /*Future<void> sendMessageAndGetAnswer(
      {required String message, required String chosenModelId}) async {
    chatList.addAll(
      await ApiService.sendMessage(
        message: message,
        modelId: chosenModelId,
      ),
    );
    notifyListeners();
  }*/


  Future<void> sendMessageAndGetAnswers(
      {required String message, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: message,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiService.sendMessage(
        message: message,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }

}
