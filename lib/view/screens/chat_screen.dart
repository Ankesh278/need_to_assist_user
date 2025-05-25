import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import '../../providers/socket_service.dart';
class ChatPage extends StatefulWidget {
  final String userId;
  const ChatPage({super.key, required this.userId});
  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  @override
  void initState() {
    super.initState();
    SocketService().connect();
    Future.delayed(Duration(seconds: 2), () {
      if (SocketService().isConnected()) {
        if (kDebugMode) {
          print('Connected to socket server');
        }
      } else {
        if (kDebugMode) {
          print('Not connected to socket server');
        }
      }
    });
    SocketService().onMessage((data) {
      setState(() {
        _messages.add(data);
      });
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }


  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final messageData = {
        'senderId': widget.userId,
        'message': text,
        'timestamp': DateTime.now().toIso8601String(),
      };
      SocketService().sendMessage(text, widget.userId);
      setState(() {
        _messages.add(messageData);
      });
      _controller.clear();
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Widget buildChatBubble(Map<String, dynamic> message) {
    final isMe = message['senderId'] == widget.userId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ChatBubble(
        clipper: ChatBubbleClipper1(
          type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble,
        ),
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        margin: EdgeInsets.only(top: 5),
        backGroundColor: isMe ? Colors.black54 : Colors.grey.shade300,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Text(
            message['message'],
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Chat",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black54,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                return buildChatBubble(_messages[index]);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.black54),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



