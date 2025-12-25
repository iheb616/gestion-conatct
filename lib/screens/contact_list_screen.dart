// Importe les packages et fichiers nécessaires
import 'package:flutter/material.dart'; // Package Flutter pour l'interface utilisateur
import '../models/person.dart'; // Modèle Person
import '../widgets/contact_card.dart'; // Widget pour afficher une carte de contact
import '../widgets/empty_state.dart'; // Widget pour afficher un état vide
import 'add_contact_screen.dart'; // Écran pour ajouter un contact
import '../services/api_service.dart'; // API service pour communiquer avec le backend

// Classe principale - écran de liste des contacts (StatefulWidget)
// Un StatefulWidget car l'état change (ajout, suppression, recherche de contacts)
class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  // Crée l'état associé au widget
  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

// Classe d'état qui gère la logique et l'UI de l'écran
class _ContactListScreenState extends State<ContactListScreen> {
  // Liste pour stocker tous les contacts récupérés de l'API
  final List<Person> contacts = [];
  
  // Contrôleur pour gérer le texte dans le champ de recherche
  final TextEditingController _searchController = TextEditingController();
  
  // Variable pour stocker le texte de recherche actuel (en minuscules et trimé)
  String _search = '';

  // Méthode initState() - appelée une fois au démarrage du widget
  @override
  void initState() {
    super.initState();
    // Initialise la base de données (si nécessaire) et charge les contacts
    _initAndLoad();
    
    // Ajoute un écouteur au champ de recherche pour détecter les changements
    _searchController.addListener(() {
      setState(() {
        // Met à jour _search avec le texte du contrôleur (en minuscules et sans espaces)
        _search = _searchController.text.trim().toLowerCase();
      });
    });
  }

  // Fonction async pour initialiser et charger les contacts
  Future<void> _initAndLoad() async {
    // Charge les contacts depuis l'API
    await _loadContacts();
  }

  // Fonction async pour charger tous les contacts depuis l'API
  Future<void> _loadContacts() async {
    try {
      // Récupère tous les contacts depuis l'API
      final persons = await ApiService.getPersons();
      // Met à jour l'UI avec setState
      setState(() {
        // Vide la liste actuelle et ajoute les nouveaux contacts
        contacts
          ..clear() // Vide la liste
          ..addAll(persons); // Ajoute les nouveaux contacts
      });
    } catch (e) {
      print('Error loading contacts: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement: $e')),
        );
      }
    }
  }

  // Fonction async pour supprimer un contact par son ID
  Future<void> _deleteContact(int? id) async {
    // Vérifie que l'ID n'est pas null
    if (id == null) return;
    try {
      // Supprime le contact via l'API
      await ApiService.deletePerson(id);
      // Recharge la liste des contacts pour refléter la suppression
      await _loadContacts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact supprimé avec succès')),
        );
      }
    } catch (e) {
      print('Error deleting contact: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression: $e')),
        );
      }
    }
  }

  // Fonction async pour naviguer vers l'écran d'ajout de contact
  Future<void> _navigateToAddContact() async {
    // Navigue vers AddContactScreen et attend un résultat booléen
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
    );
    // Si le résultat est true (contact ajouté avec succès), recharge la liste
    if (result == true) {
      await _loadContacts();
    }
  }

  // Méthode build() - construit l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    // Filtre les contacts en fonction de la recherche
    // Si _search est vide, affiche tous les contacts
    // Sinon, affiche uniquement les contacts dont le nom ou prénom contient le texte de recherche
    final filteredContacts = _search.isEmpty
        ? contacts
        : contacts.where((c) => 
            c.nom.toLowerCase().contains(_search) ||
            c.prenom.toLowerCase().contains(_search)).toList();
    
    // Retourne l'interface principale (Scaffold)
    return Scaffold(
      // AppBar - barre en haut de l'écran
      appBar: AppBar(
        title: const Text('My Contacts'), // Titre de l'écran
        backgroundColor: Theme.of(context).colorScheme.primary, // Couleur de fond
        foregroundColor: Theme.of(context).colorScheme.onPrimary, // Couleur du texte
        
        // Partie inférieure de l'AppBar - barre de recherche
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56), // Hauteur de la barre de recherche
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), // Espacement
            child: SizedBox(
              height: 40, // Hauteur du champ de texte
              child: TextField(
                controller: _searchController, // Lie le champ au contrôleur
                decoration: InputDecoration(
                  hintText: 'Search by name', // Texte d'indice
                  prefixIcon: const Icon(Icons.search), // Icône de recherche
                  
                  // Bouton X pour effacer le texte (affiché si le champ n'est pas vide)
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear(); // Efface le texte
                          },
                        ),
                  
                  // Style de la bordure
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Bordure arrondie
                    borderSide: BorderSide.none, // Sans bordure
                  ),
                  filled: true, // Remplir le champ de couleur
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0), // Espacement interne
                ),
              ),
            ),
          ),
        ),
      ),
      
      // Corps principal - affiche la liste des contacts ou un état vide
      body: filteredContacts.isEmpty
          ? const EmptyState() // Affiche EmptyState si aucun contact
          : ListView.builder(
              itemCount: filteredContacts.length, // Nombre d'éléments dans la liste
              itemBuilder: (context, index) {
                // Récupère le contact à l'index courant
                final contact = filteredContacts[index];
                // Retourne un ContactCard pour afficher le contact
                return ContactCard(
                  contact: contact,
                  onDelete: () => _deleteContact(contact.id), // Callback de suppression
                );
              },
            ),
      
      // Bouton flottant en bas à droite pour ajouter un contact
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddContact, // Navigue vers l'écran d'ajout
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add), // Icône +
      ),
    );
  }

  // Méthode dispose() - appelée avant la destruction du widget
  @override
  void dispose() {
    _searchController.dispose(); // Libère les ressources du contrôleur
    super.dispose();
  }
}