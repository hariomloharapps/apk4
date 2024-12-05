import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MessageComposerDemo(),
    );
  }
}

class Message {
  final String text;
  final bool isSentByMe;
  final String? imageUrl;

  Message(this.text, this.isSentByMe, {this.imageUrl});
}

class MessageComposerDemo extends StatefulWidget {
  const MessageComposerDemo({super.key});

  @override
  State<MessageComposerDemo> createState() => _MessageComposerDemoState();
}

class _MessageComposerDemoState extends State<MessageComposerDemo> {
  bool _canSend = true;
  final List<Message> _messages = [
    Message("Hi! I can help with conversation and generate images.", false),
    Message("Can you show me a picture of a sunset?", true),
    Message(
      "Here's a beautiful sunset image I generated for you:",
      false,
      imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
    ),
  ];

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(Message(text, true));
        _canSend = false;
      });

      // Simulate 5-second API delay
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _messages.add(Message(
            "This is a demo response!",
            false,
            imageUrl: text.toLowerCase().contains('picture') ||
                text.toLowerCase().contains('image')
                ? "https://images.unsplash.com/photo-1507525428034-b723cf961d3e"
                : null,
          ));
          _canSend = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.android),
            SizedBox(width: 8),
            Text('AI Chat with Image Generation'),
          ],
        ),
        backgroundColor: const Color(0xFF1C1C1E),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFF1C1C1E),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(
                    message: message.text,
                    isSentByMe: message.isSentByMe,
                    imageUrl: message.imageUrl,
                  );
                },
              ),
            ),
          ),
          MessageComposer(
            onSubmitted: _handleSubmitted,
            canSend: _canSend,
          ),
        ],
      ),
    );
  }
}

class ImageContainer extends StatefulWidget {
  final String imageUrl;

  const ImageContainer({
    super.key,
    required this.imageUrl,
  });

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  bool _isBlurred = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _isLoading
                    ? ShimmerLoading(
                  width: double.infinity,
                  height: 200,
                )
                    : ImageFiltered(
                  imageFilter: _isBlurred
                      ? ImageFilter.blur(sigmaX: 15, sigmaY: 15)
                      : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            if (!_isLoading)
              Positioned(
                top: 16,
                right: 8,
                child: Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        _isBlurred = !_isBlurred;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isBlurred ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFF2C2C2E),
                Color(0xFF3C3C3E),
                Color(0xFF2C2C2E),
              ],
              stops: [
                0.0,
                _controller.value,
                1.0,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Placeholder mountains
              CustomPaint(
                size: Size(widget.width, widget.height),
                painter: MountainsPainter(
                  progress: _controller.value,
                ),
              ),
              // Loading text
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Generating image${'..' * (((_controller.value * 3) % 3).floor() + 1)}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MountainsPainter extends CustomPainter {
  final double progress;

  MountainsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3C3C3E)
      ..style = PaintingStyle.fill;

    final path = Path();

    // First mountain
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.6);
    path.lineTo(size.width * 0.3, size.height * 0.3);
    path.lineTo(size.width * 0.5, size.height * 0.7);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.close();

    // Animate the mountain path
    final animatedPath = Path();
    for (double i = 0; i <= progress; i += 0.01) {
      final x = size.width * i;
      final y = path.computeMetrics()
          .first
          .getTangentForOffset(path.computeMetrics().first.length * i)
          ?.position
          .dy ?? 0;
      if (i == 0) {
        animatedPath.moveTo(x, y);
      } else {
        animatedPath.lineTo(x, y);
      }
    }
    animatedPath.lineTo(size.width * progress, size.height);
    animatedPath.lineTo(0, size.height);
    animatedPath.close();

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(MountainsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// MessageBubble and MessageComposer classes remain the same as in your original code
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final String? imageUrl;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: isSentByMe
                  ? const Color(0xFF007AFF)
                  : const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isSentByMe ? 16 : 0),
                bottomRight: Radius.circular(isSentByMe ? 0 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                if (imageUrl != null)
                  ImageContainer(imageUrl: imageUrl!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageComposer extends StatefulWidget {
  final Function(String) onSubmitted;
  final bool canSend;

  const MessageComposer({
    super.key,
    required this.onSubmitted,
    required this.canSend,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController _messageController = TextEditingController();
  bool _hasText = false;
  final Color _sendButtonColor = const Color(0xFF007AFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                onChanged: (text) {
                  setState(() {
                    _hasText = text.trim().isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: widget.canSend
                      ? 'Type a message'
                      : 'Waiting for response...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    final bool canSendNow = _hasText && widget.canSend;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: canSendNow
                ? _sendButtonColor
                : const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(14),
            boxShadow: canSendNow ? [
              BoxShadow(
                color: _sendButtonColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: canSendNow
                  ? () {
                widget.onSubmitted(_messageController.text);
                _messageController.clear();
                setState(() => _hasText = false);
              }
                  : null,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.send_rounded,
                  color: canSendNow
                      ? Colors.white
                      : Colors.grey[600],
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        if (!widget.canSend && _hasText)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}