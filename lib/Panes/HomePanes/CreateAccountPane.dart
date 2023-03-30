import 'package:flutter/material.dart';
import 'package:it_requires_app/Custom/Button/ElevatedButtonCustomWidget.dart';
import 'package:it_requires_app/Custom/TextField/TextFieldWithValidationCustomWidget.dart';
import 'package:it_requires_app/Models/User.dart';
import 'package:it_requires_app/Repository/UserRepository.dart';
import 'package:it_requires_app/Utils/Toast/ToastUtil.dart';

class CreateAccountPane extends StatefulWidget {
  const CreateAccountPane({Key? key}) : super(key: key);

  @override
  State<CreateAccountPane> createState() => _CreateAccountPaneState();
}

class _CreateAccountPaneState extends State<CreateAccountPane> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  TextFieldWithValidationCustomWidget(
                    label: "Usuário",
                    controller: userController,
                    shouldValidate: true,
                  ),
                  TextFieldWithValidationCustomWidget(
                    label: "Senha",
                    controller: passwordController,
                    shouldValidate: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButtonCustomWidget(label: "Voltar", popPane),
                      ElevatedButtonCustomWidget(
                          label: "Criar conta", createAccount),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String username = userController.text;

    if (await UserRepository.usernameExist(username) == false) {
      ToastUtil.warning("Nome de usuário já utilizado");
      return;
    }

    User user =
        User(name: userController.text, password: passwordController.text);

    UserRepository.addUser(user);

    ToastUtil.inform("Usuário criado");

    popPane();
  }

  popPane() {
    Navigator.of(context).pop();
  }
}
