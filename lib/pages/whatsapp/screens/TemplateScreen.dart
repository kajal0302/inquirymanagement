import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/size.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/components/button.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/course/apiCall/fetchCourseListData.dart';
import 'package:inquirymanagement/pages/course/components/showDynamicCheckboxDialog.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';
import 'package:inquirymanagement/pages/inquiry_report/apicall/inquiryFilterApi.dart';
import 'package:inquirymanagement/pages/notification/apicall/inquiryStatusListApi.dart';
import 'package:inquirymanagement/pages/notification/components/customDialogBox.dart';
import 'package:inquirymanagement/pages/notification/model/inquiryStatusListModel.dart';
import 'package:inquirymanagement/pages/whatsapp/apicall/templateList.dart';
import 'package:inquirymanagement/pages/whatsapp/apicall/uploadVideo.dart';
import 'package:inquirymanagement/pages/whatsapp/apicall/whatsappMessageSend.dart';
import 'package:inquirymanagement/pages/whatsapp/components/TemplateWidget.dart';
import 'package:inquirymanagement/pages/whatsapp/components/showBottomSheetCom.dart';
import 'package:inquirymanagement/pages/whatsapp/models/StudentFileter.dart';
import 'package:inquirymanagement/pages/whatsapp/models/TemplateListModel.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:inquirymanagement/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  String? cid;
  InquiryModel? inquiryData;
  List<Inquiries>? filterInquiryData;
  TemplateListModel? templateList;
  String? branch_id;
  String? login_id;
  CourseModel? standardData;
  int _selectedValue = 1;
  Widget? templateWidget;
  List<String> bodyData = [];
  String type = "";
  File? mFile;
  String? whatsappTypesId;
  bool isLoading = true;
  bool sendData = true;
  InquiryStatusModel? inquiryList;
  String selectedStatus = inquiry;
  late String selectedCourseIdsString;

  @override
  void initState() {
    super.initState();
    cid = "Allcm";
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    branch_id = await userBox.get(branchIdStr).toString();
    login_id = "loginid";
    final results = await Future.wait([
      fetchTemplateList(),
      fetchCourseListData(context),
      fetchInquiryStatusList(context)
      // fetchApi(login_id!, cid!),
    ]);
    if (mounted) {
      setState(() {
        templateList = results[0] as TemplateListModel?;
        standardData = results[1] as CourseModel?;
        inquiryList = results[2] as InquiryStatusModel?;
        buildShowTemplatesDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: buildAppBar(context, "Templates", [
        IconButton(
            onPressed: () {
              showInquiryStatusDialog(inquiryList, context);
            },
            icon: Icon(FontAwesomeIcons.ellipsisVertical))
      ]),
      // appBar: buildAppBar(wpPermissionList, wpStr, context, _selectedValue,
      //     (value) {
      //   setState(() {
      //     _selectedValue = value;
      //   });
      // }, () {
      //   Navigator.pop(context, true);
      //   buildShowTemplatesDialog(context);
      // }),
      body: Stack(fit: StackFit.expand, children: [
        buildBackgroundImage(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              buildRow(context),
              const SizedBox(height: 20),
              buildExpanded(context),
            ],
          ),
        ),
      ]),
    );
  }

  Row buildRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildStudentButton(context),
        sendData ? submitButton() : const CircularProgressIndicator(),
      ],
    );
  }

  IconButton submitButton() {
    return IconButton(
      onPressed: () async {
        // Show the progress indicator dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissing by tapping outside
          builder: (BuildContext context) {
            return const AlertDialog(
              content: SizedBox(
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        );

        try {
          // Simulate a delay (like an API call)
          // await Future.delayed(const Duration(milliseconds: 2000));

          if (filterInquiryData == null && filterInquiryData!.length <= 0) {
            callSnackBar("Please Select Student", "danger");
            // Close the progress dialog
            Navigator.of(context).pop();
            return;
          }

          sendData = false;
          setState(() {});

          final selectedStudentIds = filterInquiryData!
              .where((students) => students.isChecked ?? false)
              .map((students) => students.contact.toString())
              .toList();

          String mobileNo = selectedStudentIds.join(',');

          if (bodyData.isNotEmpty) {
            bool status = false;

            if (bodyData.length == 1) {
              for (int i = 0; i < bodyData.length; i++) {
                if (bodyData[i].isEmpty) {
                  status = false;
                  break;
                } else {
                  status = true;
                }
              }
            } else {
              for (int i = 0; i < bodyData.length - 1; i++) {
                if (bodyData[i].isEmpty) {
                  status = false;
                  break;
                } else {
                  status = true;
                }
              }
            }
            if (!status) {
              sendData = true;
              setState(() {});
              callSnackBar("All Fields Are Mandatory", "danger");
              // Close the progress dialog
              Navigator.of(context).pop();
              return;
            }
            if (type == "camera") {
              _cameraApi(mobileNo);
            }

            if (type == "document") {
              _documentApi(mobileNo);
            }

            if (type == "video") {
              _videoApi(mobileNo);
            }

            if (type == "") {
              _stringApi(mobileNo);
            }

            Navigator.of(context).pop();
          }
        } catch (e) {
          debugPrint('Error: $e');
          // Ensure the dialog is closed even if an error occurs
          Navigator.of(context).pop();
        }
      },
      icon: const Icon(Icons.send),
      color: white,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primaryColor),
      ),
    );
  }

  Row buildStudentButton(BuildContext context) {
    return Row(
      children: [
        btnWidget(
          btnBgColor: primaryColor,
          btnBrdRadius: BorderRadius.circular(px35),
          btnLabel: "SELECT STUDENT",
          btnLabelColor: white,
          btnLabelFontSize: px16,
          btnLabelFontWeight: FontWeight.bold,
          onClick: () {
            List<int?> selectedCourseIds = [];
            showDynamicCheckboxDialog(
              context,
              (selectedCourses) async {
                selectedCourseIds = selectedCourses.courses!
                    .where((c) => c.isChecked == true)
                    .map((c) => c.id)
                    .toList();
                selectedCourseIdsString = selectedCourseIds.join(",");
                loadInquiryData();
              },
              standardData,
              () {
                for (var course in standardData!.courses!) {
                  course.isChecked = false;
                }
                setState(() {});
              },
            );
          },
        ),
        const SizedBox(
          width: 10.0,
        ),
        Visibility(
          visible: filterInquiryData != null,
          child: IconButton(
            onPressed: () {
              showBottomSheetCom(context, filterInquiryData);
            },
            icon: const Icon(Icons.person),
            color: white,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildExpanded(BuildContext context) {
    return Flexible(
      flex: 1,
      // Adjust this value based on how much space you want it to occupy
      child: isLoading // Show loading indicator while data is loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : templateWidget != null
              ? Container(
                  padding: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    color: white,
                    elevation: 10.0,
                    child: templateWidget!,
                  ),
                )
              : const Center(
                  child: Text(
                    "No template selected",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
    );
  }

  void _cameraApi(String mobileNo) async {
    if (mFile == null) {
      callSnackBar("Image Is Required", "danger");
      return;
    } else {
      var data = await whatsappMessageSend(whatsappTypesId!, "", "image", "",
          mobileNo, bodyData, "", "", "", cid!, mFile);

      if (data!.status == success) {
        callSnackBar("Message Sent Success", success);
        // mFile = null;
        // whatsappTypesId = null;
        //  bodyData.clear();
        // cid = null;
        Navigator.pop(context, true);
      } else {
        sendData = true;
        setState(() {});
        callSnackBar("Message Can not send", "danger");
      }
    }
  }

  void _videoApi(String mobileNo) async {
    if (mFile == null) {
      callSnackBar("Video Is Required", "danger");
      return;
    } else {
      var data = await uploadVideo(cid!, mFile);
      if (data!.status == success) {
        var res = await whatsappMessageSend(
            whatsappTypesId!,
            data.message.toString(),
            "video",
            "",
            mobileNo,
            bodyData,
            "",
            "",
            "",
            cid!,
            null);
        if (res!.status == success) {
          callSnackBar("Message Sent Success", success);
          Navigator.pop(context, true);
        } else {
          sendData = true;
          setState(() {});
          callSnackBar("Message Can not send", "danger");
        }
      } else {
        sendData = false;
        setState(() {});
        callSnackBar(data.message.toString(), "danger");
      }
    }
  }

  void _documentApi(String mobileNo) async {
    if (mFile == null) {
      callSnackBar("Document Is Required", "danger");
      return;
    } else {
      var data = await whatsappMessageSend(whatsappTypesId!, "", "document", "",
          mobileNo, bodyData, "", "", "", cid!, mFile);

      if (data!.status == success) {
        callSnackBar("Message Sent Success", success);
        Navigator.pop(context, true);
      } else {
        sendData = true;
        setState(() {});
        callSnackBar("Message Can not send", "danger");
      }
    }
  }

  void _stringApi(String mobileNo) async {
    var data = await whatsappMessageSend(whatsappTypesId!, "", "document", "",
        mobileNo, bodyData, "", "", "", cid!, null);
    if (data!.status == success) {
      Navigator.pop(context, true);
      callSnackBar("Message Sent Success", success);
    } else {
      sendData = true;
      setState(() {});
      callSnackBar("Message Can not send", "danger");
    }
  }

  Positioned buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        backgroundWhatsapp,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> loadInquiryData() async {
    InquiryModel? fetchedInquiryListData = await FilterInquiryData(
        selectedCourseIdsString, "", "", branch_id, selectedStatus, context);
    setState(() {
      inquiryData = fetchedInquiryListData;
      filterInquiryData = inquiryData?.inquiries;
    });
  }

  Future<dynamic> buildShowTemplatesDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: primaryColor),
                padding: const EdgeInsets.all(8.0),
                child: const Center(
                  child: Text(
                    "Templates",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                width: 300,
                height: 450,
                child: templateList != null && templateList!.data != null
                    ? buildGridView()
                    : const Center(child: Text("No Templates Available")),
              ),
              cancelButton(context),
            ],
          ),
        );
      },
    );
  }

  Container cancelButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: primaryColor),
      child: OverflowBar(
        alignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: white),
            ),
          ),
        ],
      ),
    );
  }

  GridView buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: templateList!.data!.length,
      itemBuilder: (BuildContext context, int index) {
        var template = templateList!.data![index];
        return Card(
          elevation: 1.0,
          color: white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  bodyData.clear();
                  type = "";
                  whatsappTypesId = template.messageId.toString();
                  List<String> parts = template.string.toString().split('#str');
                  for (int i = 0; i < parts.length - 1; i++) {
                    bodyData.add("");
                  }
                  if (template.image == 1) {
                    type = "camera";
                  }
                  if (template.video == 1) {
                    type = "video";
                  }
                  if (template.document == 1) {
                    type = "document";
                  }
                  templateWidget = TemplateWidget(
                    camera: template.image ?? 0,
                    video: template.video ?? 0,
                    document: template.document ?? 0,
                    templateString: template.string.toString(),
                    bodyData: bodyData,
                    onFilePicked: (file) {
                      setState(() {
                        mFile = file;
                      });
                    },
                  );
                });
                Navigator.pop(context, true);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min, // Add this line
                children: [
                  // Remove the Flexible widget and use a fixed height for the image
                  Container(
                    height: 75, // Set a fixed height for the image container
                    child: Image.network(
                      template.pic.toString(),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Center(
                    child: Text(
                      template.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showInquiryStatusDialog(
      InquiryStatusModel? inquiryList, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedId = '';
        String selectedName = '';
        String selectedStatusId = '';

        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDialog(
              title: "Status",
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: inquiryList!.inquiryStatusList!.length,
                        itemBuilder: (context, index) {
                          var status = inquiryList.inquiryStatusList![index];
                          bool isSelected =
                              selectedId == status.id; // Check if selected
                          return Card(
                            color: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedId = status.id!;
                                  selectedName = status.name!;
                                  selectedStatusId = status.status!;
                                });
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 15),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? preIconFillColor
                                          : grey_500,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      status.name!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? preIconFillColor
                                            : black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedId.isEmpty) {
                            callSnackBar("Please select a status", "danger");
                            return;
                          }
                          setState(() {
                            selectedStatus = selectedName;
                          });

                          loadInquiryData();

                          setState(() {
                            filterInquiryData = inquiryData!.inquiries!
                                .where((e) => e.status == selectedName)
                                .toList();
                          });

                          Navigator.pop(context);
                          callSnackBar(updationMessage, "success");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bv_primaryDarkColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "FIND",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
