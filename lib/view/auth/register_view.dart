import 'dart:io';

import 'package:chathive/constants/color_constant.dart';
import 'package:chathive/models/user_model.dart';
import 'package:chathive/repo/user_repo.dart';
import 'package:chathive/states/register_state.dart';
import 'package:chathive/view/auth/components/select_image_widget.dart';
import 'package:chathive/view/auth/components/usertypes_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../utills/snippets.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loader_button.dart';
import 'components/rich_text.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cnicController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<RegisterState>(builder: (context, registerState, value) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const SelectImageWidget(),
                      const SizedBox(height: 20),
                      CustomTextField(
                        maxLine: 1,
                        prefixIcon: Icons.person,
                        controller: nameController,
                        hintText: "Name",
                        validator: mandatoryValidator,
                        labelText: 'Name',
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'Email',
                        prefixIcon: Icons.email,
                        controller: emailController,
                        hintText: "Email",
                        validator: emailValidator,
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'Phone No',
                        prefixIcon: Icons.phone,
                        controller: phoneController,
                        hintText: "Phone No",
                        validator: validatePhoneNumber,
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'CNIC',
                        prefixIcon: FontAwesomeIcons.idCard,
                        controller: cnicController,
                        hintText: "XXXXX-XXXXXXX-X",
                        validator: cnicValidation,
                        inputFormatters: [
                          // Blacklist numbers
                          LengthLimitingTextInputFormatter(
                              15), // Limit to 10 characters
                        ],
                        inputType: TextInputType.number,
                        onChange: (value) {
                          setState(() {
                            cnicController.text = formatCnic(value);
                            cnicController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: cnicController.text.length));
                          });
                        },
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'Password',
                        prefixIcon: Icons.lock,
                        isVisible: true,
                        controller: passwordController,
                        hintText: 'Password',
                        validator: passwordValidator,
                        suffixIcon: Icons.visibility,
                        suffixIcon2: Icons.visibility_off,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      UsertypesDropdown(),
                      const SizedBox(height: 22),
                      LoaderButton(
                        btnText: 'Register',
                        radius: 30,
                        onTap: () async {
                          try {
                            if (formKey.currentState!.validate()) {
                              if (registerState.selectedType == null) {
                                snack(context, 'Please select type',
                                    info: false);
                                return;
                              }

                              await AuthRepo().createUser(
                                  emailController.text, passwordController.text,
                                  function: () async {
                                var uid = firebaseAuth.currentUser!.uid;

                                UserModel userModel = UserModel(
                                  uid: registerState.selectedType == 'Admin'
                                      ? 'Admin'
                                      : uid,
                                  cnic: cnicController.text,
                                  name: nameController.text,
                                  email: emailController.text,
                                  phoneNo: phoneController.text,
                                  imageUrl: '',
                                  type: registerState.selectedType!,
                                  isApproved:
                                      registerState.selectedType == 'User',
                                );

                                await AuthRepo().uploadAllDetail(
                                    registerState.selectImage, uid, userModel);

                                if (!mounted) return;
                                registerState.selectImageFile(null);
                                registerState.selectType(null);
                                push(context, const LoginView());
                              });
                            }
                          } catch (e) {
                           
                            snack(context, e.toString(), info: false);
                          }
                        },
                      ),
                      const SizedBox(height: 25),
                      RichTextWidget(
                          messageText: 'Already have an account?',
                          titleText: '  Login',
                          onTap: () {
                            push(context, const LoginView());
                          })
                    ]),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  String formatCnic(String cnic) {
    String formattedCNIC = '';
    int dashCount = 0;
    for (int i = 0; i < cnic.length; i++) {
      if (cnic[i] == '-') {
        continue;
      }

      if (dashCount == 5 || dashCount == 12) {
        formattedCNIC += '-';
      }
      formattedCNIC += cnic[i];
      dashCount++;
    }

    return formattedCNIC;
  }

  String? validatePhoneNumber(String? phoneNumber) {
    // Remove any whitespace or special characters from the phone number
    phoneNumber = phoneNumber?.replaceAll(RegExp(r'\D'), '');

    // Define the regular expression pattern for a valid Pakistani phone number
    RegExp regex = RegExp(r'^(?:\+92|0)?3[0-9]{9}$');

    // Check if the phone number matches the pattern
    if (!regex.hasMatch(phoneNumber ?? '')) {
      return 'Invalid phone number format';
    }

    return null;
  }

  String? cnicValidation(String? cnic) {
    const pattern = r'^\d{5}-\d{7}-\d{1}$';

    if (cnic!.isEmpty) {
      return 'CNIC is required';
    } else if (!RegExp(pattern).hasMatch(cnic)) {
      return 'Invalid CNIC Format';
    }

    return null;
  }
}
