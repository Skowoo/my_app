import 'package:signalr_core/signalr_core.dart';
import 'package:http/io_client.dart';
import 'dart:io';

class SignalRHelper {
  late final HubConnection connection;

  Future<void> connect(
    String url,
    String roomId,
    void Function(String) onBoardUpdate,
  ) async {
    final httpClient =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    final ioClient = IOClient(httpClient);

    connection =
        HubConnectionBuilder()
            .withUrl('$url/tictactoe', HttpConnectionOptions(client: ioClient))
            .build();

    connection.on('UpdateGameBoard', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        onBoardUpdate(arguments[0] as String);
      }
    });

    await connection.start();
    await connection.invoke('JoinGame', args: [roomId]);
  }

  Future<void> disconnect() async {
    await connection.stop();
  }
}
