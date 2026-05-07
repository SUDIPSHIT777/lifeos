import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:lifeos/feature/dashboard/controller/dashprovider.dart';
import 'package:provider/provider.dart';
import 'package:lifeos/feature/ai_assistant/controller/deepsheekprovider.dart';

class AiassistentPage extends StatefulWidget {
  const AiassistentPage({super.key});

  @override
  State<AiassistentPage> createState() => _AiassistentPageState();
}

class _AiassistentPageState extends State<AiassistentPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(BuildContext context) {
    if (_controller.text.trim().isEmpty) return;

    final provider = Provider.of<Deepsheekprovider>(context, listen: false);
    provider.sendMessage(_controller.text.trim());
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Userprovider>().loaduserdata();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Consumer<Userprovider>(
          builder: (context, user, child) => Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Text(
                user.gettime,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                  fontSize: 15,
                ),
              ),
              Text(
                user.username,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Consumer<Deepsheekprovider>(
        builder: (context, provider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              );
            }
          });
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    return _buildChatBubble(message);
                  },
                ),
              ),
              if (provider.loading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI is typing...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              _buildInputArea(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                )
              : const LinearGradient(colors: [Colors.white, Colors.white]),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: isUser ? Colors.white : const Color(0xFF1F2937),
            fontSize: 15,
            height: 1.4,
          ),
          child: GptMarkdown(
            message.text,
            style: TextStyle(
              color: isUser ? Colors.white : const Color(0xFF1F2937),
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(context),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _sendMessage(context),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x4D2563EB),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
