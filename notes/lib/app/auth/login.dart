import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:notes/components/crud.dart';
import 'package:notes/components/customtextform.dart';
import 'package:notes/components/valid.dart';
import 'package:notes/constant/linkapi.dart';
import 'package:notes/main.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with Crud {
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  login() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequest(linkLogin, {
        "email": email.text,
        "password": password.text,
      });
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        sharedPref.setString("id", response['data']['id'].toString());
        sharedPref.setString("username", response['data']['username']);
        sharedPref.setString("email", response['data']['email']);
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        AwesomeDialog(
          context: context,
          title: "تنبيه",
          body: Text(
            "البريد الالكتروني او كلمة المرور خطأ او الحساب غير موجود",
          ),
        )..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Form(
                    key: formstate,
                    child: Column(
                      children: [
                        Image.asset("images/logo.png", width: 200, height: 200),
                        CustTextFormSign(
                          valid: (val) {
                            return validInput(val!, 3, 20);
                          },
                          mycontroller: email,
                          hint: "email",
                        ),
                        CustTextFormSign(
                          valid: (val) {
                            return validInput(val!, 3, 20);
                          },
                          mycontroller: password,
                          hint: "password",
                        ),
                        MaterialButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 70,
                            vertical: 10,
                          ),
                          onPressed: () async {
                            await login();
                          },
                          child: Text("Login"),
                        ),
                        Container(height: 10),
                        InkWell(
                          child: Text("Sign Up"),
                          onTap: () {
                            Navigator.of(context).pushNamed("signup");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
