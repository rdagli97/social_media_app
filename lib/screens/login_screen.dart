import 'package:event_app/consts/all_strings.dart';
import 'package:event_app/consts/colors.dart';
import 'package:event_app/resources/auth_methods.dart';
import 'package:event_app/screens/signup_screen.dart';
import 'package:event_app/utils/add_space.dart';
import 'package:event_app/utils/navigate_to.dart';
import 'package:event_app/widgets/bottom_nav_bar.dart';
import 'package:event_app/widgets/custom_button.dart';
import 'package:event_app/widgets/custom_text.dart';
import 'package:event_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPass = false;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logInUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        String res = await AuthMethods().logInUser(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (res == "success") {
          pushReplacementTo(
            context,
            const BottomNavBar(),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('fill the blanks'),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                addVerticalSpace(200),
                // icon
                const Icon(
                  Icons.event_available,
                  size: 50,
                ),
                addVerticalSpace(20),
                // email textfield
                CustomTextfield(
                  controller: _emailController,
                  hintText: AllString.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                ),
                addVerticalSpace(20),
                // password textfield
                CustomTextfield(
                  isPass: true,
                  controller: _passwordController,
                  hintText: AllString.password,
                  prefixIcon: const Icon(Icons.password_outlined),
                ),
                addVerticalSpace(20),
                // login button
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onTap: logInUser,
                        color: AllColors.greyS700,
                        text: AllString.login,
                      ),
                addVerticalSpace(100),
                // don't have an account ? - text
                const CustomText(
                  text: AllString.dontHaveAnAccount,
                ),
                // sign up - text
                GestureDetector(
                  onTap: () {
                    pushTo(context, const SignupScreen());
                  },
                  child: CustomText(
                    text: AllString.signUp,
                    color: AllColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
