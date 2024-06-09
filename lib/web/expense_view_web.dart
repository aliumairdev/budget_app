import 'package:budget_app/components.dart';
import 'package:budget_app/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

bool isLoading = true;

class ExpenseViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: MaterialButton(
            onPressed: () async {
              await viewModelProvider.signOut(context);
            },
            color: Colors.black,
            splashColor: Colors.grey,
            child: const OpenSans(
              text: "LogOut",
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
