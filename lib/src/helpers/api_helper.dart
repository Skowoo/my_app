import 'package:http/http.dart' as http;
import 'package:my_app/src/logic/app_state.dart';

class ApiHelper {
  static Future<({String playerCharacter, String roomId})> getRandomRoomId(
    AppState state,
  ) async {
    var response = await http.post(
      Uri.parse('${state.backendRestUrl}/TicTacToeGame/JoinRoom'),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return (
        playerCharacter: response.body[0],
        roomId: response.body.substring(1),
      );
    } else {
      throw Exception(
        'Failed to fetch data from API, status code: ${response.statusCode}',
      );
    }
  }
}
