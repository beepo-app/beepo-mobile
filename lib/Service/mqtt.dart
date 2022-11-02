import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void connect() async {
  final client = MqttServerClient('wss://test.mosquitto.org', '');
  try {
    client.useWebSocket = true;
    client.port = 8081;
    client.logging(on: false);
    await client.connect();
    client.subscribe('channels/clients/retrieve-address-balance', MqttQos.atMostOnce);
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    print('EXAMPLE::client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    print('EXAMPLE::socket exception - $e');
    client.disconnect();
  }
}
