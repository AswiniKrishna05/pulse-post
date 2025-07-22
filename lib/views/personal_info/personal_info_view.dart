import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/navigation/app_routes.dart';
import '../../viewmodels/personal_info_viewmodel.dart';
import '../auth/otp_verification_view.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';
import 'interests_categories_view.dart';
import 'dart:async';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  Timer? _confirmPasswordTimer;
  bool _phoneDirty = false;
  bool _passwordDirty = false;
  Timer? _passwordStrengthTimer;
  bool _showPasswordStrength = false;

  @override
  void dispose() {
    _confirmPasswordTimer?.cancel();
    _passwordStrengthTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PersonalInfoViewModel>(context);

    // Fetch location only once when the widget is built and location fields are empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.city.isEmpty && vm.state.isEmpty && vm.country.isEmpty && vm.pinCode.isEmpty) {
        vm.fetchAndSetLocation();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.signUp
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.createAccount
                  , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text(AppStrings.takePhoto
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                vm.pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text(AppStrings.chooseFromGallery
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                vm.pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: vm.profileImage != null ? FileImage(vm.profileImage!) : null,
                    child: vm.profileImage == null ? const Icon(Icons.person, size: 40) : null,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              CustomTextField(
                label: AppStrings.fullName,
                hint: AppStrings.enterFullName,
                onChanged: (val) => vm.updateField(AppStrings.fullName, val),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: AppStrings.email,
                hint: AppStrings.enterEmail,
                onChanged: (val) => vm.updateField(AppStrings.email, val),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          label: AppStrings.mobileNumber,
                          hint: AppStrings.enterNumber,
                          onChanged: (val) {
                            if (!_phoneDirty) {
                              setState(() {
                                _phoneDirty = true;
                              });
                            }
                            vm.updateField('mobile', val);
                          },
                          borderColor: _phoneDirty && vm.getPhoneNumberError() != null ? Colors.red : null,
                          keyboardType: TextInputType.number,
                        ),
                        if (_phoneDirty && vm.getPhoneNumberError() != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                            child: Text(
                              vm.getPhoneNumberError()!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: vm.getPhoneNumberError() == null && vm.mobile.isNotEmpty && !vm.isPhoneVerified
                        ? () async {
                            await vm.sendOtp('+91${vm.mobile}', context);
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OTPVerificationView(
                                  phoneNumber: '+91${vm.mobile}',
                                  verificationId: vm.verificationId,
                                ),
                              ),
                            );
                            if (result == true) {
                              vm.isPhoneVerified = true;
                              vm.notifyListeners();
                            }
                          }
                        : null,
                    child: Text(vm.isPhoneVerified ? AppStrings.otpVerified
                        : (vm.isOtpSent ? AppStrings.resendOtp
                        : AppStrings.sendOtp
                    )),
                  ),
                  if (vm.isPhoneVerified)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.verified, color: Colors.green),
                    ),
                ],
              ),
              if (vm.isOtpSent && !vm.isPhoneVerified) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label:AppStrings.enterOtp
                        ,
                        hint: AppStrings.sixDigitCode
                        ,
                        onChanged: (val) => vm.otpCode = val,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: vm.otpCode.length == 6
                          ? () => vm.verifyOtp(vm.otpCode, context)
                          : null,
                      child: const Text(AppStrings.verifyOtp
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.password,
                hint: AppStrings.enterPassword,
                obscure: true,
                onChanged: (val) {
                  if (!_passwordDirty) {
                    setState(() {
                      _passwordDirty = true;
                    });
                  }
                  vm.updateField(AppStrings.password, val);
                  final error = vm.getPasswordErrorMessage();
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error)),
                    );
                  }
                  _passwordStrengthTimer?.cancel();
                  setState(() {
                    _showPasswordStrength = false;
                  });
                  _passwordStrengthTimer = Timer(const Duration(seconds: 1), () {
                    if (mounted) {
                      setState(() {
                        _showPasswordStrength = true;
                      });
                    }
                  });
                },
                borderColor: vm.showPasswordMismatchError || vm.showPasswordCapitalError || vm.showPasswordSpecialCharError ? Colors.red : null,
              ),
              if (_passwordDirty && _showPasswordStrength)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Text('Strength: ', style: TextStyle(fontSize: 12)),
                      Text(
                        vm.passwordStrength,
                        style: TextStyle(
                          fontSize: 12,
                          color: vm.passwordStrength == 'Strong'
                              ? Colors.green
                              : vm.passwordStrength == 'Medium'
                                  ? Colors.orange
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.confirmPassword,
                hint: AppStrings.reEnterPassword,
                obscure: true,
                onChanged: (val) => vm.updateField(AppStrings.confirmPassword, val),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) vm.setDob(picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: AppStrings.dateOfBirth
                    ,
                    border: OutlineInputBorder(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vm.dob != null ? vm.dob!.toLocal().toString().split(' ')[0] : 'Pick a Date'),
                      if (vm.dob != null) ...[
                        const SizedBox(height: 4),
                        Text('Age: ${vm.age}', style: const TextStyle(fontSize: 16)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(AppStrings.gender
                  , style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<String>(
                    value: AppStrings.male,
                    groupValue: vm.gender,
                    onChanged: (value) => vm.updateField(AppStrings.genderKey, value!),
                  ),
                  const Text(AppStrings.male),
                  Radio<String>(
                    value: AppStrings.female,
                    groupValue: vm.gender,
                    onChanged: (value) => vm.updateField(AppStrings.genderKey, value!),
                  ),
                  const Text(AppStrings.female),
                  Radio<String>(
                    value: AppStrings.other,
                    groupValue: vm.gender,
                    onChanged: (value) => vm.updateField(AppStrings.genderKey, value!),
                  ),
                  const Text(AppStrings.other),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          onSelect: (Country country) {
                            vm.updateField(AppStrings.country
                                , country.name);
                          },
                        );
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: AppStrings.country
                          ,
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          vm.country.isNotEmpty ? vm.country : AppStrings.selectYourCountry
                          ,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: vm.state.isNotEmpty ? vm.state : null,
                      decoration: const InputDecoration(labelText: AppStrings.state
                          , border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Kerala', child: Text('Kerala')),
                        DropdownMenuItem(value: 'Maharashtra', child: Text('Maharashtra')),
                        DropdownMenuItem(value: 'Delhi', child: Text('Delhi')),
                      ],
                      onChanged: (val) => vm.updateField('state', val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: AppStrings.city
                      ,
                      hint: AppStrings.enterCity
                      ,
                      controller: vm.cityController,
                      onChanged: (val) => vm.updateField(AppStrings.city, val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      label: 'Pin Code',
                      hint: 'Enter Pincode',
                      controller: vm.pinCodeController,
                      onChanged: (val) => vm.updateField('pinCode', val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: vm.qualification.isNotEmpty &&
                    ['10th', 'plustwo', 'diploma', 'bachelor of degree', 'master of degree', 'others'].contains(vm.qualification)
                    ? vm.qualification
                    : 'others',
                decoration: const InputDecoration(labelText: 'Qualification', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: '10th', child: Text('10th')),
                  DropdownMenuItem(value: 'plustwo', child: Text('Plustwo')),
                  DropdownMenuItem(value: 'diploma', child: Text('Diploma')),
                  DropdownMenuItem(value: 'bachelor of degree', child: Text('Bachelor of Degree')),
                  DropdownMenuItem(value: 'master of degree', child: Text('Master of Degree')),
                  DropdownMenuItem(value: 'others', child: Text('Others')),
                ],
                onChanged: (val) {
                  if (val == 'others') {
                    vm.updateField('qualification', 'others');
                  } else {
                    vm.updateField('qualification', val!);
                  }
                },
              ),
              if (vm.qualification == 'others')
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomTextField(
                    label: 'Please specify',
                    hint: 'Enter your qualification',
                    onChanged: (val) => vm.updateField('customQualification', val),
                  ),
                ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Occupation',
                hint: 'Occupation',
                onChanged: (val) => vm.updateField('occupation', val),
              ),
              const SizedBox(height: 24),

              const InterestsCategoriesView(),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Referral Code (Optional)',
                hint: 'Enter referral code',
                onChanged: (val) => vm.updateField('referral', val),
              ),
              const SizedBox(height: 24),

              GestureDetector(
                onTap: () {
                  if (vm.isFormValid) {
                    vm.saveToFirestore(context);
                  } else {
                    final error = vm.getValidationErrorMessage();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.isNotEmpty ? error : 'Please fill all required fields correctly.'),
                      ),
                    );
                  }
                },
                child: AbsorbPointer(
                  absorbing: !vm.isFormValid,
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Continue',
                      onPressed: vm.isFormValid
                          ? () => vm.saveToFirestore(context)
                          : () {
                        final error = vm.getValidationErrorMessage();
                        if (error.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        }
                      },

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
