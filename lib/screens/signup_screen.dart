import 'dart:typed_data';

import 'package:event_app/resources/auth_methods.dart';
import 'package:event_app/screens/login_screen.dart';
import 'package:event_app/utils/navigate_to.dart';
import 'package:event_app/utils/pick_image.dart';
import 'package:event_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:event_app/consts/all_strings.dart';
import 'package:event_app/consts/colors.dart';
import 'package:event_app/utils/add_space.dart';
import 'package:event_app/widgets/custom_button.dart';
import 'package:event_app/widgets/custom_text.dart';
import 'package:event_app/widgets/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().sinUpUser(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      isLoading = false;
    });
    if (res != "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
        ),
      );
    } else {
      pushReplacementTo(
        context,
        const BottomNavBar(),
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
                addVerticalSpace(20),
                // icon
                const Icon(
                  Icons.event_available,
                  size: 50,
                ),
                addVerticalSpace(20),
                // circle avatar
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 48,
                            backgroundImage: MemoryImage(
                              _image!,
                            ),
                          )
                        : const CircleAvatar(
                            radius: 48,
                            backgroundImage:
                                AssetImage("assets/default_pp.png"),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 60,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                addVerticalSpace(40),
                // username textfield
                CustomTextfield(
                  controller: _usernameController,
                  hintText: AllString.username,
                  prefixIcon: const Icon(Icons.abc),
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
                // bio textfield
                CustomTextfield(
                  controller: _bioController,
                  hintText: AllString.bio,
                  prefixIcon: const Icon(Icons.person_pin_sharp),
                ),
                addVerticalSpace(20),
                // signup button
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onTap: signUpUser,
                        color: AllColors.greyS700,
                        text: AllString.signUp,
                      ),
                addVerticalSpace(50),
                // have an account ? - text
                const CustomText(
                  text: AllString.haveAnAccount,
                ),
                // login - text
                GestureDetector(
                  onTap: () {
                    pushTo(context, const LoginScreen());
                  },
                  child: CustomText(
                    text: AllString.login,
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
