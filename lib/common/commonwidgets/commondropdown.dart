import 'package:flutter/material.dart';
import 'package:trainbookingapp/common/commondata/commonreference.dart';

class CommonDropDown extends StatefulWidget {
  const CommonDropDown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.prefixiconData,
    required this.onChanged,
    this.suffixIconData,
    required this.borderColor,
    required this.prefixicon,
  });

  final String label;
  final String value;
  final List<String> items;
  final IconData? prefixiconData;
  final ValueChanged<String?> onChanged;
  final IconData? suffixIconData;
  final Color borderColor;
  final bool prefixicon;

  @override
  State<CommonDropDown> createState() => _CommonDropDownState();
}

class _CommonDropDownState extends State<CommonDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.borderColor,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            if (widget.prefixicon && widget.prefixiconData != null)
              Icon(
                widget.prefixiconData,
                color: widget.borderColor,
              ),
            const SizedBox(width: 8.0),
            Expanded(
              child: DropdownButtonFormField<String>(
                value:
                    widget.items.contains(widget.value) ? widget.value : null,
                isExpanded: true,
                icon: Icon(
                  widget.suffixIconData,
                  color: blueViolet,
                ),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 12.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: widget.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: widget.borderColor),
                  ),
                ),
                onChanged: widget.onChanged,
                items:
                    widget.items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
