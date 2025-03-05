import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/whatsapp/models/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:intl/intl.dart';

class SenderChat extends StatelessWidget {
  final MessageData data;
  const SenderChat({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final dateStr = data.createdAt;
    final inputFormat = DateFormat('dd-MM-yyyy');
    final date = inputFormat.parse(dateStr!);
    final outputFormat = DateFormat('MMMM d');
    final formattedDate = outputFormat.format(date);
    final String? link;
    if(data.headerLink != null){
      link = data.headerLink;
    }else{
      link = "";
    }


    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                formattedDate,
                style: const TextStyle(color: Color(0xFFC0C0C0)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Profile and Message Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Profile Image
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset(
                  defaultUserImage,
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(width: 8),
              // Message Card
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Card(
                      color: grey_300,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: link != "",
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.network(
                                link!,
                                width: 260,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Message Text
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Text(
                              data.message!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              maxLines: null,
                              softWrap: true,
                            ),
                          ),
                          // Timestamp
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              bottom: 5.0,
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                data.time!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
