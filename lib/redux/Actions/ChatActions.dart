import 'package:selfcare/Data/Chats.dart';

class ChatAction {
  String? user_id;

  ChatAction({this.user_id});
}

class ChatActionSuccess {
  MainChatsModel? mainChatsModel;

  ChatActionSuccess({this.mainChatsModel});
}

class UnreadAction {
  UnreadAction();
}

class UnreadActionSuccess {
  List<UnreadModel> unreads;

  UnreadActionSuccess({this.unreads = const <UnreadModel>[]});
}
