import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/style.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/users/provider/UserProvider.dart';
import 'package:inquirymanagement/pages/users/screens/AddUserScreen.dart';
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
      appBar: buildAppBar(context, "Users List", [
        IconButton(
          onPressed: () => print("search"),
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(),
            ),
          ),
          icon: Icon(
            Icons.add_circle_rounded,
            color: Colors.white,
          ),
        )
      ]),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProvider.user == null
              ? const Center(
                  child: Text(
                  "No users found",
                  style: primary_heading_2,
                ))
              : ListView.builder(
                  itemCount: userProvider.user!.users!.length,
                  itemBuilder: (context, index) {
                    final user = userProvider.user!.users![index];
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUserScreen(user:user),
                        ),
                      ),
                      child: UserListWidget(
                        image: user.file ?? "",
                        name: user.name ?? "No Name",
                        designation: user.designation ?? "N/A",
                        type: user.userType ?? "Unknown",
                      ),
                    );
                  },
                ),
    );
  }
}
