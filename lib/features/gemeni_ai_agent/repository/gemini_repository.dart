// item_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:robot_display_v2/data/const.dart';
import 'package:robot_display_v2/data/model/failure.dart';
import 'package:robot_display_v2/provider/post_request.dart';

class GemininRepository {
  GemininRepository();
  Future<Either<Failure, String>> addAttribute(config) {
    return postRequest(endpoint: '$url/gemini/', data: config);
  }
}
