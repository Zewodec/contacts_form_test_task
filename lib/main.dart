import 'package:contacts_form/bloc/sending_message_cubit.dart';
import 'package:contacts_form/widgets/contact_form_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dio/dio_send_message.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adams Contact Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 197, 224, 99)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Contact Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final Dio dio = Dio();
  final SendingMessageCubit sendingMessageCubit =
      SendingMessageCubit(DioSendMessage(dio: Dio()));

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isNameValid = false;
  bool isEmailValid = false;
  bool isMessageValid = false;

  bool isButtonDisabled = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () {
            setState(() {
              isNameValid = _validateName(nameController.text);
              isEmailValid = _validateEmail(emailController.text);
              isMessageValid = _validateMessage(messageController.text);

              if (isNameValid && isEmailValid && isMessageValid) {
                isButtonDisabled = false;
              } else {
                isButtonDisabled = true;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 36,
              right: 36,
              top: 48,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ContactFormField(
                    label: "Name",
                    hint: "Enter your Name",
                    validator: (value) {
                      if (!_validateName(value!)) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                    textEditingController: nameController),
                const SizedBox(
                  height: 24,
                ),
                ContactFormField(
                    label: "Email",
                    hint: "Enter your Email",
                    validator: (value) {
                      if (!_validateEmail(value!)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    textEditingController: emailController),
                const SizedBox(
                  height: 24,
                ),
                ContactFormField(
                    label: "Message",
                    hint: "Enter your Message",
                    validator: (value) {
                      if (!_validateMessage(value!)) {
                        return "Please enter your message";
                      }
                      return null;
                    },
                    textEditingController: messageController),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: BlocConsumer<SendingMessageCubit, SendingMessageState>(
                    bloc: sendingMessageCubit,
                    listener: (context, state) {
                      if (state is SendingMessageInProgress) {
                        disableSendButton();
                      } else if (state is SendingMessageSuccess &&
                          state.response['success'] == true) {
                        showSuccessMessage(context);
                      } else if (state is SendingMessageSuccess &&
                          state.response['success'] == false) {
                        showWarningMessage(context);
                        enableSendButton();
                      } else if (state is SendingMessageFailure) {
                        showErrorMessage(context, state.error);
                        enableSendButton();
                      }
                    },
                    builder: (context, state) {
                      if (state is SendingMessageInProgress) {
                        return const ElevatedButton(
                          onPressed: null,
                          child: Text('Please wait'),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed:
                              isButtonDisabled ? null : onClickSendButton,
                          child: const Text('Send'),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onClickSendButton() {
    if (_formKey.currentState!.validate()) {
      sendingMessageCubit.sendMessage(
        nameController.text,
        emailController.text,
        messageController.text,
      );
    }
  }

  bool _validateName(String value) {
    return value.isNotEmpty;
  }

  bool _validateEmail(String value) {
    final RegExp emailRegExp = RegExp(
      r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      unicode: true,
    );

    return value.isNotEmpty && emailRegExp.hasMatch(value);
  }

  bool _validateMessage(String value) {
    return value.isNotEmpty;
  }

  void enableSendButton() {
    setState(() {
      isButtonDisabled = false;
    });
  }

  void disableSendButton() {
    setState(() {
      isButtonDisabled = true;
    });
  }

  void showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent successfully'),
        backgroundColor: Colors.green,
      ),
    );
    enableSendButton();
  }

  void showWarningMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent but received an error'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void showErrorMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }
}
