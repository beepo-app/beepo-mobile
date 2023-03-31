// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Messages on MessagesBase, Store {
   final Atom _$conversationsAtom =  Atom(name: 'MessagesBase.conversations');

  @override
  ObservableList<Conversation> get conversations {
    _$conversationsAtom.reportRead();
    return super.conversations;
  }

  @override
  set conversations(ObservableList<Conversation> value) {
    _$conversationsAtom.reportWrite(value, super.conversations, () {
      super.conversations = value;
    });
  }

   final _$messagesAtom =
      Atom(name: 'MessagesBase.messages');

  @override
  ObservableList<DecodedMessage> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<DecodedMessage> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

   final _$MessagesBaseActionController =
      ActionController(name: 'MessagesBase');

  @override
  void setConversations(List<Conversation> conversations) {
    final _$actionInfo = _$MessagesBaseActionController.startAction(
        name: 'MessagesBase.setConversations');
    try {
      return super.setConversations(conversations);
    } finally {
      _$MessagesBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addConversation(Conversation conversation) {
    final _$actionInfo = _$MessagesBaseActionController.startAction(
        name: 'MessagesBase.addConversation');
    try {
      return super.addConversation(conversation);
    } finally {
      _$MessagesBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMessages(List<DecodedMessage> messages) {
    final _$actionInfo = _$MessagesBaseActionController.startAction(
        name: 'MessagesBase.setMessages');
    try {
      return super.setMessages(messages);
    } finally {
      _$MessagesBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addMessage(DecodedMessage message) {
    final _$actionInfo = _$MessagesBaseActionController.startAction(
        name: 'MessagesBase.addMessage');
    try {
      return super.addMessage(message);
    } finally {
      _$MessagesBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
conversations: ${conversations},
messages: ${messages}
    ''';
  }
}
