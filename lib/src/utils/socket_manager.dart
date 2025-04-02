
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class SocketManager {
  socket_io.Socket? socketProvider;
  String clientReference;

  SocketManager({required this.clientReference}) {
    socketProvider = socket_io.io(
      'https://realtime-socket.hubtel.com',
      socket_io.OptionBuilder().setTransports(['websocket', 'polling']).build(),
    );

    socketProvider?.on('connect', (handler) {
      joinRoom(clientReference);
    });
  }

  void joinRoom(String clientReference) {
    final channel = Channel(
      data: Data(
        message: "",
        roomId: "",
        roomChannel: clientReference,
      ),
      time: DateTime.now().toString(),
      clientId: socketProvider?.id ?? '',
      source: Source(
        platform: "Mobile",
        appName: "Hubtel In app call merchant",
        appVersion: "app_version",
        clientId: "client_id",
        userName: "user_name",
        channel: "channel",
      ),
    );

    socketProvider?.emit("join-channel", channel.toJson());
  }

  void listen(String eventId, {required Function(String) onEventListened}) {
    socketProvider?.on(eventId, (event) {
      onEventListened.call("event_emited");
    });
  }

  void disposeSocket() {
    socketProvider?.dispose();
  }
}

class Channel {
  final Data data;
  final String time;
  final String clientId;
  final Source source;

  Channel({
    required this.data,
    required this.time,
    required this.clientId,
    required this.source,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      data: Data.fromJson(json['data']),
      time: json['time'],
      clientId: json['clientId'],
      source: Source.fromJson(json['source']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'time': time,
      'clientId': clientId,
      'source': source.toJson(),
    };
  }
}

class Data {
  final String message;
  final String? roomId;
  final String roomChannel;

  Data({
    required this.message,
    this.roomId,
    required this.roomChannel,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      message: json['message'],
      roomId: json['roomId'],
      roomChannel: json['roomChannel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'roomId': roomId,
      'roomChannel': roomChannel,
    };
  }
}

class Source {
  final String platform;
  final String appName;
  final String appVersion;
  final String clientId;
  final String userName;
  final String channel;

  Source({
    required this.platform,
    required this.appName,
    required this.appVersion,
    required this.clientId,
    required this.userName,
    required this.channel,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      platform: json['platform'],
      appName: json['appName'],
      appVersion: json['appVersion'],
      clientId: json['clientId'],
      userName: json['userName'],
      channel: json['channel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'appName': appName,
      'appVersion': appVersion,
      'clientId': clientId,
      'userName': userName,
      'channel': channel,
    };
  }
}
