import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../curbo_mobile_utils.dart';

typedef SliderOnChanged = Function(double);
typedef SliderFormatter = Function(double);

// ignore: must_be_immutable
class CustomSlider extends StatefulWidget {
  CustomSlider({
    Key? key,
    this.value = 0,
    this.max = 10,
    this.min = 0,
    this.title,
    this.inputRedonly = false,
    this.textInputFormatter,
    this.labelFormatter,
    this.onChanged,
    this.scrollController,
    this.inputController,
    this.compactInputLabel = false,
    this.inputStyle,
    this.labelStyle,
  }) : super(key: key);

  double value;

  final double min;
  final double max;
  final String? title;
  final bool inputRedonly;
  final NumericTextFormatter? textInputFormatter;
  final SliderFormatter? labelFormatter;
  final SliderOnChanged? onChanged;
  final ScrollController? scrollController;
  final TextEditingController? inputController;
  final bool compactInputLabel;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<CustomSlider> {
  final _labelStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.grey.shade900,
  );

  final _inputStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.black,
  );

  final FocusNode _inputFocus = FocusNode();
  final _keyboardVisibilityController = KeyboardVisibilityController();
  StreamSubscription<bool>? _keyboardVisibilitySubcription;

  @override
  void initState() {
    super.initState();

    _inputFocus.addListener(() {
      if (!_inputFocus.hasFocus) {
        _evaluateBounds();
      }
    });

    if (Platform.isAndroid) {
      _keyboardVisibilitySubcription =
          _keyboardVisibilityController.onChange.listen((visible) {
        if (!visible) _evaluateBounds();
      });
    }
  }

  @override
  void dispose() {
    _inputFocus.dispose();
    _keyboardVisibilitySubcription?.cancel();

    super.dispose();
  }

  void _setInputValueListener() {
    final value = widget.inputController?.text.replaceAll(",", "");

    var valueParsed = double.parse((value?.isEmpty ?? true) ? "0" : value!);

    if (valueParsed > widget.max) valueParsed -= 0.5;

    if (valueParsed >= widget.min && valueParsed <= widget.max) {
      setState(() {
        widget.value = valueParsed;

        if (widget.onChanged != null) widget.onChanged!(widget.value);
      });
    }
  }

  void _setValue(double value) {
    setState(() {
      widget.value = value;

      widget.inputController?.text = _formatValue(value);

      if (widget.onChanged != null) widget.onChanged!(value);
    });
  }

  void _moveScroll(bool moveUp) {
    if (widget.scrollController == null) return;

    Future.delayed(Duration(milliseconds: moveUp ? 350 : 150), () {
      widget.scrollController?.animateTo(
        widget.scrollController!.position.pixels + (moveUp ? 60 : -60),
        duration: Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  void _evaluateBounds() {
    final value = widget.inputController?.text.replaceAll(",", "");

    final valueParsed = double.parse((value?.isEmpty ?? true) ? "0" : value!);

    if (valueParsed <= widget.min) {
      widget.inputController?.text = _formatValue(widget.min);
    } else if (valueParsed > widget.max) {
      widget.inputController?.text = _formatValue(widget.max);
    }

    _setInputValueListener();
  }

  String _formatValue(double value) {
    final formatter = widget.textInputFormatter?.formatter;

    return formatter == null
        ? value.toInt().toString()
        : formatter.format(value.roundToDouble().toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildInput(),
        Spaces.verticalSmall(),
        _buildSlider(),
      ],
    );
  }

  Widget _buildInput() {
    final screenWidth = MediaQuery.of(context).size.width;
    final sliderWidth = screenWidth / 4;

    final input = TextFormField(
      readOnly: widget.inputRedonly,
      keyboardType: TextInputType.number,
      style: widget.inputStyle ?? _inputStyle,
      decoration: InputDecoration(
        labelText: widget.compactInputLabel ? widget.title ?? "" : null,
      ),
      controller: widget.inputController,
      focusNode: _inputFocus,
      onFieldSubmitted: (_) => _evaluateBounds(),
      textInputAction: TextInputAction.done,
      inputFormatters: widget.textInputFormatter == null
          ? null
          : [widget.textInputFormatter!],
    );

    final List<Widget> children = [];

    if (widget.compactInputLabel) {
      children.addAll([
        Expanded(child: input),
        Spacer(),
      ]);
    } else {
      children.addAll([
        Expanded(
          child: Text(
            widget.title ?? "",
            style: widget.labelStyle ?? _labelStyle,
          ),
        ),
        Spaces.horizontalMedium(),
        SizedBox(
          width: sliderWidth,
          child: input,
        ),
      ]);
    }

    return KeyboardDoneAction(
      platform: PlatfromSupport.ios,
      focusNodes: <FocusNode>[
        _inputFocus,
      ],
      onShow: () => _moveScroll(true),
      onHide: () => _moveScroll(false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
    );
  }

  Widget _buildSlider() {
    final minLabel = widget.labelFormatter == null
        ? '${widget.min.toInt()}'
        : widget.labelFormatter!(widget.min);

    final maxLabel = widget.labelFormatter == null
        ? '${widget.max.toInt()}'
        : widget.labelFormatter!(widget.max);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Slider(
            value: widget.value,
            min: widget.min,
            max: widget.max,
            onChanged: (value) => _setValue(value),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                minLabel,
                textAlign: TextAlign.center,
                style: widget.labelStyle ?? _labelStyle,
              ),
              Spacer(),
              Text(
                maxLabel,
                textAlign: TextAlign.center,
                style: widget.labelStyle ?? _labelStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
