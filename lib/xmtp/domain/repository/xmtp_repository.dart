import 'package:web3dart/credentials.dart';
import 'package:xmtp/xmtp.dart';

abstract class XmtpRepository {
  Future<DecodedMessage> sendMessage(Conversation conversation, String content);

  Future<DecodedMessage> sendMessageToAddress(String address, String content);

  Future<List<Conversation>> getConversations();

  Future<List<DecodedMessage>> getMessages(Conversation conversation);

  Future<List<DecodedMessage>> getMessagesWithAddress(String address);

  Stream<Conversation> streamConversations();

  Stream<DecodedMessage> streamMessages(Conversation conversation);

  Future<Stream<DecodedMessage>> streamMessagesWithAddress(String address);

  Future<Conversation> createConversation(String address);

  EthereumAddress getMyAddress();

  Future<DecodedMessage> getLastMessage(Conversation conversation);
}
