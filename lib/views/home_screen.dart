import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/users_view_model.dart';
import '../viewmodels/theme_view_model.dart';
import 'widgets/users_list.dart';
import 'widgets/user_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsersViewModel>();
    final themeVm = context.watch<ThemeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users MVVM (Flutter)'),
        actions: [
          IconButton(
            tooltip: 'Перемкнути тему',
            icon: Icon(
              themeVm.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              themeVm.toggleTheme();
            },
          ),
        ],
      ),
      body: UsersList(
        users: vm.users,
        onEdit: (index) {
          vm.startEdit(index);
          showDialog(
            context: context,
            builder: (_) => const UserForm(),
          );
        },
        onDelete: (index) {
          vm.deleteUser(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          vm.cancelEdit();
          showDialog(
            context: context,
            builder: (_) => const UserForm(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
