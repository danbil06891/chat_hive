import 'package:chathive/constants/color_constant.dart';
import 'package:chathive/states/register_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UsertypesDropdown extends StatelessWidget {
  UsertypesDropdown({super.key});
  List<String> type = [
    'User',
    'Admin',
  ];
  @override
  Widget build(BuildContext context) {
    RegisterState userState = Provider.of<RegisterState>(context);

    return Container(
      height: 50,
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: textFieldColor,
      ),
      child: DropdownButtonFormField(
        elevation: 4,
        autofocus: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(top: 13, bottom: 0),
          border: InputBorder.none,
          prefixIcon: Icon(
            FontAwesomeIcons.typo3,
            color: greyColor,
            size: 15,
          ),
        ),
        hint: Text(
          'Select Category',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.grey),
        ),
        style: Theme.of(context).textTheme.titleSmall,
        dropdownColor: textFieldColor,
        iconEnabledColor: primaryColor,
        isExpanded: true,
        value: userState.selectedType,
        items: type.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(value),
            ),
            onTap: () {},
          );
        }).toList(),
        onChanged: (value) {
          
          userState.selectType(value.toString());
        },
      ),
    );
  }
}
