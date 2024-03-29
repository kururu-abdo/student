import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_side/model/comment_model.dart';

class CommentBloc {
  static Future<String> getCommentDocumentId(String object_id) async {}
  static Future<List<CommentModel>> getObjectComments(String object_id) async {
    List<CommentModel> comments = [];
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('comments')
        .where('object_id', isEqualTo: object_id)
        .get();

    if (data.docs.isNotEmpty) {
      comments = data.docs
          .map((comment) => CommentModel.fromJson(comment.data()))
          .toList();
    }

    return comments;
  }
}
