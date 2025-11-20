import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../widgets/contact_card.dart';
import '../widgets/empty_state.dart';
import 'add_contact_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final List<Contact> contacts = [];

  void _addContact(Contact contact) {
    setState(() {
      contacts.add(contact);
    });
  }

  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  void _navigateToAddContact() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactScreen(onAddContact: _addContact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contacts'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: contacts.isEmpty
          ? const EmptyState()
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ContactCard(
                  contact: contacts[index],
                  onDelete: () => _deleteContact(index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddContact,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}