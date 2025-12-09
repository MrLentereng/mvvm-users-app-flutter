import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/user_storage_service.dart';

class UsersViewModel extends ChangeNotifier {
  final UserStorageService _storageService;

  UsersViewModel(this._storageService);

  final List<User> _users = [];
  int? _editingIndex;

  List<User> get users => List.unmodifiable(_users);
  bool get isEditing => _editingIndex != null;
  User? get editingUser =>
      _editingIndex != null ? _users[_editingIndex!] : null;

  // Загрузка при старте
  Future<void> loadUsers() async {
    final loaded = await _storageService.loadUsers();
    _users
      ..clear()
      ..addAll(loaded);
    notifyListeners();
  }

  Future<void> _persist() async {
    await _storageService.saveUsers(_users);
  }

  // Простая валидация
  String? validateName(String value) {
    if (value.trim().isEmpty) return 'Імʼя не може бути порожнім';
    return null;
  }

  String? validateEmail(String value) {
    if (value.trim().isEmpty) return 'Email не може бути порожнім';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Невірний формат email';
    }
    return null;
  }

  String? validatePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Телефон не може бути порожнім';
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(trimmed)) {
      return 'Невірний номер телефону';
    }
    return null;
  }

  Future<String?> submitUser({
    required String name,
    required String email,
    required String phone,
    String? photoUri,
  }) async {
    // Валидация
    final nameError = validateName(name);
    final emailError = validateEmail(email);
    final phoneError = validatePhone(phone);

    if (nameError != null) return nameError;
    if (emailError != null) return emailError;
    if (phoneError != null) return phoneError;

    final normalizedName = name.trim().toLowerCase();
    final normalizedEmail = email.trim().toLowerCase();

    // дубликат по имени
    final nameDuplicateIndex = _users.indexWhere(
      (u) => u.name.toLowerCase() == normalizedName,
    );

    if (nameDuplicateIndex != -1 &&
        (_editingIndex == null || nameDuplicateIndex != _editingIndex)) {
      return 'Користувач з таким імʼям вже існує';
    }

    // дубликат по email
    final emailDuplicateIndex = _users.indexWhere(
      (u) => u.email.toLowerCase() == normalizedEmail,
    );

    if (emailDuplicateIndex != -1 &&
        (_editingIndex == null || emailDuplicateIndex != _editingIndex)) {
      return 'Користувач з таким email вже існує';
    }

    if (_editingIndex == null) {
      // Новый юзер
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: normalizedName,
        email: normalizedEmail,
        phone: phone.trim(),
        photoUri: photoUri,
      );
      _users.add(newUser);
    } else {
      // Редактирование
      final updated = _users[_editingIndex!].copyWith(
        name: normalizedName,
        email: normalizedEmail,
        phone: phone.trim(),
        photoUri: photoUri,
      );
      _users[_editingIndex!] = updated;
    }

    _editingIndex = null;
    notifyListeners();
    await _persist();

    return null; // null = всё ок, ошибок нет
  }


  Future<void> deleteUser(int index) async {
    if (index < 0 || index >= _users.length) return;
    _users.removeAt(index);
    if (_editingIndex == index) {
      _editingIndex = null;
    }
    notifyListeners();
    await _persist();
  }

  void startEdit(int index) {
    if (index < 0 || index >= _users.length) return;
    _editingIndex = index;
    notifyListeners();
  }

  void cancelEdit() {
    _editingIndex = null;
    notifyListeners();
  }
}
