import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/users_view_model.dart';
import '../../services/image_service.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _phone;

  final ImageService _imageService = ImageService();
  String? _photoUri;

  @override
  void initState() {
    super.initState();

    final vm = context.read<UsersViewModel>();
    final editing = vm.editingUser;

    _name = TextEditingController(text: editing?.name ?? '');
    _email = TextEditingController(text: editing?.email ?? '');
    _phone = TextEditingController(text: editing?.phone ?? '');
    _photoUri = editing?.photoUri;
  }

  Future<void> _pickPhoto() async {
    final path = await _imageService.pickImageFromGallery();
    if (path == null) {
      // На Linux/desktop сюда будем часто попадать — просто игнор
      return;
    }
    setState(() {
      _photoUri = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsersViewModel>();

    return AlertDialog(
      title: Text(
        vm.isEditing ? 'Редагування користувача' : 'Додати користувача',
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Аватар + кнопка выбрать фото
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: _photoUri == null || _photoUri!.isEmpty
                        ? Text(
                            _name.text.isNotEmpty
                                ? _name.text[0].toUpperCase()
                                : '?',
                          )
                        : ClipOval(
                            child: Image.file(
                              File(_photoUri!),
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickPhoto,
                      icon: const Icon(Icons.photo),
                      label: const Text('Обрати фото'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Імʼя'),
                validator: (v) => vm.validateName(v ?? ''),
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => vm.validateEmail(v ?? ''),
              ),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Телефон'),
                validator: (v) => vm.validatePhone(v ?? ''),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            vm.cancelEdit();
            Navigator.of(context).pop();
          },
          child: const Text('Скасувати'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final error = await vm.submitUser(
              name: _name.text,
              email: _email.text,
              phone: _phone.text,
              photoUri: _photoUri,
            );

            if (!mounted) return;

            if (error != null) {
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Помилка'),
                  content: Text(error),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              return;
            }

            Navigator.of(context).pop();
          },
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
