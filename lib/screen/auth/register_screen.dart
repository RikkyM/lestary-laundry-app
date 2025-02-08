import 'package:flutter/material.dart';
import 'package:lestary_laundry_apps/screen/auth/login_screen.dart';
import 'package:lestary_laundry_apps/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool isPasswordHidden = true;
  bool isLoading = false;

  final AuthService _authService = AuthService();

  void register() async {
    setState(() {
      isLoading = true;
    });

    String? result = await _authService.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: 'user');

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Register Successful! Now Turn to Login')));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Register Failed $result')));
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
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama harus diisi'
                        : null),
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
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5DB99A),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))),
                    child: const Text(
                      'Register',
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
                    const Text("Already Have an Account? "),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
                        },
                        child: const Text('Sign In'))
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
