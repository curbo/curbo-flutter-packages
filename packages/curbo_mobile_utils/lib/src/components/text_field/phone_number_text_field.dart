import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'multi_masked_formatter.dart';

class PhoneNumberData {
  final String? numericDigitals;
  final String? countryCode;

  PhoneNumberData({
    this.numericDigitals,
    this.countryCode,
  });
}

class PhoneNumberTextFormField extends StatefulWidget {
  PhoneNumberTextFormField({
    Key? key,
    this.keyboardType,
    this.border,
    this.borderRadius,
    this.style,
    this.focusNode,
    this.onFieldSubmitted,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.controller,
    this.hintText = '809 555-5555',
    this.labelText = 'Phone number',
    this.initialContryCode = 'DO',
    this.prefix = "+1",
  }) : super(key: key);

  final TextInputType? keyboardType;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? style;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<PhoneNumberData>? onSaved;
  final FormFieldSetter<PhoneNumberData>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final String hintText;
  final String labelText;
  final String initialContryCode;
  final String prefix;

  @override
  _PhoneNumberTextFormFieldState createState() =>
      _PhoneNumberTextFormFieldState();
}

class _PhoneNumberTextFormFieldState extends State<PhoneNumberTextFormField> {
  String? _prefix;
  
  @override
  void initState() {
    _prefix = widget.prefix;
    super.initState();
  }

  MultiMaskedTextInputFormatter _maskFormatter = MultiMaskedTextInputFormatter(
      masks: ['###-####', '###-###-####', '#################'], separator: '-');

  String _getNumericDigitals(String? value) =>
      '$_prefix ${value?.replaceAll(RegExp(r'[()-]'), '')}'
          .trim();

  void _onCountryChange(CountryCode countryCode) {
    _prefix = countryCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        SizedBox(
          width: 64,
          child: CountryCodePicker(
            onChanged: _onCountryChange,
            initialSelection: widget.initialContryCode,
            textStyle: widget.style,
            showFlagMain: false,
          ),
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.phone,
            focusNode: widget.focusNode,
            controller: widget.controller,
            onFieldSubmitted: widget.onFieldSubmitted,
            validator: (value) {
              if (widget.validator != null) return widget.validator!(value);
              return null;
            },
            onSaved: (value) {
              final numericDigitals = _getNumericDigitals(value);
              final countryCode = _prefix;

              if (widget.onSaved != null)
                widget.onSaved!(
                  PhoneNumberData(
                    numericDigitals: numericDigitals,
                    countryCode: countryCode,
                  ),
                );
            },
            onChanged: (value) {
              final numericDigitals = _getNumericDigitals(value);
              final countryCode = _prefix;

              if (widget.onChanged != null)
                widget.onChanged!(
                  PhoneNumberData(
                    numericDigitals: numericDigitals,
                    countryCode: countryCode,
                  ),
                );
            },
            inputFormatters: [_maskFormatter],
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.black.withAlpha(140),
              ),
            ),
            style: widget.style,
          ),
        ),
      ],
    );
  }
}
