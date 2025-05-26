import 'dart:convert';
import 'package:fl_carmax/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_carmax/bottom_navigation.dart';
import 'package:fl_carmax/pages/auth/login_page_email.dart';
import 'package:fl_carmax/utils/constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import '../../helper/language_constant.dart';
import '../../services/send_notification_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool isLoading = false;
  String accountType = 'Private Seller';
  @override
  void initState() {
    super.initState();
    phoneController.text = '+66';
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );
  }

  Future<void> registerUser() async {
    final username = nameController.text.trim();
    final email = emailController.text.trim();
    // final phone = phoneController.text.trim();
    final phone = phoneController.text.replaceAll('+66', '').trim();
    final password = passwordController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    // Validation
    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final url =
          Uri.parse('https://www.wowcar.app/wp-json/listivo/v1/register/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone_country_code': '+66',
          'phone': phone,
        }),
      );
      final prefs = await SharedPreferences.getInstance();
      List<String> notifications = prefs.getStringList('notifications') ?? [];
      final responseData = jsonDecode(response.body);
     // NotificationService notificationService = NotificationService();
    //  final deviceToken = await notificationService.getDeviceToken();
      print('''''' '''''' '''''' '''''' '''''' '''''' '''''' '''''');
     // print(deviceToken);
      if (response.statusCode == 200 && responseData['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('email', email);
        await prefs.setString('first_name', firstName);
        await prefs.setString('last_name', lastName);
        await prefs.setString('phone', '+66$phone');
        await prefs.setString('account_type', accountType);

        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
        }
        final LocalNotificationService notificationService = LocalNotificationService();
        if(context.mounted){
          notificationService.initialize(context);
        }
        await notificationService.showRegistrationNotification();
        // await SendNotificationService.sendNotificationUsingApi(
        //   token: deviceToken,
        //   title: 'Welcome to WowCar',
        //   body: 'Thank you for Registering into WowCar.',
        //   data: {},
        // );
        // notifications.add(jsonEncode({
        //   'title': 'Welcome to WowCar',
        //   'body': 'Thanks for Registering on WowCar!',
        //   'timestamp': DateTime.now().toIso8601String(),
        // }));
        //
        // await prefs.setStringList('notifications', notifications);
        // await saveNotificationLocally(
        //     'Welcome to WowCar', 'Thank you for Registering into WowCar.');
        // Navigate to app
        if(context.mounted){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavigation()),
          );
        }
      } else {
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Registration failed'),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveNotificationLocally(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = 'notifications';
    final List<String> existing = prefs.getStringList(key) ?? [];

    final newNotification = jsonEncode({
      'title': title,
      'body': body,
      'timestamp': DateTime.now().toIso8601String(),
    });

    existing.add(newNotification);
    await prefs.setStringList(key, existing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset(appLogo, height: 13.h),
                          heightSpace20,
                          heightSpace3,
                          Text(
                            translation(context).register,
                            style: primarySemiBold20,
                            textAlign: TextAlign.center,
                          ),
                          heightSpace10,
                          heightSpace2,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              translation(context).registerSubtitle,
                              style: color94Medium14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          heightSpace40,
                          PrimaryTextField(
                              controller: nameController,
                              prefixIcon: userIcon,
                              hintText: 'Enter Username'
                              //translation(context).enterYourName,
                              ),
                          heightSpace30,
                          PrimaryTextField(
                            controller: emailController,
                            prefixIcon: mailIcon,
                            hintText: translation(context).enterYourEmailId,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          heightSpace30,
                          PrimaryTextField(
                            controller: phoneController,
                            prefixIcon: mobileIcon,
                            hintText: translation(context).enterMobileNumber,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (!value.startsWith('+66')) {
                                phoneController.text = '+66';
                                phoneController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: phoneController.text.length),
                                );
                              }
                            },
                          ),
                          heightSpace30,
                          PrimaryTextField(
                            controller: firstNameController,
                            prefixIcon: userIcon,
                            hintText: "Enter first name",
                          ),
                          heightSpace30,
                          PrimaryTextField(
                            controller: lastNameController,
                            prefixIcon: userIcon,
                            hintText: "Enter last name",
                          ),
                          heightSpace30,
                          PrimaryTextField(
                            controller: passwordController,
                            prefixIcon: 'assets/images/pass.png',
                            hintText: "Enter password",
                            obscureText: true,
                          ),
                          heightSpace20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(
                                      () => accountType = 'Private Seller');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: accountType == 'Private Seller'
                                        ? primaryColor
                                        : Colors.grey[200],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Private Seller',
                                    style: TextStyle(
                                      color: accountType == 'Private Seller'
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() => accountType = 'Dealer');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: accountType == 'Dealer'
                                        ? primaryColor
                                        : Colors.grey[200],
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Dealer',
                                    style: TextStyle(
                                      color: accountType == 'Dealer'
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          heightSpace20,
                          PrimaryButton(
                            title: isLoading
                                ? "Registering..."
                                : translation(context).register,
                            onTap: isLoading ? null : registerUser,
                          ),
                          heightSpace20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPageEmail()),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
