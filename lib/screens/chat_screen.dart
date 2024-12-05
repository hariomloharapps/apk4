import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';
import '../services/api_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';
import '../widgets/typing_indicator.dart';
import '../database/database_helper.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final List<Map<String, dynamic>> _messageHistory = [];
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  bool _isTyping = false;
  bool _isWaitingForResponse = false;
  String? _errorMessage;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    if (_isInitialized) return;

    // Load existing messages from database
    await _loadMessages();

    // If no messages exist, add welcome message
    if (_messages.isEmpty) {
      final welcomeMessage = ChatMessage(
        text: "Hello! How can I help you today?",
        isSent: false,
        timestamp: DateTime.now(),
      );

      await _chatService.saveMessage(welcomeMessage);

      setState(() {
        _messages.add(welcomeMessage);
        _messageHistory.add({
          "content": welcomeMessage.text,
          "isUser": false,
        });
      });
    }

    _isInitialized = true;
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _chatService.loadMessages();
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
        _messageHistory.clear();
        _messageHistory.addAll(messages.map((msg) => {
          'content': msg.text,
          'isUser': msg.isSent,
        }));
      });
    } catch (e) {
      _handleError('Failed to load messages: ${e.toString()}');
    }
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isWaitingForResponse) return;

    setState(() {
      _errorMessage = null;
    });

    final userMessage = ChatMessage(
      text: text,
      isSent: true,
      timestamp: DateTime.now(),
      messageStatus: 'sent',
    );

    try {
      // Save user message to database
      await _chatService.saveMessage(userMessage);

      setState(() {
        _messages.add(userMessage);
        _messageHistory.add({
          'content': text,
          'isUser': true,
        });
        _isWaitingForResponse = true;
        _isTyping = true;
      });
      _scrollToBottom();

      // Send message to API
      final apiResponse = await ApiService.sendMessage(text, _messageHistory);

      if (apiResponse.success) {
        final botMessage = ChatMessage(
          text: apiResponse.message,
          isSent: false,
          timestamp: DateTime.now(),
          messageStatus: 'delivered',
        );

        // Save bot message to database
        await _chatService.saveMessage(botMessage);

        if (mounted) {
          setState(() {
            _isTyping = false;
            _messages.add(botMessage);
            _messageHistory.add({
              'content': apiResponse.message,
              'isUser': false,
            });
            _isWaitingForResponse = false;
          });
          _scrollToBottom();
        }
      } else {
        _handleError(apiResponse.message);
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String error) {
    if (mounted) {
      setState(() {
        _isTyping = false;
        _isWaitingForResponse = false;
        _errorMessage = error;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  Future<void> _clearChat() async {
    try {
      await _chatService.clearChat();
      setState(() {
        _messages.clear();
        _messageHistory.clear();
        _errorMessage = null;
        _isInitialized = false;
      });
      _initializeChat();
    } catch (e) {
      _handleError('Failed to clear chat: ${e.toString()}');
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: MinimalTypingIndicator(),
            ),
          );
        }
        return MessageBubble(message: _messages[index]);
      },
    );
  }

  Widget _buildInputArea() {
    return Column(
      children: [
        if (_errorMessage != null)
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.red.withOpacity(0.1),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: MessageComposer(
            onSubmitted: _handleSubmitted,
            canSend: !_isWaitingForResponse,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreOptionsSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.white),
            title: const Text('Clear Chat'),
            onTap: () {
              _clearChat();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.white),
            title: const Text('View History'),
            onTap: () {
              Navigator.pop(context);
              _showHistoryDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_outlined, color: Colors.white),
            title: const Text('Report Issue'),
            onTap: () {
              Navigator.pop(context);
              _showReportDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chat History'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: _messageHistory.map((msg) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${msg["isUser"] ? "User: " : "Bot: "}${msg["content"]}',
                style: TextStyle(
                  color: msg["isUser"] ? Colors.blue : Colors.white,
                ),
              ),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Issue'),
        content: const Text('Would you like to report an issue with this conversation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement report functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Issue reported')),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2C2C2E),
          secondary: Color(0xFF48484A),
          surface: Color(0xFF1C1C1E),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modern Chat'),
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back_ios_new),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF1C1C1E),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => _buildMoreOptionsSheet(),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF121212),
                const Color(0xFF1C1C1E).withOpacity(0.95),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildMessageList()),
                _buildInputArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}