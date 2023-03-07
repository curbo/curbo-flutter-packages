import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  PasswordTextFormField({
    this.onSaved,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.labelText,
    this.initialValue,
    this.icon,
  });

  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? labelText;
  final String? initialValue;
  final Widget? icon;

  @override
  _PasswordTextFormFieldState createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction,
      obscureText: obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        labelText: widget.labelText,
        icon: widget.icon,
        suffixIcon: SizedBox(
          height: 24,
          width: 24,
          child: TextButton(
            child: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
        ),
        fillColor: Colors.white,
      ),
    );
  }
}
