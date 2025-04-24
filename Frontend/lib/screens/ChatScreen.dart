import 'package:finance_buddie/Model/ChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_buddie/provider/BuddieProvider.dart';
import 'package:finance_buddie/provider/ThemeProvider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hola, soy tu asistente financiero. ¿En qué puedo ayudarte hoy?",
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<BuddieProvider>(context, listen: false).audioStream.listen((
      audioUrl,
    ) {
      print('Reproduciendo audio: $audioUrl');
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage(BuddieProvider buddieProvider, String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, time: DateTime.now()),
      );
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      print("--------------------------------------");
      await buddieProvider.initiateFinancialChat(text, 'professional');
      print("--------------------------------------");

      if (buddieProvider.financialChat?.response != null) {
        print(2);

        setState(() {
          _messages.add(
            ChatMessage(
              text: buddieProvider.financialChat!.response!,
              isUser: false,
              time: DateTime.now(),
            ),
          );
        });
        print(3);

        _scrollToBottom();
      }
    } catch (e) {
      print('Error al enviar mensaje: $e');
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                'No se pudo conectar con el asistente. Error: ${e.toString()}',
            isUser: false,
            time: DateTime.now(),
            isError: true,
          ),
        );
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final buddieProvider = Provider.of<BuddieProvider>(context);
    final colors = themeProvider;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Center(
                child: Image.asset(
                  'assets/images/buddie_icon.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Column(
            children: [
              _buildAssistantHeader(colors, buddieProvider.isLoading),
              const SizedBox(height: 8),

              // Lista de mensajes
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  reverse: false,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(_messages[index], colors);
                  },
                ),
              ),

              // Campo de entrada de mensaje
              _buildMessageInput(colors, buddieProvider),
            ],
          ),
          if (buddieProvider.isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildAssistantHeader(ThemeProvider colors, bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colors.primaryColor.withOpacity(0.2),
            child: Image.asset('assets/images/buddie_icon.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Finance Buddie',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                ),
                Text(
                  isLoading ? 'Escribiendo...' : 'En línea',
                  style: TextStyle(
                    fontSize: 12,
                    color: isLoading ? colors.accentColor : colors.successColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ThemeProvider colors) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            if (!message.isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    'assets/images/buddie_icon.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    message.isUser
                        ? colors.primaryColor.withOpacity(0.1)
                        : colors.surfaceColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 0),
                  bottomRight: Radius.circular(message.isUser ? 0 : 16),
                ),
                border: Border.all(
                  color:
                      message.isError == true
                          ? colors.errorColor
                          : colors.dividerColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color:
                      message.isError == true
                          ? colors.errorColor
                          : colors.textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
              child: Text(
                DateFormat('h:mm a').format(message.time),
                style: TextStyle(fontSize: 10, color: colors.hintTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(
    ThemeProvider colors,
    BuddieProvider buddieProvider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        border: Border(top: BorderSide(color: colors.dividerColor, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                hintStyle: TextStyle(color: colors.hintTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colors.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (text) {
                _sendMessage(buddieProvider, text);
              },
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: colors.primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  _sendMessage(buddieProvider, _messageController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

