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
  TextEditingController searchController = TextEditingController();
  List<dynamic> allUsers = [];
  List<dynamic> filteredUsers = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    branch_id = userBox.get(branchIdStr).toString();
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.getUsers(context, "2").then((_) {
        setState(() {
          allUsers = userProvider.user?.users ?? [];
          filteredUsers = allUsers;
        });
      });
    });
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = allUsers;
      } else {
        filteredUsers = allUsers
            .where(
                (user) => user.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: buildAppBar(context, !isSearching ? "Users List" : "", [
        isSearching
            ? SizedBox(
                width: MediaQuery.of(context).size.width /2,
                child: TextField(
                  controller: searchController,
                  onChanged: filterUsers,
                  decoration: InputDecoration(
                    hintText: "Search users...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = true;
                  });
                },
                icon: Icon(Icons.search, color: Colors.white),
              ),
        if (isSearching)
          IconButton(
            onPressed: () {
              setState(() {
                searchController.clear();
                filterUsers('');
                isSearching = false;
              });
            },
            icon: Icon(Icons.clear, color: Colors.white),
          ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          ),
          icon: Icon(Icons.add_circle_rounded, color: Colors.white),
        )
      ]),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredUsers.isEmpty
              ? const Center(
                  child: Text("No users found", style: primary_heading_2))
              : ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUserScreen(user: user),
                        ),
                      ),
                      child: UserListWidget(
                        slug: user.slug ?? "",
                        image: user.file ?? "",
                        number: user.mobileNo ?? "",
                        userStatus: user.userStatus.toString() ?? "",
                        name: user.name ?? "No Name",
                        designation: user.designation ?? "N/A",
                        type: user.userType ?? "Unknown",
                        onChangeStatus: (String status) {
                          user.userStatus = status;
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
