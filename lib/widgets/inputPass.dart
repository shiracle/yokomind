import 'package:flutter/material.dart';
import 'package:yoko_mind/theme/color.dart';

class CustomInputFieldPass extends StatefulWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool isSecure;
  final TextEditingController inputController;
  final String validationText;
  final bool next;
  final Function? onDone;
  final String? placeholder;
  final int? limitString;
  const CustomInputFieldPass(
      {super.key,
      this.hintText,
      this.icon = Icons.person,
      required this.onChanged,
      this.isSecure = false,
      required this.inputController,
      required this.validationText,
      this.next = false,
      this.onDone,
      this.placeholder,
      this.limitString});

  @override
  State<CustomInputFieldPass> createState() => _CustomInputFieldPassState();
}

class _CustomInputFieldPassState extends State<CustomInputFieldPass> {
  bool passwordType = false;
  FocusNode inputFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.isSecure) {
      passwordType = true;
    } else {
      passwordType = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        focusNode: inputFocusNode,
        onChanged: widget.onChanged,
        cursorColor: AppColor.outLine,
        style: const TextStyle(
          color: AppColor.outLine,
        ),
        maxLength: widget.limitString,
        obscureText: widget.isSecure
            ? passwordType
                ? true
                : false
            : false,
        controller: widget.inputController,
        textInputAction:
            widget.next ? TextInputAction.next : TextInputAction.done,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.validationText;
          }
          return null;
        },
        onFieldSubmitted:
            widget.onDone != null ? (value) => widget.onDone!() : null,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.outLine,
                width: 1.5,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.outLine,
                width: 1.5,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: widget.hintText,
          hintText: widget.placeholder,
          labelStyle: TextStyle(
            color: AppColor.outLine,
            fontSize: size.height * 0.01,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusColor: AppColor.outLine,
          hintStyle: TextStyle(
            fontSize: size.height * 0.014,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
