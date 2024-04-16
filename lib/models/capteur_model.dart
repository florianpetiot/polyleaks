import 'package:isar/isar.dart';

// run cmd to generate file: dart run build_runner build
part 'capteur_model.g.dart';

@Collection()
class CapteurModel{
  // id du capteur 
  Id id = Isar.autoIncrement;

  // nom du capteur
  late String nom;

  // valeur du capteur
  late double? valeur;

  // niveau de batterie
  late int batterie;

  // date derniere connexion du capteur
  late DateTime dateDerniereConnexion;

  // date initialisation du capteur
  late DateTime dateInitialisation;

  // localisation du capteur
  late List<double> localisation;
  // [latitude, longitude]
}