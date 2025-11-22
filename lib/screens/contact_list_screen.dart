import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../widgets/contact_card.dart';
import '../widgets/empty_state.dart';
import 'add_contact_screen.dart';
import '../utils/database_helper.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final List<Contact> contacts = [];
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _initAndLoad();
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text.trim().toLowerCase();
      });
    });
  }

  Future<void> _initAndLoad() async {
    await DatabaseHelper.instance.initForDesktopIfNeeded();
    await _loadContacts();
  }

  Future<void> _loadContacts() async {
    final rows = await DatabaseHelper.instance.getAllContacts();
    setState(() {
      contacts
        ..clear()
        ..addAll(rows.map((r) => Contact.fromMap(r)).toList());
    });
  }

  Future<void> _deleteContact(int? id) async {
    if (id == null) return;
    await DatabaseHelper.instance.deleteContact(id);
    await _loadContacts();
  }

  Future<void> _navigateToAddContact() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
    );
    if (result == true) {
      await _loadContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = _search.isEmpty
        ? contacts
        : contacts.where((c) => c.name.toLowerCase().contains(_search)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contacts'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: filteredContacts.isEmpty
          ? const EmptyState()
          : ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return ContactCard(
                  contact: contact,
                  onDelete: () => _deleteContact(contact.id),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}