import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropdownButton extends ConsumerStatefulWidget {
  const CustomDropdownButton(
      {required this.items,
      required this.hint,
      this.selectedDropdown,
      super.key});

  final List<String> items;
  final String hint;
  final bool? selectedDropdown;

  @override
  ConsumerState<CustomDropdownButton> createState() =>
      _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends ConsumerState<CustomDropdownButton> {
  String? _selectedValue;
  @override
  void initState() {
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   if (widget.selectedDropdown == true) {
  //     selectedValue = ref.watch(priorityProvider);
  //   } else {
  //     selectedValue = ref.watch(typeProvider);
  //   }
  // }

//TODO: customize screen

  @override
  Widget build(BuildContext context) {
    // if (widget.selectedDropdown == true) {
    //   selectedValue = ref.watch(priorityProvider);
    // } else {
    //   selectedValue = ref.watch(typeProvider);
    // }

    return Container();
  }
}
