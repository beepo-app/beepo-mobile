import 'package:web3dart/credentials.dart';
import 'package:xmtp/xmtp.dart';

import '../../domain/repository/xmtp_repository.dart';
import '../xmtp/session.dart';

class XmtpRepositoryImpl implements XmtpRepository {
   Session _session;

  XmtpRepositoryImpl( _session, {Session session}) {
    _session = session;
  }

  @override
  Future<DecodedMessage> sendMessage(
      Conversation conversation, String content) {
    return _session.client.sendMessage(conversation, content);
  }

  @override
  Future<DecodedMessage> sendMessageToAddress(
      String address, String content) async {
    var conversation = await _session.client.newConversation(address);
    return _session.client.sendMessage(conversation, content);
  }

  @override
  Future<List<Conversation>> getConversations() {
    return _session.client.listConversations();
  }

  @override
  Future<List<DecodedMessage>> getMessages(Conversation conversation) {
    return _session.client.listMessages(conversation);
  }

  @override
  Future<List<DecodedMessage>> getMessagesWithAddress(String address) async {
    var conversation = await _session.client.newConversation(address);
    return _session.client.listMessages(conversation);
  }

  @override
  Stream<Conversation> streamConversations() {
    return _session.client.streamConversations();
  }

  @override
  Stream<DecodedMessage> streamMessages(Conversation conversation) {
    return _session.client.streamMessages(conversation);
  }

  @override
  Future<Stream<DecodedMessage>> streamMessagesWithAddress(
      String address) async {
    var conversation = await _session.client.newConversation(address);
    return _session.client.streamMessages(conversation);
  }

  @override
  Future<Conversation> createConversation(String address) {
    return _session.client.newConversation(address);
  }

  @override
  EthereumAddress getMyAddress() {
    return _session.client.address;
  }

  @override
  Future<DecodedMessage> getLastMessage(Conversation conversation) async {
    var messages = await _session.client.listMessages(
      conversation,
      limit: 1,
      sort: SortDirection.SORT_DIRECTION_DESCENDING,
    );
    if (messages.isNotEmpty) {
      return messages.first;
    }

    return null;
  }
}
