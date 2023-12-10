import 'package:flutter/material.dart';
import 'package:personal_cards_reader/data/crud_operation.dart';
import 'package:personal_cards_reader/main.dart';

class FormFields extends StatefulWidget {
  const FormFields({super.key});

  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add cards info'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Full name',
              textScaler: TextScaler.linear(1.3),
            ),
            TextFormField(
              controller: _nameController,
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              'Company name',
              textScaler: TextScaler.linear(1.3),
            ),
            TextFormField(
              controller: _companyController,
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              'Phone Number',
              textScaler: TextScaler.linear(1.3),
            ),
            TextFormField(
              controller: _phoneController,
            ),
            const SizedBox(
              height: 64,
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Main(),
                      ),
                    );
                  });
                },
                child: const Text('Save card info'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
