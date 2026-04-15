import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeos/login/googleauth/googleauth.dart';
import 'package:lifeos/login/signupscreen/controller/signupcontroller.dart';
import 'package:lifeos/login/signupscreen/controller/signupvalidation.dart';
import 'package:provider/provider.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final Signupcontroller signupcontroller = Get.put(Signupcontroller());
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
                Center(
                  child: Container(
                    width: screenwidth * 0.22,
                    height: screenheight * 0.11,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFFCC80), width: 4),
                      color: Color(0xFFE3F2FD),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset("assets/logos.png", fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: screenheight * 0.025),
                AutoSizeText(
                  "Create Account",
                  style: GoogleFonts.lobster(
                    color: Colors.black,
                    fontSize: screenwidth * 0.1,
                  ),
                ),
                const SizedBox(height: 8),
                AutoSizeText(
                  "Join Lifeos and Boost your Productivity with AI",
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
                        "Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      textformfield(
                        hintText: "Enter Your Name",
                        controller: name,
                        prefixIcon: Icons.person,
                        suffixIcon: null,
                        obscureText: false,
                        autofillhint: const [AutofillHints.name],
                        validator: (value) =>
                            SignupValidators.emailValidator(name),
                      ),
                      const SizedBox(height: 18),
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
                            SignupValidators.emailValidator(email),
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
                            onTap: () => signupcontroller.isvisibilitysignup(),
                            child: signupcontroller.isshow.value
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          obscureText: signupcontroller.isshow.value,
                          autofillhint: const [AutofillHints.password],
                          validator: (value) =>
                              SignupValidators.passwordValidator(password),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: signupcontroller.ischeck.value,
                              onChanged: (value) =>
                                  signupcontroller.ischeckon(),
                            ),
                          ),
                          AutoSizeText(
                            "I agree to the ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          AutoSizeText(
                            "Terms & Conditions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF3C60EA),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            SignupValidators.validation(
                              context,
                              formkey,
                              signupcontroller,
                            );
                            email.clear();
                            password.clear();
                            name.clear(); //as go
                          },
                          icon: const Icon(Icons.login, size: 23),
                          label: AutoSizeText(
                            "Sign Up",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          iconAlignment: IconAlignment.end,
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
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
                      "Have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB3BAC6),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        context.go('/login');
                      },
                      child: const AutoSizeText(
                        "Login",
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
    name.dispose();
  }
}
