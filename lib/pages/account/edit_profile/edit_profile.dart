import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_carmax/utils/constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import '../../../helper/language_constant.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  bool isLoading = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
      _nameController.text = prefs.getString('first_name') ?? '';
      _lastNameController.text = prefs.getString('last_name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _displayNameController.text = prefs.getString('display_name') ?? '';
      _numberController.text =
          '${prefs.getString('phone_country_code') ?? '+66'}${prefs.getString('phone') ?? ''}';
      _youtubeController.text = prefs.getString('you_tube_profile') ?? '';
      _facebookController.text = prefs.getString('facebook_profile') ?? '';
      _instagramController.text = prefs.getString('instagram_profile') ?? '';
      _linkedinController.text = prefs.getString('linked_in_profile') ?? '';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bodyMethod(context),
    );
  }

  Widget bodyMethod(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            heightSpace10,
            Center(
              child: SizedBox(
                height: 110,
                width: 110,
                child: Stack(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => updateImageSheet(context),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: colorE6,
                        backgroundImage: const AssetImage('assets/images/natural_avator.png',),
                        onBackgroundImageError: (_, __) {
                          Image.network("https://www.scienceabroad.org.il/wp-content/uploads/2023/01/user-icon-placeholder-1-1.png");
                        },
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: 4,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => updateImageSheet(context),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: white,
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 2.2.h,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text(_nameController.text, style: blackMedium16),
                  heightSpace5,
                  Text(_numberController.text, style: colorA6Medium14),
                ],
              ),
            ),
            heightSpace40,
            PrimaryTextField(
              controller: _nameController,
              prefixIcon: userIcon,
              hintText: translation(context).enterYourName,
            ),
            heightSpace30,
            PrimaryTextField(
              controller: _lastNameController,
              prefixIcon: userIcon,
              hintText: 'Enter Last Name',
            ),
            heightSpace30,
            PrimaryTextField(
              controller: _displayNameController,
              prefixIcon: userIcon,
              hintText: 'Enter Display Name',
            ),
            heightSpace30,
            PrimaryTextField(
              controller: _emailController,
              prefixIcon: mailIcon,
              hintText: translation(context).enterYourEmailId,
              keyboardType: TextInputType.emailAddress,
            ),
            heightSpace30,
            PrimaryTextField(
              controller: _numberController,
              prefixIcon: mobileIcon,
              hintText: translation(context).enterMobileNumber,
              keyboardType: TextInputType.phone,
            ),
            heightSpace30,
            PrimaryTextField(
              controller: _youtubeController,
              prefixIcon: userIcon,
              hintText: 'YouTube Profile URL',
            ),
            heightSpace30,
            PrimaryTextField(
              controller: _facebookController,
              prefixIcon: userIcon,
              hintText: 'Facebook Profile URL',
            ),
            heightSpace30,
            PrimaryTextField(
              controller: _instagramController,
              prefixIcon: userIcon,
              hintText: 'Instagram Profile URL',
            ),
            heightSpace30,
            PrimaryTextField(
              controller: _linkedinController,
              prefixIcon: userIcon,
              hintText: 'LinkedIn Profile URL',
            ),
            heightSpace60,
            PrimaryButton(
              title: translation(context).update,
              onTap: updateUserProfile,
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateUserProfile() async {
    if (userId == null) return;

    final fullPhone = _numberController.text.trim();
    String phoneCountryCode = '+66';
    String phoneNumber = fullPhone;

    if (fullPhone.startsWith('+')) {
      final match = RegExp(r'^\+(\d{1,3})').firstMatch(fullPhone);
      if (match != null) {
        phoneCountryCode = '+${match.group(1)}';
        phoneNumber = fullPhone.replaceFirst(phoneCountryCode, '');
      }
    }

    final url = Uri.parse('https://www.wowcar.app/wp-json/listivo/v1/update-profile/');
    final body = jsonEncode({
      "user_id": userId,
      "first_name": _nameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "phone": phoneNumber,
      "phone_country_code": phoneCountryCode,
      "email": _emailController.text.trim(),
      "display_name": _displayNameController.text.trim(),
      "you_tube_profile": _youtubeController.text.trim(),
      "facebook_profile": _facebookController.text.trim(),
      "instagram_profile": _instagramController.text.trim(),
      "linked_in_profile": _linkedinController.text.trim()
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('first_name', _nameController.text.trim());
        await prefs.setString('last_name', _lastNameController.text.trim());
        await prefs.setString('phone', phoneNumber);
        await prefs.setString('phone_country_code', phoneCountryCode);
        await prefs.setString('email', _emailController.text.trim());
        await prefs.setString('display_name', _displayNameController.text.trim());
        await prefs.setString('you_tube_profile', _youtubeController.text.trim());
        await prefs.setString('facebook_profile', _facebookController.text.trim());
        await prefs.setString('instagram_profile', _instagramController.text.trim());
        await prefs.setString('linked_in_profile', _linkedinController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Update failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  PreferredSize appBarMethod() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(title: translation(context).profileItem1),
    );
  }

  void updateImageSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(translation(context).selectImage, style: colo494MSB16),
          cancelButton: CupertinoButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translation(context).cancel, style: blackMSB16),
          ),
          actions: [
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 25),
              onPressed: () => Navigator.pop(context),
              child: Text(translation(context).takePhoto, style: blackMSB16),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 25),
              onPressed: () => Navigator.pop(context),
              child: Text(translation(context).chooseFromLib, style: blackMSB16),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 25),
              onPressed: () => Navigator.pop(context),
              child: Text(translation(context).removePhoto, style: blackMSB16),
            ),
          ],
        );
      },
    );
  }
}
