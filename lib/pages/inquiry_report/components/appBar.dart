import 'package:flutter/material.dart';

import '../../../common/color.dart';

AppBar widgetAppbarForInquiryReport(
  BuildContext context,
  String title,
  Widget destinationScreen,
  Function(int) onMenuSelected,
  Function(String) onSearch,
  VoidCallback onCloseSearch, // Callback for search close
  ValueNotifier<bool> isSearching, // Pass ValueNotifier from the parent
  TextEditingController searchController // Pass controller from the parent
) {
  return AppBar(
    backgroundColor: bv_primaryColor,
    iconTheme: IconThemeData(color: white),
    title: ValueListenableBuilder<bool>(
      valueListenable: isSearching,
      builder: (context, searching, child) {
        return searching
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      controller: searchController,
                      style: TextStyle(color: white),
                      decoration: InputDecoration(
                        hintText: 'Type here to Search',
                        hintStyle: TextStyle(color: white70),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          onSearch(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: white),
                    onPressed: () {
                      isSearching.value = false;
                      searchController.clear();
                      onSearch(''); // Clear search results
                      onCloseSearch(); // Call a function when closing the search
                    },
                  ),
                ],
              )
            : Text(
                searchController.text.isNotEmpty
                    ? searchController.text
                    : title,
                style: TextStyle(
                    color: white, fontWeight: FontWeight.normal, fontSize: 20),
              );
      },
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => destinationScreen));
      },
      icon: Icon(Icons.arrow_back_outlined, size: 20),
    ),
    actions: [
      ValueListenableBuilder<bool>(
        valueListenable: isSearching,
        builder: (context, searching, child) {
          return searching
              ? SizedBox.shrink()
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    isSearching.value = true;
                  },
                );
        },
      ),
      IconButton(
        onPressed: () => _showPopUpMenu(
            (value) {
              onMenuSelected(value);
            },
        context),
        icon: Icon(
          Icons.more_vert,
          size: 22,
          color: white,
        ),
      ),
    ],
  );
}

void _showPopUpMenu(
    Function(int) onMenuSelected, BuildContext context) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  await showMenu<int>(
    context: context,
    position: RelativeRect.fromLTRB(
      overlay.size.width,
      kToolbarHeight + 25,
      0,
      0,
    ),
    color: Colors.white,
    items: <PopupMenuEntry<int>>[
      PopupMenuItem(
        value: 1,
        child: Text(
          "Find By Status",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: black),
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(
          "Reference Filter",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: black),
        ),
      ),
      PopupMenuItem(
        value: 3,
        child: Text(
          "Course Filter",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: black),
        ),
      ),
      PopupMenuItem(
        value: 4,
        child: Text(
          "Date Filter",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: black),
        ),
      ),
    ],
  ).then((value) {
    if (value != null) {
      onMenuSelected(value);
    }
  });
}
