

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modernland_signflow/widget/core/masked_input_formattor.dart';

class CustomTextInput extends StatefulWidget {

  const CustomTextInput({
    this.hintTextString = '',
    this.minLines = 1,
    this.textValidator = null,
    this.textEditController = null,
    this.inputType = InputType.Default,
    this.enableBorder = true,
    required this.themeColor,
    this.cornerRadius = 12.0,
    this.maxLength = 99999999999,
    this.prefixIcon = null,
    this.textColor = null,
    this.errorMessage = '',
    this.labelText = '',
  });

  // ignore: prefer_typing_uninitialized_variables
  final FormFieldValidator? textValidator;
  final hintTextString;
  final TextEditingController? textEditController;
  final InputType inputType;
  final bool enableBorder;
  final Color themeColor;
  final int? minLines;
  final double cornerRadius;
  final int maxLength;
  final Widget? prefixIcon;
  final Color? textColor;
  final String errorMessage;
  final String labelText;

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

// input text state
class _CustomTextInputState extends State<CustomTextInput> {
  bool _isValidate = true;
  String validationMessage = '';
  bool visibility = false;
  int oldTextSize = 0;

  // build method for UI rendering
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      child: TextFormField(
        controller: widget.textEditController,
        validator: widget.textValidator,
        decoration: InputDecoration(
          hintText: widget.hintTextString as String,
          errorText: _isValidate ? null : validationMessage,
          counterText: '',
          border: getBorder(),
          alignLabelWithHint: true,
          // Align the label text with the top
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // Always show the label
          enabledBorder: widget.enableBorder ? getBorder() : InputBorder.none,
          focusedBorder: widget.enableBorder ? getBorder() : InputBorder.none,
          labelText: widget.labelText ?? widget.hintTextString as String,
          labelStyle: getTextStyle(),
          prefixIcon: widget.prefixIcon ?? null,
          suffixIcon: getSuffixIcon(),
        ),
        onChanged: checkValidation,
        minLines: widget.minLines,
        maxLines: getMaxLines(),
        keyboardType: getInputType(),
        obscureText: widget.inputType == InputType.Password && !visibility,
        maxLength: widget.inputType == InputType.PaymentCard
            ? 19
            : widget.maxLength ?? getMaxLength(),
        style: TextStyle(
          color: widget.textColor ?? Colors.black,
        ),
        inputFormatters: [getFormatter()],
      ),
    );
  }

  //get border of textinput filed
  OutlineInputBorder getBorder() {
    return OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(widget.cornerRadius ?? 5.0)),
      borderSide: BorderSide(
          width: 1, color: widget.themeColor ?? Theme.of(context).primaryColor),
      gapPadding: 2,
    );
  }

  // formatter on basis of textinput type
  TextInputFormatter getFormatter() {
    if (widget.inputType == InputType.PaymentCard)
      return MaskedTextInputFormatter(
        mask: 'xxxx xxxx xxxx xxxx',
        separator: ' ',
      );
    else
      return TextInputFormatter.withFunction((oldValue, newValue) => newValue);
  }

  // text style for textinput
  TextStyle getTextStyle() {
    return TextStyle(color: widget.themeColor ?? Theme.of(context).primaryColor);
  }

  // input validations
  void checkValidation(String textFieldValue) {
    var runValidation = false;
    if(runValidation){
      if (widget.inputType == InputType.Default) {
        //default
        _isValidate = textFieldValue.isNotEmpty;
        validationMessage = widget.errorMessage ?? 'Filed cannot be empty';
      } else if (widget.inputType == InputType.Email) {
        //email validation
        _isValidate = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(textFieldValue);
        validationMessage = widget.errorMessage ?? 'Email is not valid';
      } else if (widget.inputType == InputType.Number) {
        //contact number validation
        _isValidate = textFieldValue.length == widget.maxLength;
        validationMessage = widget.errorMessage ?? 'Contact Number is not valid';
      } else if (widget.inputType == InputType.Password) {
        //password validation
        _isValidate = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(textFieldValue);
        validationMessage = widget.errorMessage ?? 'Password is not valid';
      } else if (widget.inputType == InputType.PaymentCard) {
        //payment card validation
        _isValidate = textFieldValue.length == 19;
        validationMessage = widget.errorMessage ?? 'Card number is not correct';
      }
      oldTextSize = textFieldValue.length;
    }

    //change value in state
    setState(() {});
  }

  // return input type for setting keyboard
  TextInputType getInputType() {
    switch (widget.inputType) {
      case InputType.Default:
        return TextInputType.text;
        break;

      case InputType.Email:
        return TextInputType.emailAddress;
        break;

      case InputType.Number:
        return TextInputType.number;
        break;

      case InputType.PaymentCard:
        return TextInputType.number;
        break;

      default:
        return TextInputType.text;
        break;
    }
  }

  // get max length of text
  int getMaxLength() {
    switch (widget.inputType) {
      case InputType.Default:
        return 36;
        break;

      case InputType.Email:
        return 36;
        break;

      case InputType.Number:
        return 10;
        break;

      case InputType.Password:
        return 24;
        break;

      case InputType.PaymentCard:
        return 19;
        break;

      default:
        return 36;
        break;
    }
  }

  // get prefix Icon
  Icon getPrefixIcon() {
    switch (widget.inputType) {
      case InputType.Default:
        return Icon(
          Icons.person,
          color: widget.themeColor ?? Theme.of(context).primaryColor,
        );
        break;

      case InputType.Email:
        return Icon(
          Icons.email,
          color: widget.themeColor ?? Theme.of(context).primaryColor,
        );
        break;

      case InputType.Number:
        return Icon(
          Icons.phone,
          color: widget.themeColor ?? Theme.of(context).primaryColor,
        );
        break;

      case InputType.Password:
        return Icon(
          Icons.lock,
          color: widget.themeColor ?? Theme.of(context).primaryColor,
        );
        break;

      case InputType.PaymentCard:
        return Icon(
          Icons.credit_card,
          color: widget.themeColor ?? Theme.of(context).primaryColor,
        );
        break;

      default:
        return Icon(
          Icons.person,
          color: widget.themeColor ?? Theme.of(context).primaryColor,
        );
        break;
    }
  }

  // get suffix icon
  Widget getSuffixIcon() {
    if (widget.inputType == InputType.Password) {
      return IconButton(
        onPressed: () {
          visibility = !visibility;
          setState(() {});
        },
        icon: Icon(
          visibility ? Icons.visibility : Icons.visibility_off,
          color: widget.themeColor ?? Theme.of(context).primaryColor,
        ),
      );
    } else {
      return const Opacity(opacity: 0, child: Icon(Icons.phone));
    }
  }

  int getMaxLines() {
    if (widget.inputType == InputType.Password) {
      return 1;
    } else {
      return widget.minLines ?? 1;
    }
  }
}

//input types
enum InputType { Default, Email, Number, Password, PaymentCard }