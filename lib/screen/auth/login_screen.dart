import 'package:flutter/material.dart';
import 'package:lestary_laundry_apps/screen/main_screen.dart';
import 'package:lestary_laundry_apps/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordHidden = true;
  bool isLoading = false;

  final AuthService _authService = AuthService();

  void login() async {
    setState(() {
      isLoading = true;
    });

    String? result = await _authService.login(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      isLoading = false;
    });

    if (result == 'admin') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AdminScreen()));
    } else if (result == 'user') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => UserScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Failed $result')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25.0,
                ),
                Image.asset(
                  'assets/logo/logo.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Email harus diisi'
                        : !value.contains('@')
                            ? 'Tolong masukkan email yang valid'
                            : null),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                    controller: _passwordController,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                          icon: Icon(isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility),
                        )),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Email harus diisi'
                        : !value.contains('@')
                            ? 'Tolong masukkan email yang valid'
                            : null),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5DB99A),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't Have an Account? "),
                    TextButton(onPressed: () {}, child: const Text('Register'))
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
