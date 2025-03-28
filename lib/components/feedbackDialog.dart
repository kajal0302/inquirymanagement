import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/color.dart';
import '../common/size.dart';
import '../common/text.dart';
import '../main.dart';
import '../utils/common.dart';
import '../pages/branch/model/addBranchModel.dart';
import '../pages/notification/apicall/feedbackApi.dart';
import '../pages/notification/apicall/postFeedbackApi.dart';
import '../pages/notification/model/feedbackModel.dart';
import 'customDialogBox.dart';

class InquiryFeedbackDialog extends StatefulWidget {
  final String inquiryId;
  final FeedbackModel? feedbackData;

  const InquiryFeedbackDialog(
      {Key? key, required this.feedbackData, required this.inquiryId})
      : super(key: key);

  @override
  _InquiryFeedbackDialogState createState() => _InquiryFeedbackDialogState();
}

class _InquiryFeedbackDialogState extends State<InquiryFeedbackDialog> {
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();

  Future<FeedbackModel?> loadFeedBackListData() async {
    return await fetchFeedbackData(widget.inquiryId, context);
  }

  Future<void> addFeedbackData(String feedBack) async {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    SuccessModel? response =
        await createFeedbackData(widget.inquiryId, feedBack, branchId, context);
    if (response?.status == success) {
      setState(() {});
    }
  }

  Future<bool> showAddFeedbackDialog() async {
    TextEditingController feedbackController = TextEditingController();
    bool isFeedbackAdded = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: addFeedbackHeader,
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: grey_100,
                    hintText: "Type your feedback...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String feedback = feedbackController.text.trim();
                      if (feedback.isNotEmpty) {
                        await addFeedbackData(feedback);
                        isFeedbackAdded = true;
                        Navigator.pop(context, isFeedbackAdded);
                      } else {
                        callSnackBar("Please Enter feedback", "danger");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bv_primaryDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(px15),
                      ),
                    ),
                    child: const Text(
                      "Add",
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: px15),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(px15),
                        side: BorderSide(
                          color: grey_500,
                          width: 2,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          color: grey_500,
                          fontWeight: FontWeight.bold,
                          fontSize: px15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    return isFeedbackAdded;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: feedbackHistory,
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<FeedbackModel?>(
              future: loadFeedBackListData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError ||
                    snapshot.data?.feedbacks == null) {
                  return const Center(child: Text("No feedback available"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: snapshot.data!.feedbacks!.length,
                  itemBuilder: (context, index) {
                    var feedbackItem = snapshot.data!.feedbacks![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: grey_100,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          title: Text(
                            feedbackItem.feedback!,
                            style: TextStyle(
                              fontSize: px14,
                              fontWeight: FontWeight.normal,
                              color: primaryColor,
                            ),
                          ),
                          subtitle: Text(
                            feedbackItem.createdAt!,
                            style: TextStyle(
                              fontSize: px14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () async {
              bool isAdded = await showAddFeedbackDialog();
              if (isAdded) {
                setState(() {});
              }
            },
            backgroundColor: primaryColor,
            child: const Icon(Icons.add, color: white),
          ),
        ],
      ),
    );
  }
}
