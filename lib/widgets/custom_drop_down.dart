import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final int value;
  final String hint;
  final String? errorText;
  final List<DropdownMenuItem> items;
  final Function onChanged;

  const CustomDropDown({
    Key? key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.errorText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              12,
            ),
            child: DropdownButton(
              value: value,
              isDense: true,
              hint: Text(
                hint,
                style: const TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
              style: Theme.of(context).textTheme.titleMedium,
              items: items,
              onChanged: (item) {
                onChanged(item);
              },
              isExpanded: true,
              underline: Container(),
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
        ),
        if (errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 10),
            child: Text(
              errorText!,
              style: TextStyle(fontSize: 12, color: Colors.red[800]),
            ),
          ),
      ],
    );
  }
}
