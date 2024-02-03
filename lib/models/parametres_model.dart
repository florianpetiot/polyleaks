import 'package:isar/isar.dart';

part 'parametres_model.g.dart';

@Collection()
class ParametresModel {
  // id du parametre
  Id id = Isar.autoIncrement;

  // nom du parametre (langue, theme, ...)
  late String nom;

  // valeur du parametre
  late int valeur; 
    // langue: 0 = francais, 1 = anglais, 2 = espagnol
    // theme: 0 = clair, 1 = sombre
}