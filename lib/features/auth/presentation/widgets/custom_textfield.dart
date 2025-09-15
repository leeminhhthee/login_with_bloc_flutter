import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscure;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscure = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _isObscure,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
