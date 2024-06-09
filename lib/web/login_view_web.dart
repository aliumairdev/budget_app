import 'package:budget_app/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/create_button.dart';
import 'package:sign_button/sign_button.dart';

import '../view_model.dart';

class LoginViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController emailController = useTextEditingController();
    TextEditingController passwordController = useTextEditingController();
    final viewModelProvider = ref.watch(viewModel);
    final double deviceHigh = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/login_image.png",
              width: deviceWidth / 2.6,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: deviceHigh / 5.5,
                  ),
                  Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                    width: 200.0,
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      textAlign: TextAlign.center,
                      controller: passwordController,
                      obscureText: viewModelProvider.isObscure,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(viewModelProvider.isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            viewModelProvider.toogleObscure();
                          },
                        ),
                        labelText: 'Password',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                          ),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: 150.0,
                        child: MaterialButton(
                          onPressed: () async {
                            viewModelProvider.createUserWithEmailAndPassword(
                                context,
                                emailController.text,
                                passwordController.text);
                          },
                          color: Colors.black,
                          splashColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const OpenSans(
                              text: "Resister", size: 20, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "or",
                        style: GoogleFonts.pacifico(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      SizedBox(
                        height: 50.0,
                        width: 150.0,
                        child: MaterialButton(
                          onPressed: () async {
                            viewModelProvider.signInWithEmailAndPassword(
                                context,
                                emailController.text,
                                passwordController.text);
                          },
                          splashColor: Colors.grey,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const OpenSans(
                              text: "Login", size: 20, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  SignInButton(
                    buttonType: ButtonType.google,
                    onPressed: () async {
                      if (kIsWeb) {
                        await viewModelProvider.signInWithGoogleWeb(context);
                      } else {
                        await viewModelProvider.signInWithGoogleMobile(context);
                      }
                    },
                    btnColor: Colors.black,
                    btnTextColor: Colors.white,
                    buttonSize: ButtonSize.medium,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
