import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_wms/customcontrols/approutes.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/login/api_service_login.dart';
import 'package:food_wms/login/userinformation.dart';

class LoginScreen extends StatefulWidget {
  final String title;

  const LoginScreen({super.key, required this.title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isloggingin = false;
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _usernameController.text = "chandan";
    _passwordController.text = "1234567";
    bool isPassword = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              AppRoutes.redirectsplashscreen(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: AppFunctions.footer(context),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppTextFormField(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                  controller: _usernameController,
                  focusnode: _usernameFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  ismandatoryField: true,
                ),

                AppTextFormField(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  controller: _passwordController,
                  focusnode: _passwordFocusNode,
                  ismandatoryField: true,
                  isPasswordField: isPassword,
                  onFieldSubmitted: (value) {
                    if (!_isloggingin) login(context);
                  },
                  validator: (value) {
                    int? p0 = int.tryParse(value!);

                    if (p0 == null) {
                      return 'Password can only be numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_isloggingin) login(context);
                    },
                    child: Text(_isloggingin ? 'Please wait..' : 'Login'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Visibility(
                    visible: _isloggingin,
                    child: LinearProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    try {
      if (!AppFunctions.isValidToken()) {
        AppRoutes.redirectsplashscreen(context);
        return;
      }

      if (_formKey.currentState!.validate()) {
        setState(() {
          _isloggingin = true;
        });

        final String username = _usernameController.text;

        String strpassword =
            _passwordController.text + (Random().nextInt(98) + 2).toString();

        int password = int.parse(strpassword);
        int passwordencryptkey = Random().nextInt(398) + 2;

        num temppasswordpower = pow(passwordencryptkey, 2);
        temppasswordpower = temppasswordpower + password;
        temppasswordpower = temppasswordpower * 5;

        final loginData = await LoginApiService.checklogin(
          username,
          _passwordController.text,
          passwordencryptkey.toString(),
        );

        String returnmsg = loginData['msg'];

        if (returnmsg == "success") {
          Map<String, dynamic> userData = await LoginApiService.getuserdata(
            username.toUpperCase(),
          );

          List<dynamic> userdetailsData = userData['UserDetails'];

          List<Userinformation> itemlist =
              userdetailsData
                  .map((data) => Userinformation.fromJson(data))
                  .toList();

          if (userData['status'] == "Ok") {
            await SharedPreferencesHelper.saveString(
              SharedPreferencesHelper.KEY_USERNAME,
              itemlist[0].username,
            );

            await SharedPreferencesHelper.saveString(
              SharedPreferencesHelper.KEY_USERID,
              itemlist[0].userid,
            );

            await SharedPreferencesHelper.saveString(
              SharedPreferencesHelper.KEY_ORGNAME,
              itemlist[0].organizationname,
            );

            await SharedPreferencesHelper.saveString(
              SharedPreferencesHelper.KEY_ORGCODE,
              itemlist[0].organizationcode,
            );

            await SharedPreferencesHelper.saveString(
              SharedPreferencesHelper.KEY_ORGID,
              itemlist[0].organizationid,
            );

            await SharedPreferencesHelper.saveString(
              SharedPreferencesHelper.KEY_USERALLOWRECIEPTID,
              itemlist[0].userallowrecieptid,
            );

            setState(() {
              _isloggingin = false;
            });

            AppRoutes.redirecthome(context);
          } else {
            setState(() {
              _isloggingin = false;
            });
            AppFunctions.showError(context, userData['msg']);
          }
        } else {
          setState(() {
            _isloggingin = false;
          });

          AppFunctions.showError(
            context,
            loginData['Validate Status'][0][0]['Status'],
          );
        }
      }
    } catch (e) {
      setState(() {
        _isloggingin = false;
      });
      final errorMessage = e.toString().replaceAll("Exception: ", "");
      AppFunctions.showError(context, errorMessage);
    }
  }
}
