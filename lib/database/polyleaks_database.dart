import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polyleaks/models/capteur_model.dart';
import 'package:polyleaks/models/parametres_model.dart';

class PolyleaksDatabase extends ChangeNotifier {
  static late Isar isar;

  // INITIALISATION DE LA BASE DE DONNEES ---------------------------------------
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([CapteurModelSchema, ParametresModelSchema], directory: dir.path);
  }




  
  // PARAMETRES -----------------------------------------------------------------
  // parametres généraux de l'application
  final Map<String, int> _parametres = {'langue': 0, 'theme': 0};

  Map<String, int> get parametres => _parametres;

  Locale get langue => _parametres['langue'] == 0 ? const Locale('fr') : const Locale('en');

  // sauvegardes temporaires
  int _historiqueIndexPage = 0;
  int get historiqueIndexPage => _historiqueIndexPage;
  set historiqueIndexPage(int index) {
    _historiqueIndexPage = index;
    notifyListeners();
  }

  Map<String, double> _cameraPosition = {'latitude': 47.217246, 'longitude': -1.553691, 'zoom': 11.5, 'tilt': 0.0, 'bearing': 0.0};
  Map<String, double> get cameraPosition => _cameraPosition;
  set cameraPosition(Map<String, double> position) {
    _cameraPosition = position;
    notifyListeners();
  }

  // definition des parametres par defaut ---------------------------------------
  Future<void> parametresParDefaut() async {
    // chercher un parametre dont le nom est "langue"
    final parametreLangue = await isar.parametresModels.filter().nomEqualTo('langue').findFirst();
    if (parametreLangue == null) {
      // si le parametre n'existe pas, le creer
      final langue = ParametresModel()..nom = 'langue'..valeur = 0;
      await isar.writeTxn(() => isar.parametresModels.put(langue));
      _parametres['langue'] = 0;
    }
    else {
      _parametres['langue'] = parametreLangue.valeur;
    }

    // chercher un parametre dont le nom est "theme"
    final parametreTheme = await isar.parametresModels.filter().nomEqualTo('theme').findFirst();
    if (parametreTheme == null) {
      // si le parametre n'existe pas, le creer
      final theme = ParametresModel()..nom = 'theme'..valeur = 0;
      await isar.writeTxn(() => isar.parametresModels.put(theme));
      _parametres['theme'] = 0;
    }
    else{
      _parametres['theme'] = parametreTheme.valeur;
    }
    notifyListeners();
  }


  // obtenir un paramtre
  Future<void> getParametres() async {
    final parametresBDD = await isar.parametresModels.where().findAll();
    for (final parametre in parametresBDD) {
      _parametres[parametre.nom] = parametre.valeur;
    }
    notifyListeners();
  }


  // definir un parametre
  Future<void> setParametre(String nom, int valeur) async {
    final parametre = await isar.parametresModels.filter().nomEqualTo(nom).findFirst();
    final param = parametre!..valeur = valeur;
    await isar.writeTxn(() => isar.parametresModels.put(param));

    _parametres[nom] = valeur;
    notifyListeners();
  }






  // CAPTEURS -------------------------------------------------------------------
  
  // verifier si un capteur existe
  Future<bool> capteurExiste(String nom) async {
    final capteur = await isar.capteurModels.filter().nomEqualTo(nom).findFirst();
    return capteur != null;
  }

  // ajouter un capteur a la base de donnees
  Future<void> ajouterCapteur(String nom, int batterie, DateTime dateInitialisation, List<double> localisation) async {
    final capteurExistant = await capteurExiste(nom);
    if (!capteurExistant) {
      final capteur = CapteurModel()
        ..nom = nom
        ..batterie = batterie
        ..dateInitialisation = dateInitialisation
        ..dateDerniereConnexion = DateTime.now()
        ..valeur = null
        ..localisation = localisation;
      await isar.writeTxn(() => isar.capteurModels.put(capteur));
    }
  }


  // GET - obtenir tous les details d'un capteur sous forme de Map
    /// a utiliser pour afficher les details d'un capteur
  Future<Map<String, dynamic>> getDetailsCapteur(String nom) async {
    final capteur = await isar.capteurModels.filter().nomEqualTo(nom).findFirst();
    return {
      'id': capteur!.id,
      'nom': capteur.nom,
      'valeur': capteur.valeur,
      'batterie': capteur.batterie,
      'dateDerniereConnexion': capteur.dateDerniereConnexion,
      'dateInitialisation': capteur.dateInitialisation,
      'localisation': capteur.localisation,
    };
  }


  // GET - obtenir une liste de markers Gmaps des nom et position des capteurs
    /// a utiliser pour afficher sur la carte
  Future<List<Map<String, dynamic>>> getLocalisationCapteurs() async {
    final capteurs = await isar.capteurModels.where().findAll();
    final listeCapteurs = <Map<String, dynamic>>[];
    for (final capteur in capteurs) {
      listeCapteurs.add({
        'nom': capteur.nom,
        'localisation': capteur.localisation,
      });
    }
    return listeCapteurs;
  }


  // GET - obtenir tous les details de tous les capteurs sous forme de Map
    /// a utiliser pour afficher les details de tous les capteurs
  Future<List<Map<String, dynamic>>> getDetailsCapteurs() async {
    final capteurs = await isar.capteurModels.where().findAll();
    final listeCapteurs = <Map<String, dynamic>>[];
    for (final capteur in capteurs) {
      listeCapteurs.add({
        'id': capteur.id,
        'nom': capteur.nom,
        'valeur': capteur.valeur,
        'batterie': capteur.batterie,
        'dateDerniereConnexion': capteur.dateDerniereConnexion,
        'dateInitialisation': capteur.dateInitialisation,
        'localisation': capteur.localisation,
      });
    }
    return listeCapteurs;
  }


  // UPDATE - modifier la valeur d'un capteur (ainsi que la date de derniere connexion)
    /// a utiliser par le bluetooth
  Future<void> modifierValeurCapteur(String nom, double valeur, int batterie) async {
    final capteur = await isar.capteurModels.filter().nomEqualTo(nom).findFirst();
    final newCapteur = capteur!..valeur = valeur..dateDerniereConnexion = DateTime.now()..batterie = batterie;
    await isar.writeTxn(() => isar.capteurModels.put(newCapteur));
  }


  // DELETE - supprimer un capteur
  Future<void> supprimerCapteur(String nom) async {
    final capteur = await isar.capteurModels.filter().nomEqualTo(nom).findFirst();
    final id = capteur!.id;
    await isar.writeTxn(() => isar.capteurModels.delete(id));
  }
}