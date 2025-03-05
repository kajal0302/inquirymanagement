import 'package:flutter/material.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../branch/model/addBranchModel.dart';
import '../apicall/feedbackApi.dart';
import '../apicall/postFeedbackApi.dart';
import '../model/feedbackModel.dart';
import 'customDialogBox.dart';


class InquiryFeedbackDialog extends StatefulWidget {
  final FeedbackModel? feedbackData;
  final String inquiryId;

  const InquiryFeedbackDialog({
    Key? key,
    required this.feedbackData,
    required this.inquiryId
  }) : super(key: key);

  @override
  _InquiryFeedbackDialogState createState() => _InquiryFeedbackDialogState();
}

class _InquiryFeedbackDialogState extends State<InquiryFeedbackDialog> {
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  SuccessModel? addFeedback;
  FeedbackModel? feedbackData;


  // Method to add feedback data
  Future <void> addFeedbackData(String inquiryId,String feedBack ) async{
    SuccessModel? addFeedbackData = await createFeedbackData(inquiryId, feedBack,branchId,context);
    if(mounted){
      setState(() {
        addFeedback = addFeedbackData;
      });
    }
  }

  // Method to load feedback data
  Future <FeedbackModel?> loadFeedBackListData(String inquiryId ) async{
    FeedbackModel? fetchedFeedbackListData = await fetchFeedbackData(inquiryId ,context);
    if(mounted){
      setState(() {
        feedbackData = fetchedFeedbackListData;
      });
    }
    return fetchedFeedbackListData;
  }

  // Add Feedback Dialog Box
  Future<bool> showAddFeedbackDialog(String inquiryId, BuildContext context) async {
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
              const SizedBox(height: 10),
              // Feedback TextField
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

              // Buttons Row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          String feedback = feedbackController.text.trim();
                          if (feedback.isEmpty) {
                            callSnackBar("Please Enter feedback", "danger");

                          }
                          await addFeedbackData(inquiryId, feedback);
                          isFeedbackAdded = true;
                          Navigator.pop(context, isFeedbackAdded);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bv_primaryDarkColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(px15),
                          ),
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: px15),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
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
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: grey_500, fontWeight: FontWeight.bold, fontSize: px15),
                        ),
                      ),
                    ),
                  ],
                ),
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
    return StatefulBuilder(
        builder: (context,setState) {
          return CustomDialog(
            title: feedbackHistory,
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                // Scrollable Feedback List
                Expanded(
                  child: widget.feedbackData == null || widget.feedbackData!.feedbacks == null || widget.feedbackData!.feedbacks!.isEmpty
                      ? const Center(child: Text(noFeedback))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          itemCount: widget.feedbackData!.feedbacks!.length,
                          itemBuilder: (context, index) {
                      var feedbackItem = widget.feedbackData!.feedbacks![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: grey_100,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  feedbackItem.createdAt!,
                                  style: TextStyle(
                                    fontSize: px14,
                                    fontWeight: FontWeight.normal,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  feedbackItem.feedback!,
                                  style: TextStyle(
                                    fontSize: px14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                                          },
                                        ),
                ),

                // Floating Button for Adding Feedback
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      onPressed: () async {
                        // Show add feedback dialog
                        bool isAdded = await showAddFeedbackDialog(widget.inquiryId, context);
                        if (isAdded) {
                          // Refresh feedback list after adding
                          FeedbackModel? updatedData = await loadFeedBackListData(widget.inquiryId);
                          setState(() {
                            feedbackData = updatedData;
                          });
                        }
                      },
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.add, color: white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}


