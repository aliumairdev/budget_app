import 'package:budget_app/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  bool isSignedIn = false;
  bool isObscure = true;
  var logger = Logger();

  List expensesName = [];
  List expensesAmount = [];
  List incomesName = [];
  List incomesAmount = [];

  //Check if Signed In
  Future<void> isLoggedIn() async {
    await _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isSignedIn = false;
      } else {
        isSignedIn = true;
      }
    });
    notifyListeners();
  }

  toogleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  // User Authentication
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.d("User Created"))
        .onError((error, stackTrace) {
      logger.e("Failed to create user: $error");
      DialogBox(context, error.toString().replaceAll(RegExp("\\[.*?\\]"), ''));
    });
  }

  // User Sign In
  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.d("User Signed In"))
        .onError((error, stackTrace) {
      logger.e("Failed to sign in: $error");
      DialogBox(context, error.toString().replaceAll(RegExp("\\[.*?\\]"), ''));
    });
  }

  // User Sign Out
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut().then((value) => logger.d("User Signed Out"));
  }

  // sign in google web
  Future<void> signInWithGoogleWeb(BuildContext context) async {
    GoogleAuthProvider provider = GoogleAuthProvider();
    provider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    await _auth.signInWithPopup(provider).then((value) {
      logger.d("User Signed In with Google");
    }).onError((error, stackTrace) {
      logger.e("Failed to sign in with Google: $error");
      DialogBox(context, error.toString().replaceAll(RegExp("\\[.*?\\]"), ''));
    });
    logger.d("Current User is not empty: ${_auth.currentUser!.uid.isNotEmpty}");
  }

  //sign in google mobile
  Future<void> signInWithGoogleMobile(BuildContext context) async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().onError((error, stackTrace) {
      logger.e("Failed to sign in: $error");
      DialogBox(context, error.toString().replaceAll(RegExp("\\[.*?\\]"), ''));
    });

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _auth.signInWithCredential(credentials).then((value) {
      logger.d("User Signed In with Google successfully");
    }).onError((error, stackTrace) {
      logger.e("Failed to sign in with Google: $error");
      DialogBox(context, error.toString().replaceAll(RegExp("\\[.*?\\]"), ''));
    });
  }

  // Expense
  List expenseName = [];
  List expenseAmount = [];
  List incomeName = [];
  List incomeAmount = [];

  // Add Expense
  Future addExpense(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: const EdgeInsets.all(32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(width: 2.0, color: Colors.black),
        ),
        title: Form(
          key: formKey,
          child: Column(
            children: [
              const OpenSans(
                text: "Add Expense",
                size: 14.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextForm(
                    text: "Name",
                    containerWidth: 130.0,
                    hintText: "Name",
                    controller: nameController,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Name cannot be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  TextForm(
                    text: "Amount",
                    containerWidth: 120.0,
                    hintText: "Amount",
                    controller: amountController,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Amount cannot be empty";
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await userCollection
                    .doc(_auth.currentUser!.uid)
                    .collection('expanses')
                    .add({
                  'name': nameController.text,
                  'amount': amountController.text,
                }).onError((error, stackTrace) {
                  logger.d("Failed to add expense: $error");
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const OpenSans(
              text: "Save",
              size: 15.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
