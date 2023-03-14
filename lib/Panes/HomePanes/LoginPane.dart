import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Configs/Preferences.dart';
import '../../Models/User.dart';
import 'HomePane.dart';



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
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Image.asset('lib/Resources/logo.png'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              userController.text.isEmpty) {
                            return 'O campo deve ser preenchido!';
                          }
                          return null;
                        },
                        controller: userController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Usuário'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O campo deve ser preenchido!';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Senha'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(200, 0, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          // forgotPassword();
                        },
                        child: const Text(
                          'Esqueci minha senha',
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        title:
                        const Text("Lembrar de mim", // this isnt the right blue
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                            textAlign: TextAlign.start),
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        onChanged: (value) {
                          setState(() => _rememberMe = !_rememberMe);
                        },
                        value: _rememberMe,
                        checkColor: CupertinoColors.systemBlue,
                        activeColor: Colors.transparent),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('login', style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _doLogin();
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            // createAccount();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _doLogin() async {
    // User? user;
    // try {
    //   user =  await UserService()
    //       .loginUser(userController.text, passwordController.text);
    // } on TimeoutException catch (ignored) {
    //   ToastUtil.noConnectionToast(context);
    //   return;
    // }
    //
    // if (user == null) {
    //   ToastUtil.userNotFoundToast(context);
    //   return;
    // }
    //
    // Preferences.clearUserData();
    //
    // Preferences.saveRememberMe(_rememberMe);
    // Preferences.saveUserData(user);
    //
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => HomePane()));
  }

  void _autoLogin() async {
    bool? autoLogin = await Preferences.isRemember();

    if (autoLogin == true) {
      User user = await Preferences.getUserData();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePane()));
    }
  }
}
