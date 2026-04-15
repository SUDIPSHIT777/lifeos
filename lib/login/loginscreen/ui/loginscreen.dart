import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/login/googleauth/googleauth.dart';
import 'package:lifeos/login/loginscreen/controller/logingetx.dart';
import 'package:lifeos/login/loginscreen/controller/loginvalidation.dart';
import 'package:provider/provider.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final Logingetx logincontroller = Get.put(Logingetx());
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: screenheight * 0.22,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/loginlogo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: screenheight * 0.025),
                AutoSizeText(
                  "Welcome Back",
                  style: GoogleFonts.lobster(
                    color: Colors.black,
                    fontSize: screenwidth * 0.1,
                  ),
                ),
                const SizedBox(height: 8),
                AutoSizeText(
                  "Login to your Omnilife Account to Continue",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF647DA5),
                    fontSize: screenwidth * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenheight * 0.03),
                Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      textformfield(
                        hintText: "Enter Your Email",
                        controller: email,
                        prefixIcon: Icons.email,
                        suffixIcon: null,
                        obscureText: false,
                        autofillhint: const [AutofillHints.email],
                        validator: (value) =>
                            Loginvalidation.emailValidator(email),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => textformfield(
                          hintText: "Enter Your Password",
                          controller: password,
                          prefixIcon: Icons.lock,
                          suffixIcon: GestureDetector(
                            onTap: () => logincontroller.isvisibility(),
                            child: logincontroller.isshow.value
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          obscureText: logincontroller.isshow.value,
                          autofillhint: const [AutofillHints.password],
                          validator: (value) =>
                              Loginvalidation.passwordValidator(password),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Loginvalidation.validation(context, formkey);
                            email.clear();
                            password.clear();
                          },
                          icon: const Icon(Icons.login, size: 23),
                          label: AutoSizeText(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          iconAlignment: IconAlignment.end,
                          style: ElevatedButton.styleFrom(
                            elevation: 1,
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: Divider(thickness: 1.5)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: AutoSizeText(
                              "OR CONTINUE WITH",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF647DA5),
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(thickness: 1.5)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<GoogleAuth>(
                            builder: (context, value, child) =>
                                ElevatedButton.icon(
                                  onPressed: () {
                                    value.googlesigncheck(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(150, 50),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  label: const AutoSizeText(
                                    "Google",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  icon: Image.asset(
                                    "assets/google.png",
                                    scale: 20,
                                  ),
                                ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(150, 50),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            label: const AutoSizeText(
                              "Facebook",
                              style: TextStyle(color: Colors.black),
                            ),
                            icon: Image.asset("assets/facebook.png", scale: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AutoSizeText(
                      "Don't have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB3BAC6),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        context.go('/signup');
                      },
                      child: const AutoSizeText(
                        "Create an account",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF434FE6),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textformfield({
    required TextEditingController controller,
    required IconData prefixIcon,
    required String hintText,
    Widget? suffixIcon,
    bool obscureText = false,
    Iterable<String>? autofillhint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autofillHints: autofillhint,
      validator: validator,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }
}
