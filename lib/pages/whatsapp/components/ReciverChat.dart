import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/whatsapp/models/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:intl/intl.dart';

class ReciverChat extends StatelessWidget {
  final MessageData data;
  const ReciverChat({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    final dateStr = data.createdAt;
    final inputFormat = DateFormat('dd-MM-yyyy');
    final date = inputFormat.parse(dateStr!);
    final outputFormat = DateFormat('MMMM d');
    final formattedDate = outputFormat.format(date);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Date Text
          Center(
            child: Padding(
              padding:const EdgeInsets.only(top: 32.0),
              child: Text(
                formattedDate,
                style:const TextStyle(color: Color(0xFFC0C0C0)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Message Card
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Card(
                      color: primaryColor,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Message Text
                          Padding(
                            padding:const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Text(
                              data.message!,
                              style:const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: null,
                            ),
                          ),
                          // Timestamp Text
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 10.0,
                              bottom: 5.0,
                              left: 10.0
                            ),
                            child: Text(
                              data.time!,
                              style:const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset(
                  defaultUserImage,
                  width: 40,
                  height: 40,
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
