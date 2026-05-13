import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? _socket;

  final StreamController<List<Map<String, dynamic>>> _messagesController =
  StreamController<List<Map<String, dynamic>>>.broadcast();

  final StreamController<Map<String, dynamic>> _chatMessageController =
  StreamController<Map<String, dynamic>>.broadcast();

  List<Map<String, dynamic>> _messages = [];

  Stream<List<Map<String, dynamic>>> get messagesStream =>
      _messagesController.stream;

  Stream<Map<String, dynamic>> get chatMessageStream =>
      _chatMessageController.stream;

  void connect({
    required String serverUrl,
    required String userId,
  }) {
    if (_socket != null) return;

    _socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'userId': userId})
          .build(),
    );

    _socket!.onConnect((_) {
      print('Socket connected: ${_socket!.id}');
      _socket!.emit('join_messages_home', {'userId': userId});
      _socket!.emit('get_message_home', {'userId': userId});
    });

    _socket!.onConnectError((data) {
      print('Socket connect error: $data');
    });

    _socket!.onError((data) {
      print('Socket error: $data');
    });

    _socket!.onDisconnect((_) {
      print('Socket disconnected');
    });

    _socket!.on('message_list', (data) {
      print('message_list received: $data');

      if (data is List) {
        _messages = data
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();

        _messagesController.add(List<Map<String, dynamic>>.from(_messages));
      }
    });

    _socket!.on('new_message_preview', (data) {
      print('new_message_preview received: $data');

      final preview = Map<String, dynamic>.from(data as Map);
      _messages.removeWhere((item) => item['chatId'] == preview['chatId']);
      _messages.insert(0, preview);
      _messagesController.add(List<Map<String, dynamic>>.from(_messages));
    });

    _socket!.on('new_message', (data) {
      print('new_message received: $data');
      _chatMessageController.add(Map<String, dynamic>.from(data as Map));
    });

    _socket!.connect();
  }

  void requestMessageHome(String userId) {
    _socket?.emit('get_message_home', {'userId': userId});
  }

  void joinChat(String chatId) {
    _socket?.emit('join_chat', {'chatId': chatId});
  }

  void leaveChat(String chatId) {
    _socket?.emit('leave_chat', {'chatId': chatId});
  }

  void sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) {
    _socket?.emit('send_message', {
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
    });
  }

  Future<void> disconnect() async {
    _socket?.dispose();
    _socket = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _messagesController.close();
    await _chatMessageController.close();
  }
}
