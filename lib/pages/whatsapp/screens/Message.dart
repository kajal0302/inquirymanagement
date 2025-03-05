import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/whatsapp/apicall/fetchContactMessage.dart';
import 'package:inquirymanagement/pages/whatsapp/apicall/whatsappTextMessageSend.dart';
import 'package:inquirymanagement/pages/whatsapp/components/ChatBox.dart';
import 'package:inquirymanagement/pages/whatsapp/components/ReciverChat.dart';
import 'package:inquirymanagement/pages/whatsapp/components/SenderChat.dart';
import 'package:inquirymanagement/pages/whatsapp/models/MessageModel.dart';
import 'package:inquirymanagement/pages/whatsapp/models/TemplateListModel.dart';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:intl/intl.dart';

class Message extends StatefulWidget {
  final String name;
  final String id;
  final String contactId;
  final String wpId;

  const Message(
      {super.key,
      required this.name,
      required this.id,
      required this.contactId,
      required this.wpId});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  String? phone_Id,messageStr,templateId;
  MessagesModel? fetchMessage;
  TemplateListModel? templateList;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future<void> _loadChat() async {
    phone_Id = phone_number_id;

    final results = await Future.wait([
      fetchContactMessage(widget.id, phone_Id!,widget.contactId),
    ]);

    setState(() {
      fetchMessage = results[0];
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      appBar: buildAppBar(context, widget.name, []),
      body: buildBody(),
    );
  }

  Column buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: fetchMessage != null && fetchMessage!.data!.isNotEmpty
              ? ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  itemCount: fetchMessage!.data!.length,
                  itemBuilder: (context, index) {
                    var message = fetchMessage!.data![index];
                    return message.sent!
                        ? SenderChat(data: message)
                        : ReciverChat(data: message);
                  },
                )
              : const Center(child: Text("No Data Available")),
        ),
        ChatBox(
          onSubmit: (str) {
            _sendMessage(str);
          },
        ),
      ],
    );
  }

  void _sendMessage(String messageContent) async{
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    DateFormat timeFormatter = DateFormat('h:mm a');
    String formattedDate = formatter.format(now);
    String formattedTime = timeFormatter.format(now);
    String? newString = messageContent;
    MessageData newMessage = MessageData(
      id: fetchMessage!.data!.length + 1,
      message: newString,
      status: 1,
      createdAt: formattedDate,
      sent: true,
      time: formattedTime,
      headerLink: null,
      updatedAt: null,
    );

    String number = widget.contactId;
    var data = await whatsappTextMessageSend(messageContent,number,cid);

    if(data!.status == success){
      setState(() {
        fetchMessage?.data?.insert(fetchMessage!.data!.length, newMessage);
      });
    }
    _scrollToBottom();
  }
}
