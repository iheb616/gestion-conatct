// Importe le package Flutter pour l'interface utilisateur
import 'package:flutter/material.dart';
// Importe le modèle Person pour gérer les objets contact
import '../models/person.dart';
// Importe les fonctions de validation des champs
import '../utils/validators.dart';
// Importe l'API service pour communiquer avec le backend
import '../services/api_service.dart';

// Classe principale - écran pour modifier un contact existant (StatefulWidget)
// StatefulWidget car l'état du formulaire change au cours de l'édition
class EditContactScreen extends StatefulWidget {
  // Contact à modifier passé en paramètre
  final Person contact;

  // Constructeur avec le contact requis
  const EditContactScreen({super.key, required this.contact});

  // Crée l'état associé au widget
  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

// Classe d'état qui gère la logique et l'interface du formulaire d'édition
class _EditContactScreenState extends State<EditContactScreen> {
  // Contrôleur pour gérer le texte du champ nom (late = initialisé plus tard)
  late final TextEditingController nomController;
  // Contrôleur pour gérer le texte du champ prénom
  late final TextEditingController prenomController;
  // Contrôleur pour gérer le texte du champ téléphone
  late final TextEditingController telephoneController;
  // Clé globale pour accéder et valider le formulaire
  final _formKey = GlobalKey<FormState>();
  // Variable pour suivre l'état de chargement (afficher spinner lors de la mise à jour)
  bool _isLoading = false;

  // Méthode appelée une seule fois lors de la création du widget
  @override
  void initState() {
    super.initState();
    // Initialise les contrôleurs avec les valeurs actuelles du contact
    nomController = TextEditingController(text: widget.contact.nom);
    prenomController = TextEditingController(text: widget.contact.prenom);
    telephoneController = TextEditingController(text: widget.contact.telephone);
  }

  // Méthode appelée lors de la destruction du widget pour libérer les ressources
  @override
  void dispose() {
    // Libère la mémoire utilisée par les contrôleurs
    nomController.dispose();
    prenomController.dispose();
    telephoneController.dispose();
    super.dispose();
  }

  // Fonction asynchrone pour mettre à jour le contact
  Future<void> _updateContact() async {
    // Vérifie que le formulaire est valide (tous les champs respectent les règles)
    if (_formKey.currentState!.validate()) {
      // Active l'état de chargement pour afficher le spinner
      setState(() => _isLoading = true);
      
      // Crée un objet Person avec les nouvelles données du formulaire
      final updatedPerson = Person(
        id: widget.contact.id, // Garde le même ID
        nom: nomController.text.trim(), // Récupère et nettoie le nom
        prenom: prenomController.text.trim(), // Récupère et nettoie le prénom
        telephone: telephoneController.text.trim(), // Récupère et nettoie le téléphone
      );

      try {
        // Envoie la requête de mise à jour au backend via l'API
        await ApiService.updatePerson(updatedPerson);
        // Vérifie que le widget est toujours monté avant d'interagir avec le contexte
        if (mounted) {
          // Retourne à l'écran précédent avec succès (true = rafraîchir la liste)
          Navigator.pop(context, true);
          // Affiche un message de succès vert
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        // En cas d'erreur, affiche un message d'erreur
        if (mounted) {
          // Désactive l'état de chargement
          setState(() => _isLoading = false);
          // Affiche un message d'erreur rouge avec le détail de l'erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Contact'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: nomController,
                style: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'Enter last name',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF374151)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9CA3AF), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9CA3AF), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2.5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: Validators.validateName,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: prenomController,
                style: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'Enter first name',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF374151)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9CA3AF), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9CA3AF), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2.5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: Validators.validateName,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: telephoneController,
                style: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'Enter phone number',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF374151)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9CA3AF), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9CA3AF), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2.5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: Validators.validatePhone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateContact,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Update Contact',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
