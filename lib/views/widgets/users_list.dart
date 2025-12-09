import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/user.dart';

class UsersList extends StatelessWidget {
  final List<User> users;
  final void Function(int index) onEdit;
  final void Function(int index) onDelete;

  const UsersList({
    super.key,
    required this.users,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Text('Користувачів поки немає'),
      );
    }

    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = users[index];
        final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

        Widget avatarChild;
        if (user.photoUri != null && user.photoUri!.isNotEmpty) {
          avatarChild = ClipOval(
            child: Image(
              image: FileImage(File(user.photoUri!)),
              fit: BoxFit.cover,
              width: 40,
              height: 40,
            ),
          );
        } else {
          avatarChild = Text(initial);
        }

        return ListTile(
          leading: CircleAvatar(
            child: avatarChild,
          ),
          title: Text(user.name),
          subtitle: Text('${user.email}\n${user.phone}'),
          isThreeLine: true,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => onEdit(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(index),
              ),
            ],
          ),
        );
      },
    );
  }
}
