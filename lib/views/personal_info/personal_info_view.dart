import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_routes.dart';
import '../../viewmodels/personal_info_viewmodel.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';


class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PersonalInfoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Create Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GestureDetector(
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
                child: vm.profileImage == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
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
                ElevatedButton(onPressed: () {}, child: const Text('Send OTP')),
              ],
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

            DropdownButtonFormField<String>(
              value: vm.gender.isNotEmpty ? vm.gender : null,
              decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (val) => vm.updateField('gender', val!),
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
                      DropdownMenuItem(value: 'kerala', child: Text('Kerala')),
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
                    onChanged: (val) => vm.updateField('city', val),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextField(
                    label: 'Pin Code',
                    hint: 'Enter Pincode',
                    onChanged: (val) => vm.updateField('pin', val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Qualification',
              hint: 'Select Qualification',
              onChanged: (val) => vm.updateField('qualification', val),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Occupation',
              hint: 'Select Occupation',
              onChanged: (val) => vm.updateField('occupation', val),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Referral Code (Optional)',
              hint: 'Enter referral code',
              onChanged: (val) => vm.updateField('referral', val),
            ),
            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Continue',
              onPressed: () => vm.saveProfileToFirestore(context),
            ),


          ],
        ),
      ),
    );
  }
}
