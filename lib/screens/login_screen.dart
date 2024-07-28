import 'package:eshop/services/auth_service.dart';
import 'package:eshop/utils/constants.dart';
import 'package:eshop/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: greyColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'e-Shop',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 50),
              CustomTextField(
                hintText: 'Email',
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return 'Please enter your email';
                  } else
                    return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                obscureText: true,
                hintText: 'Password',
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var isLoggedin = await authService.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (isLoggedin) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return authService.isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: fontPoppins,
                                fontWeight: fontWeightMedium,
                              ),
                            );
                    },
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New here? ',
                    style: TextStyle(
                        color: secondaryColor,
                        fontFamily: fontPoppins,
                        fontWeight: fontWeightMedium),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                          color: primaryColor,
                          fontFamily: fontPoppins,
                          fontWeight: fontWeightBold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
