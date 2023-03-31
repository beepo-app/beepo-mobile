import 'package:mobx/mobx.dart';
import 'package:xmtp/xmtp.dart';

part 'messages_store.g.dart';

class Messages = MessagesBase with _$Messages;

abstract class MessagesBase with Store {
  @observable
  ObservableList<Conversation> conversations = ObservableList.of([]);

  @action
  void setConversations(List<Conversation> conversations) {
    this.conversations = ObservableList.of(conversations);
  }

  @action
  void addConversation(Conversation conversation) {
    conversations.insert(0, conversation);
  }

  @observable
  ObservableList<DecodedMessage> messages = ObservableList.of([]);

  @action
  void setMessages(List<DecodedMessage> messages) {
    this.messages = ObservableList.of(messages);
  }

  @action
  void addMessage(DecodedMessage message) {
    messages.insert(0, message);
  }
}

final Messages store = Messages();
