import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/whatsapp/apicall/cantactList.dart';
import 'package:inquirymanagement/pages/whatsapp/models/ContactListModel.dart';
import 'package:inquirymanagement/pages/whatsapp/screens/Message.dart';
import 'package:inquirymanagement/pages/whatsapp/screens/TemplateScreen.dart';
import 'package:flutter/material.dart';
import '../components/ContactListTile.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  String? wp_Id;
  ContactListModel? fetchListModel, contactListModel;

  @override
  void initState() {
    super.initState();
    _loadContactList();
  }

  Future<void> _loadContactList() async {
    wp_Id = wp_account_id;
    fetchListModel = await contactList(wp_Id!);
    setState(() {
      contactListModel = fetchListModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: buildAppBar(context, "Contacts", []),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TemplateScreen(),
            ),
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add,color: white,),
      ),
      body: contactListModel != null
          ? contactListModel!.data!.isNotEmpty
              ? ListView.builder(
                itemCount: contactListModel!.data!.length,
                itemBuilder: (context, index) {
                  final contact = contactListModel!.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Message(
                            id: contact.id.toString(),
                            name: contact.name.toString(),
                            contactId: contact.waId.toString(),
                            wpId: contact.wpId.toString(),
                          ),
                        ),
                      );
                    },
                    child: ContactListTile(
                      name: contact.name.toString(),
                    ),
                  );
                },
              )
              : const Center(
                  child: Text("No data Available"),
                )
          : const Center(
              child: Text("No data Available"),
            ),
    );
  }
}
