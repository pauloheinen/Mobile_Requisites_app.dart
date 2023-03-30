import 'package:flutter/material.dart';
import 'package:it_requires_app/Custom/Button/ElevatedButtonCustomWidget.dart';
import 'package:it_requires_app/Custom/TextField/TextFieldWithValidationCustomWidget.dart';
import 'package:it_requires_app/Panes/HomePanes/CreateAccountPane.dart';
import 'package:it_requires_app/Panes/MenuPane/MenuPane.dart';
import 'package:it_requires_app/Repository/UserRepository.dart';
import 'package:it_requires_app/Utils/Navigator/NavigatorUtil.dart';
import 'package:it_requires_app/Utils/Toast/ToastUtil.dart';

import '../../Configs/Preferences.dart';
import '../../Models/User.dart';

class LoginPane extends StatefulWidget {
  const LoginPane({Key? key}) : super(key: key);

  @override
  State<LoginPane> createState() => _LoginState();
}

class _LoginState extends State<LoginPane> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _rememberMe = false;

  @override
  void initState() {
    _autoLogin();
    super.initState();
  }

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
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextFieldWithValidationCustomWidget(
                    label: "Usuário",
                    controller: userController,
                    shouldValidate: true,
                  ),
                  TextFieldWithValidationCustomWidget(
                    label: "Senha",
                    controller: passwordController,
                    shouldValidate: true,
                    obscure: true,
                  ),
                  CheckboxListTile(
                    side: const BorderSide(color: Colors.purpleAccent),
                    title: const Text("Lembrar de mim",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.start),
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    onChanged: (value) {
                      setState(() => _rememberMe = !_rememberMe);
                    },
                    value: _rememberMe,
                    checkColor: Colors.purpleAccent,
                    activeColor: Colors.transparent,
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButtonCustomWidget(label: "Login", _doLogin),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text(
                          'Criar conta',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onPressed: () => createAccount(),
                      ),
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

  _doLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    User user = User(
      name: userController.text,
      password: passwordController.text,
    );

    if (await UserRepository.getUser(user) == null) {
      ToastUtil.warning("Usuário não encontrado");
      return;
    }

    Preferences.clearUserData();

    Preferences.saveRememberMe(_rememberMe);
    Preferences.saveUserData(user);

    moveToMenuPane();
  }

  void _autoLogin() async {
    bool? autoLogin = await Preferences.isRemember();

    if (autoLogin == true) {
      moveToMenuPane();
    }
  }

  moveToMenuPane() {
    NavigatorUtil.pushAndRemoveTo(context, const MenuPane());
  }

  createAccount() {
    NavigatorUtil.pushTo(context, const CreateAccountPane());
  }
}
