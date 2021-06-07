// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.

import 'package:student_side/model/chat_user.dart';

class ChatPageArgs {
  final User user;
  final User me;

  ChatPageArgs(this.me, this.user);
}
