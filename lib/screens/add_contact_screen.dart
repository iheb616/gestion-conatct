// Importe le package Flutter pour l'interface utilisateur
import 'package:flutter/material.dart';
// Importe le modèle Person pour créer des objets personne
import '../models/person.dart';
// Importe les fonctions de validation des champs
import '../utils/validators.dart';
// Importe l'API service pour communiquer avec le backend
import '../services/api_service.dart';

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
  final TextEditingController nomController = TextEditingController();
  // Contrôleur pour gérer le texte du champ prénom
  final TextEditingController prenomController = TextEditingController();
  // Contrôleur pour gérer le texte du champ téléphone
  final TextEditingController telephoneController = TextEditingController();
  // Clé globale pour accéder et valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Fonction async pour sauvegarder le contact
  Future<void> _saveContact() async {
    // Vérifie que le formulaire est valide (tous les champs respectent les règles)
    if (_formKey.currentState!.validate()) {
      // Crée un nouvel objet Person avec les données du formulaire
      final newPerson = Person(
        nom: nomController.text, // Récupère le nom saisi
        prenom: prenomController.text, // Récupère le prénom saisi
        telephone: telephoneController.text, // Récupère le téléphone saisi
      );
      // Sauvegarde le contact via l'API et ferme l'écran
      await _saveToApiAndClose(newPerson);
    }
  }

  // Fonction async pour sauvegarder le contact via l'API et fermer l'écran
  Future<void> _saveToApiAndClose(Person person) async {
    try {
      // Affiche un message de debug (tentative de sauvegarde)
      print('DEBUG: Attempting to save person: ${person.nom} ${person.prenom}');
      // Envoie le contact à l'API
      await ApiService.addPerson(person);
      // Affiche un message de debug (succès)
      print('DEBUG: Person saved successfully');
      // Ferme l'écran et retourne true pour signaler le succès
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Gère les erreurs qui pourraient survenir
      print('DEBUG: Error saving person: $e'); // Affiche l'erreur en debug
      // Vérifie que le widget est encore monté avant d'afficher le message d'erreur
      if (mounted) {
        // Affiche un SnackBar avec le message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
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
              // Champ de texte pour le prénom
              TextFormField(
                controller: prenomController, // Lie le champ au contrôleur
                decoration: const InputDecoration(
                  labelText: 'Prénom', // Étiquette du champ
                  border: OutlineInputBorder(), // Bordure
                  prefixIcon: Icon(Icons.person), // Icône de personne
                ),
                validator: Validators.validateName, // Valide le prénom
              ),
              // Espacement entre les champs
              const SizedBox(height: 16),
              // Champ de texte pour le nom
              TextFormField(
                controller: nomController, // Lie le champ au contrôleur
                decoration: const InputDecoration(
                  labelText: 'Nom', // Étiquette du champ
                  border: OutlineInputBorder(), // Bordure
                  prefixIcon: Icon(Icons.person_outline), // Icône
                ),
                validator: Validators.validateName, // Valide le nom
              ),
              // Espacement entre les champs
              const SizedBox(height: 16),
              // Champ de texte pour le téléphone
              TextFormField(
                controller: telephoneController, // Lie le champ au contrôleur
                decoration: const InputDecoration(
                  labelText: 'Téléphone', // Étiquette du champ
                  border: OutlineInputBorder(), // Bordure
                  prefixIcon: Icon(Icons.phone), // Icône téléphone
                ),
                keyboardType: TextInputType.phone, // Clavier numérique
                validator: Validators.validatePhone, // Valide le téléphone
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
                child: const Text('Ajouter', style: TextStyle(fontSize: 16)), // Texte du bouton
              ),
            ],
          ),
        ),
      ),
    );
  }
}
