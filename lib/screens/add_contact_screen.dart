// Importe le package Flutter pour l'interface utilisateur
import 'package:flutter/material.dart';
// Importe le modèle Contact pour créer des objets contact
import '../models/contact.dart';
// Importe les fonctions de validation des champs
import '../utils/validators.dart';
// Importe le helper pour les opérations de base de données
import '../utils/database_helper.dart';

// Classe principale - écran pour ajouter un nouveau contact (StatefulWidget)
// StatefulWidget car l'état du formulaire change au cours de l'interaction
class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  // Crée l'état associé au widget
  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

// Classe d'état qui gère la logique et l'interface du formulaire
class _AddContactScreenState extends State<AddContactScreen> {
  // Contrôleur pour gérer le texte du champ nom
  final TextEditingController nameController = TextEditingController();
  // Contrôleur pour gérer le texte du champ téléphone
  final TextEditingController phoneController = TextEditingController();
  // Contrôleur pour gérer le texte du champ email
  final TextEditingController emailController = TextEditingController();
  // Clé globale pour accéder et valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Fonction async pour sauvegarder le contact
  Future<void> _saveContact() async {
    // Vérifie que le formulaire est valide (tous les champs respectent les règles)
    if (_formKey.currentState!.validate()) {
      // Crée un nouvel objet Contact avec les données du formulaire
      final newContact = Contact(
        name: nameController.text, // Récupère le nom saisi
        phone: phoneController.text, // Récupère le téléphone saisi
        email: emailController.text, // Récupère l'email saisi
      );
      // Sauvegarde le contact en BD et ferme l'écran
      await _saveToDbAndClose(newContact);
    }
  }

  // Fonction async pour sauvegarder le contact en BD et fermer l'écran
  Future<void> _saveToDbAndClose(Contact contact) async {
    try {
      // Affiche un message de debug (tentative de sauvegarde)
      print('DEBUG: Attempting to save contact: ${contact.name}');
      // Insère le contact dans la base de données (convertit Contact en Map)
      await DatabaseHelper.instance.insertContact(contact.toMap());
      // Affiche un message de debug (succès)
      print('DEBUG: Contact saved successfully');
      // Ferme l'écran et retourne true pour signaler le succès
      Navigator.pop(context, true);
    } catch (e) {
      // Gère les erreurs qui pourraient survenir
      print('DEBUG: Error saving contact: $e'); // Affiche l'erreur en debug
      // Vérifie que le widget est encore monté avant d'afficher le message d'erreur
      if (mounted) {
        // Affiche un SnackBar avec le message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving contact: $e')),
        );
      }
    }
  }

  // Méthode build() - construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Retourne un Scaffold (structure de base d'un écran)
    return Scaffold(
      // AppBar - barre en haut de l'écran
      appBar: AppBar(
        title: const Text('Add New Contact'), // Titre de l'écran
        backgroundColor: Theme.of(context).colorScheme.primary, // Couleur de fond
        foregroundColor: Theme.of(context).colorScheme.onPrimary, // Couleur du texte
      ),
      // Corps principal de l'écran
      body: Padding(
        padding: const EdgeInsets.all(16), // Espacement autour du formulaire
        child: Form(
          key: _formKey, // Associe la clé du formulaire au Form
          child: Column(
            // Colonne pour empiler les champs verticalement
            children: [
              // Champ de texte pour le nom
              TextFormField(
                controller: nameController, // Lie le champ au contrôleur
                decoration: const InputDecoration(
                  labelText: 'Name', // Étiquette du champ
                  border: OutlineInputBorder(), // Bordure
                  prefixIcon: Icon(Icons.person), // Icône de personne
                ),
                validator: Validators.validateName, // Valide le nom
              ),
              // Espacement entre les champs
              const SizedBox(height: 16),
              // Champ de texte pour le téléphone
              TextFormField(
                controller: phoneController, // Lie le champ au contrôleur
                decoration: const InputDecoration(
                  labelText: 'Phone', // Étiquette du champ
                  border: OutlineInputBorder(), // Bordure
                  prefixIcon: Icon(Icons.phone), // Icône téléphone
                ),
                keyboardType: TextInputType.phone, // Clavier numérique
                validator: Validators.validatePhone, // Valide le téléphone
              ),
              // Espacement entre les champs
              const SizedBox(height: 16),
              // Champ de texte pour l'email
              TextFormField(
                controller: emailController, // Lie le champ au contrôleur
                decoration: const InputDecoration(
                  labelText: 'Email', // Étiquette du champ
                  border: OutlineInputBorder(), // Bordure
                  prefixIcon: Icon(Icons.email), // Icône email
                ),
                keyboardType: TextInputType.emailAddress, // Clavier email
                validator: Validators.validateEmail, // Valide l'email
              ),
              // Espacement avant le bouton
              const SizedBox(height: 24),
              // Bouton pour sauvegarder le contact
              ElevatedButton(
                onPressed: () => _saveContact(), // Appelle _saveContact quand on clique
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // Couleur de fond
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // Couleur du texte
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Espacement interne
                ),
                child: const Text('Save Contact', style: TextStyle(fontSize: 16)), // Texte du bouton
              ),
            ],
          ),
        ),
      ),
    );
  }
}
