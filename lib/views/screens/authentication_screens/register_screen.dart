import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:market_sphere_vendor/controllers/vendor_auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String email, fullName, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VendorAuthController _authController = VendorAuthController();
  bool isLoading = false;

  registerUser() async {
    setState(() {
      isLoading = true;
    });
    await _authController
        .signUpVendor(
            context: context,
            email: email,
            fullName: fullName,
            password: password)
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
                height: 20,
              ),
              _buildTextFields(),
              const SizedBox(
                height: 20,
              ),
              _registerButton(),
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
          "Register an account",
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
        SvgPicture.asset("assets/images/signup_illustration.svg",
            width: MediaQuery.sizeOf(context).width * 0.2,
            height: MediaQuery.sizeOf(context).height * 0.2)
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
                fullName = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your Full Name';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: "Full Name",
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(IconlyBold.user_2),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none),
            ),
            const SizedBox(
              height: 10,
            ),
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

  //REGISTER BUTTON CONTAINER
  Widget _registerButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          registerUser();
        } else {
          debugPrint("unsuccessfull");
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
                  "Register",
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
        Text('Already have an account? ',
            style: GoogleFonts.roboto(fontSize: 14)),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Login',
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
