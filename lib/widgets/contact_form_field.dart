import 'package:flutter/material.dart';

class ContactFormField extends StatelessWidget {
  const ContactFormField({super.key, required this.label, required this.hint, required this.validator, required this.textEditingController});
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 110, 178, 87),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.lock_open_rounded,
          color: Color.fromARGB(255, 80, 114, 85),
        ),
      ),
      const SizedBox(width: 24,),
      Expanded(
        child: TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
          ),
          validator: validator,
        ),
      ),
    ],
  );
}
