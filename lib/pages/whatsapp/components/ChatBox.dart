import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';

class ChatBox extends StatefulWidget {
  final Function(String str) onSubmit;

  const ChatBox({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: grey_600,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Say something...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13.0),
                ),
                onSubmitted: (value) {
                  _sendMessage();
                },
              ),
            ),
            const SizedBox(width: 8),
            Visibility(
              visible: true, //accessBox.get("Whatsapp")!.accessItems![0].isActive.toString() == "1",
              child: InkWell(
                onTap: _sendMessage,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: const Icon(
                    Icons.send,
                    size: 40.0,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = textEditingController.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmit(text); // Call the onSubmit callback
      textEditingController.clear(); // Clear the text field
    }
  }
}
