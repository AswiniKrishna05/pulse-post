import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_routes.dart';
import '../../viewmodels/personal_info_viewmodel.dart';
import '../auth/otp_verification_view.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';
import 'interests_categories_view.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

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
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                              title: const Text("Take Photo"),
                              onTap: () {
                                Navigator.pop(context);
                                vm.pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text("Choose from Gallery"),
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
                label: 'Full Name',
                hint: 'Enter your Full Name',
                onChanged: (val) => vm.updateField('fullName', val),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Email',
                hint: 'Enter email',
                onChanged: (val) => vm.updateField('email', val),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Mobile Number',
                      hint: 'Enter number',
                      onChanged: (val) => vm.updateField('mobile', val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: vm.mobile.isNotEmpty && !vm.isPhoneVerified
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
                    child: Text(vm.isPhoneVerified ? 'OTP Verified' : (vm.isOtpSent ? 'Resend OTP' : 'Send OTP')),
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
                        label: 'Enter OTP',
                        hint: '6-digit code',
                        onChanged: (val) => vm.otpCode = val,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: vm.otpCode.length == 6
                          ? () => vm.verifyOtp(vm.otpCode, context)
                          : null,
                      child: const Text('Verify OTP'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                hint: 'Enter password',
                obscure: true,
                onChanged: (val) => vm.updateField('password', val),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Confirm Password',
                hint: 'Re-enter password',
                obscure: true,
                onChanged: (val) => vm.updateField('confirmPassword', val),
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
                    labelText: 'Date of Birth',
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

              const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: vm.gender,
                    onChanged: (value) => vm.updateField('gender', value!),
                  ),
                  const Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: vm.gender,
                    onChanged: (value) => vm.updateField('gender', value!),
                  ),
                  const Text('Female'),
                  Radio<String>(
                    value: 'Other',
                    groupValue: vm.gender,
                    onChanged: (value) => vm.updateField('gender', value!),
                  ),
                  const Text('Other'),
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
                            vm.updateField('country', country.name);
                          },
                        );
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          vm.country.isNotEmpty ? vm.country : 'Select your country',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: vm.state.isNotEmpty ? vm.state : null,
                      decoration: const InputDecoration(labelText: 'State', border: OutlineInputBorder()),
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
                      label: 'City',
                      hint: 'Enter City',
                      controller: vm.cityController,
                      onChanged: (val) => vm.updateField('city', val),
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
                hint: 'Select Occupation',
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
