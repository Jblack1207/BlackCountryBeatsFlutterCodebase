import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  final StreamController<List<Map<String, dynamic>>> _messagesController =
  StreamController<List<Map<String, dynamic>>>.broadcast();

  List<Map<String, dynamic>> _messages = [];

  Stream<List<Map<String, dynamic>>> get messagesStream =>
      _messagesController.stream;

  void connect({
    required String serverUrl,
    required String userId,
  }) {
    if (_socket != null) return;

    _socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'userId': userId})
          .build(),
    );

    _socket!.onConnect((_) {
      _socket!.emit('join_messages_home', {'userId': userId});
    });

    _socket!.on('message_list', (data) {
      if (data is List) {
        _messages = data
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
        _messagesController.add(_messages);
      }
    });

    _socket!.on('new_message_preview', (data) {
      final preview = Map<String, dynamic>.from(data as Map);
      _messages.removeWhere((item) => item['chatId'] == preview['chatId']);
      _messages.insert(0, preview);
      _messagesController.add(List<Map<String, dynamic>>.from(_messages));
    });

    _socket!.onDisconnect((_) {});

    _socket!.connect();
  }

  void requestMessageHome(String userId) {
    _socket?.emit('get_message_home', {'userId': userId});
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _messagesController.close();
  }
}
