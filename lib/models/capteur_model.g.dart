// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capteur_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCapteurModelCollection on Isar {
  IsarCollection<CapteurModel> get capteurModels => this.collection();
}

const CapteurModelSchema = CollectionSchema(
  name: r'CapteurModel',
  id: -3813499653591873693,
  properties: {
    r'dateDerniereConnexion': PropertySchema(
      id: 0,
      name: r'dateDerniereConnexion',
      type: IsarType.dateTime,
    ),
    r'dateInitialisation': PropertySchema(
      id: 1,
      name: r'dateInitialisation',
      type: IsarType.dateTime,
    ),
    r'localisation': PropertySchema(
      id: 2,
      name: r'localisation',
      type: IsarType.doubleList,
    ),
    r'nom': PropertySchema(
      id: 3,
      name: r'nom',
      type: IsarType.string,
    ),
    r'valeur': PropertySchema(
      id: 4,
      name: r'valeur',
      type: IsarType.double,
    )
  },
  estimateSize: _capteurModelEstimateSize,
  serialize: _capteurModelSerialize,
  deserialize: _capteurModelDeserialize,
  deserializeProp: _capteurModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _capteurModelGetId,
  getLinks: _capteurModelGetLinks,
  attach: _capteurModelAttach,
  version: '3.1.0+1',
);

int _capteurModelEstimateSize(
  CapteurModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.localisation.length * 8;
  bytesCount += 3 + object.nom.length * 3;
  return bytesCount;
}

void _capteurModelSerialize(
  CapteurModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateDerniereConnexion);
  writer.writeDateTime(offsets[1], object.dateInitialisation);
  writer.writeDoubleList(offsets[2], object.localisation);
  writer.writeString(offsets[3], object.nom);
  writer.writeDouble(offsets[4], object.valeur);
}

CapteurModel _capteurModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CapteurModel();
  object.dateDerniereConnexion = reader.readDateTime(offsets[0]);
  object.dateInitialisation = reader.readDateTime(offsets[1]);
  object.id = id;
  object.localisation = reader.readDoubleList(offsets[2]) ?? [];
  object.nom = reader.readString(offsets[3]);
  object.valeur = reader.readDouble(offsets[4]);
  return object;
}

P _capteurModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _capteurModelGetId(CapteurModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _capteurModelGetLinks(CapteurModel object) {
  return [];
}

void _capteurModelAttach(
    IsarCollection<dynamic> col, Id id, CapteurModel object) {
  object.id = id;
}

extension CapteurModelQueryWhereSort
    on QueryBuilder<CapteurModel, CapteurModel, QWhere> {
  QueryBuilder<CapteurModel, CapteurModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CapteurModelQueryWhere
    on QueryBuilder<CapteurModel, CapteurModel, QWhereClause> {
  QueryBuilder<CapteurModel, CapteurModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CapteurModelQueryFilter
    on QueryBuilder<CapteurModel, CapteurModel, QFilterCondition> {
  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      dateDerniereConnexionEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateDerniereConnexion',
        value: value,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      dateDerniereConnexionGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateDerniereConnexion',
        value: value,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      dateDerniereConnexionLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateDerniereConnexion',
        value: value,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      dateDerniereConnexionBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateDerniereConnexion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      dateInitialisationEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateInitialisation',
        value: value,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      dateInitialisationGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateInitialisation',
        value: value,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      dateInitialisationLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateInitialisation',
        value: value,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      dateInitialisationBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateInitialisation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localisation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localisation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localisation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localisation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localisation',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localisation',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localisation',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localisation',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localisation',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      localisationLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localisation',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> nomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      nomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> nomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> nomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> nomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> nomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> nomContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> nomMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> nomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      nomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> valeurEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valeur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      valeurGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valeur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition>
      valeurLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valeur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterFilterCondition> valeurBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valeur',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension CapteurModelQueryObject
    on QueryBuilder<CapteurModel, CapteurModel, QFilterCondition> {}

extension CapteurModelQueryLinks
    on QueryBuilder<CapteurModel, CapteurModel, QFilterCondition> {}

extension CapteurModelQuerySortBy
    on QueryBuilder<CapteurModel, CapteurModel, QSortBy> {
  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy>
      sortByDateDerniereConnexion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDerniereConnexion', Sort.asc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy>
      sortByDateDerniereConnexionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDerniereConnexion', Sort.desc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy>
      sortByDateInitialisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateInitialisation', Sort.asc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy>
      sortByDateInitialisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateInitialisation', Sort.desc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> sortByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> sortByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> sortByValeur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.asc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> sortByValeurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.desc);
    });
  }
}

extension CapteurModelQuerySortThenBy
    on QueryBuilder<CapteurModel, CapteurModel, QSortThenBy> {
  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy>
      thenByDateDerniereConnexion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDerniereConnexion', Sort.asc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy>
      thenByDateDerniereConnexionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDerniereConnexion', Sort.desc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy>
      thenByDateInitialisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateInitialisation', Sort.asc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy>
      thenByDateInitialisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateInitialisation', Sort.desc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> thenByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> thenByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> thenByValeur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.asc);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QAfterSortBy> thenByValeurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.desc);
    });
  }
}

extension CapteurModelQueryWhereDistinct
    on QueryBuilder<CapteurModel, CapteurModel, QDistinct> {
  QueryBuilder<CapteurModel, CapteurModel, QDistinct>
      distinctByDateDerniereConnexion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateDerniereConnexion');
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QDistinct>
      distinctByDateInitialisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateInitialisation');
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QDistinct> distinctByLocalisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localisation');
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QDistinct> distinctByNom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CapteurModel, CapteurModel, QDistinct> distinctByValeur() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valeur');
    });
  }
}

extension CapteurModelQueryProperty
    on QueryBuilder<CapteurModel, CapteurModel, QQueryProperty> {
  QueryBuilder<CapteurModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CapteurModel, DateTime, QQueryOperations>
      dateDerniereConnexionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateDerniereConnexion');
    });
  }

  QueryBuilder<CapteurModel, DateTime, QQueryOperations>
      dateInitialisationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateInitialisation');
    });
  }

  QueryBuilder<CapteurModel, List<double>, QQueryOperations>
      localisationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localisation');
    });
  }

  QueryBuilder<CapteurModel, String, QQueryOperations> nomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nom');
    });
  }

  QueryBuilder<CapteurModel, double, QQueryOperations> valeurProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valeur');
    });
  }
}
