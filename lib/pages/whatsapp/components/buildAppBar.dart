import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/whatsapp/components/buildFilterModal.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(String title,BuildContext context, int selectedValue,
        Function(int) onValueChanged, Function() changeTemplate) =>
    AppBar(
      title: Text(title),
      leading: const BackButtonIcon(),
      actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet<void>(
              backgroundColor: white,
              context: context,
              builder: (BuildContext context) {
                return buildFilterModal(
                    context, selectedValue, onValueChanged,changeTemplate);
              },
            );
          },
          icon: const Icon(Icons.filter_list),
        )
      ],
    );
