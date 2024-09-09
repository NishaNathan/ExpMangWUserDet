import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trainbookingapp/common/commondata/commonreference.dart';

class DateOfBirthWidget extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const DateOfBirthWidget({
    super.key,
    required this.labelText,
    this.controller,
    this.validator,
  });

  @override
  _DateOfBirthWidgetState createState() => _DateOfBirthWidgetState();
}

class _DateOfBirthWidgetState extends State<DateOfBirthWidget> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      readOnly: true,
      validator: widget.validator,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: blueViolet,
                buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                colorScheme: ColorScheme.light(
                  primary: blueViolet,
                ).copyWith(background: Colors.white),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            widget.controller?.text =
                DateFormat('dd-MM-yyyy').format(pickedDate);
          });
        }
      },
    );
  }
}
