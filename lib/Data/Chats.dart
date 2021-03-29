import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String from;
  final int time_stamp;
  final String message;

  ChatModel({this.from = '', this.message = '', this.time_stamp = 0});

  ChatModel.fromJson(Map<String, dynamic> json)
      : from = json['from'],
        message = json['message'],
        time_stamp = json['time_stamp'];

  Map<String, dynamic> toJson() =>
      {'from': from, 'time_stamp': time_stamp, 'message': message};
}

class MainChatsModel {
  final String? chat_id;
  final int? created_at;
  final List chats;
  final List? user_ids;
  final bool is_deleted;
  final int user_unread_count;
  final int rep_unread_count;

  MainChatsModel(
      {this.chat_id,
      this.rep_unread_count = 0,
      this.chats = const [],
      this.user_ids,
      this.user_unread_count = 0,
      this.is_deleted = false,
      this.created_at});

  MainChatsModel.fromJson(Map<String, dynamic> json)
      : chat_id = json['chat_id'],
        chats = json['chats'],
        user_unread_count = json['user_unread_count'],
        is_deleted = json['is_deleted'],
        user_ids = json['user_ids'],
        rep_unread_count = json['rep_unread_count'],
        created_at = json['created_at'];

  Map<String, dynamic> toJson() => {
        'chat_id': chat_id,
        'user_ids': user_ids,
        'is_deleted': is_deleted,
        'rep_unread_count': rep_unread_count,
        'chats': chats,
        'created_at': created_at,
        'user_unread_count': user_unread_count
      };
}
class UnreadModel {
  final String chat_id;
  final int rep_unread_count;
  final List? user_ids;

  UnreadModel({this.chat_id = '', this.user_ids , this.rep_unread_count = 0});

  UnreadModel.fromJson(Map<String, dynamic> json)
      : chat_id = json['chat_id'],
        user_ids = json['message'],
        rep_unread_count = json['rep_unread_count'];

  Map<String, dynamic> toJson() =>
      {'chat_id': chat_id, 'user_ids': user_ids, 'rep_unread_count': rep_unread_count};
}