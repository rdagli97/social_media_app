import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/resources/chat_methods.dart';
import 'package:event_app/utils/add_space.dart';
import 'package:event_app/widgets/chat_bubble.dart';
import 'package:event_app/widgets/custom_text.dart';
import 'package:event_app/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String recieverUserId;
  final String recieverUserUsername;
  const ChatScreen({
    super.key,
    required this.recieverUserId,
    required this.recieverUserUsername,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatMethods _chatMethods = ChatMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatMethods.sendMessage(
        widget.recieverUserId,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatMethods.getMessages(
          _auth.currentUser!.uid, widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const CustomText(text: 'Some error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the message
    var alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            ChatBubble(
              message: data['message'],
              emailText: data['senderEmail'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          // textfield
          Expanded(
            child: CustomTextfield(
              controller: _messageController,
              hintText: 'Enter a message',
            ),
          ),
          // send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_circle_up_rounded),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: widget.recieverUserUsername,
        ),
      ),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),
          // user input
          _buildMessageInput(),
          addVerticalSpace(20),
        ],
      ),
    );
  }
}
