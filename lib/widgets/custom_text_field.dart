import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/constants/app_texts.dart';

class CustomTextfield extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType textInputType;
  final bool isEnable;

  const CustomTextfield(
      {Key? key,
      this.maxLines = 1,
      this.label = "",
      required this.text,
      this.hint = "",
      required this.onChanged,
      required this.textInputType,
      this.isEnable = true})
      : super(key: key);

  @override
  _CustomTextfieldState createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTexts.font16Bold),
          const SizedBox(height: 8),
          TextFormField(
            enabled: widget.isEnable,
            minLines: 1,
            keyboardType: widget.maxLines > 1
                ? TextInputType.multiline
                : TextInputType.name,
            onChanged: widget.onChanged,
            controller: controller,
            decoration: InputDecoration(
              hintText: widget.hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              focusColor: AppColors.green,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: const BorderSide(
                  color: AppColors.lightGreen,
                ),
              ),
            ),
            maxLines: widget.maxLines,
          ),
        ],
      );
}
