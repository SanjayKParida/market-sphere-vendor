import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:market_sphere_vendor/controllers/vendor_auth_controller.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VendorAuthController _authController = VendorAuthController();
  late String email, password;
  bool isLoading = false;

  loginUser() async {
    setState(() {
      isLoading = true;
    });
    await _authController
        .signInVendor(context: context, email: email, password: password)
        .whenComplete(() {
      _formKey.currentState!.reset();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _header(),
              const SizedBox(
                height: 18,
              ),
              _buildTextFields(),
              const SizedBox(
                height: 20,
              ),
              _loginButton(),
              const SizedBox(
                height: 20,
              ),
              _navigateToRegisterPage()
            ],
          ),
        ),
      ),
    );
  }

  //CONSTANT TITLES
  Widget _header() {
    return Column(
      children: [
        const Text(
          "Login to your account",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.2),
        ),
        const Text(
          "To expore the world exclusives.",
          style: TextStyle(fontSize: 18, letterSpacing: 0.2),
        ),
        const SizedBox(
          height: 25,
        ),
        SvgPicture.asset("assets/images/login_illustration.svg",
            width: MediaQuery.sizeOf(context).width * 0.3,
            height: MediaQuery.sizeOf(context).height * 0.3)
      ],
    );
  }

  //TEXTFORM FIELDS
  Widget _buildTextFields() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                email = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your Email';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(IconlyBold.work),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (value) {
                password = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your Password';
                } else {
                  return null;
                }
              },
              obscureText: true,
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  fillColor: Colors.grey[200],
                  labelText: "Password",
                  suffixIcon: Icon(IconlyLight.show),
                  prefixIcon: const Icon(IconlyBold.password),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none),
            )
          ],
        ),
      ),
    );
  }

  //LOGIN BUTTON CONTAINER
  Widget _loginButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          loginUser();
        } else {
          debugPrint('failed');
        }
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.07,
        width: MediaQuery.sizeOf(context).width * 0.7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
                colors: [Color(0xFF63A0FF), Color(0xFF102DE1)])),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : Center(
                child: Text(
                  "Login",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white),
                ),
              ),
      ),
    );
  }

  //NAVIGATION TO REGISTRATION PAGE
  Widget _navigateToRegisterPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Need an account? ', style: GoogleFonts.roboto(fontSize: 14)),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          child: Text(
            'Register Here',
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: const Color(0xFF63A0FF)),
          ),
        )
      ],
    );
  }
}
