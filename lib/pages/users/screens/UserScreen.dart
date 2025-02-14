import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/users/provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/users/components/UserListWidget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late String branch_id;

  @override
  void initState() {
    super.initState();
    branch_id = userBox.get(branchIdStr).toString();
    Future.microtask(
      () => Provider.of<UserProvider>(context, listen: false)
          .getUsers(context, "2"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: buildAppBar(context, "Users", []),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProvider.user == null
              ? const Center(child: Text("No users found"))
              : ListView.builder(
                  itemCount: userProvider.user!.users!.length,
                  itemBuilder: (context, index) {
                    final user = userProvider.user!.users![index];
                    return UserListWidget(
                      image: user.file ?? "",
                      name: user.name ?? "No Name",
                      designation: user.designation ?? "N/A",
                      type: user.userType ?? "Unknown",
                    );
                  },
                ),
    );
  }
}
