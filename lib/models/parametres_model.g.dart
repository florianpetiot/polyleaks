// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parametres_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetParametresModelCollection on Isar {
  IsarCollection<ParametresModel> get parametresModels => this.collection();
}

const ParametresModelSchema = CollectionSchema(
  name: r'ParametresModel',
  id: 4027859138175088022,
  properties: {
    r'nom': PropertySchema(
      id: 0,
      name: r'nom',
      type: IsarType.string,
    ),
    r'valeur': PropertySchema(
      id: 1,
      name: r'valeur',
      type: IsarType.long,
    )
  },
  estimateSize: _parametresModelEstimateSize,
  serialize: _parametresModelSerialize,
  deserialize: _parametresModelDeserialize,
  deserializeProp: _parametresModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _parametresModelGetId,
  getLinks: _parametresModelGetLinks,
  attach: _parametresModelAttach,
  version: '3.1.0+1',
);

int _parametresModelEstimateSize(
  ParametresModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.nom.length * 3;
  return bytesCount;
}

void _parametresModelSerialize(
  ParametresModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.nom);
  writer.writeLong(offsets[1], object.valeur);
}

ParametresModel _parametresModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ParametresModel();
  object.id = id;
  object.nom = reader.readString(offsets[0]);
  object.valeur = reader.readLong(offsets[1]);
  return object;
}

P _parametresModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _parametresModelGetId(ParametresModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _parametresModelGetLinks(ParametresModel object) {
  return [];
}

void _parametresModelAttach(
    IsarCollection<dynamic> col, Id id, ParametresModel object) {
  object.id = id;
}

extension ParametresModelQueryWhereSort
    on QueryBuilder<ParametresModel, ParametresModel, QWhere> {
  QueryBuilder<ParametresModel, ParametresModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ParametresModelQueryWhere
    on QueryBuilder<ParametresModel, ParametresModel, QWhereClause> {
  QueryBuilder<ParametresModel, ParametresModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterWhereClause> idBetween(
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

extension ParametresModelQueryFilter
    on QueryBuilder<ParametresModel, ParametresModel, QFilterCondition> {
  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      nomEqualTo(
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      nomLessThan(
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      nomBetween(
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      nomStartsWith(
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      nomEndsWith(
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

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      nomContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      nomMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      nomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      nomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      valeurEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valeur',
        value: value,
      ));
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      valeurGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valeur',
        value: value,
      ));
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      valeurLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valeur',
        value: value,
      ));
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterFilterCondition>
      valeurBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valeur',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ParametresModelQueryObject
    on QueryBuilder<ParametresModel, ParametresModel, QFilterCondition> {}

extension ParametresModelQueryLinks
    on QueryBuilder<ParametresModel, ParametresModel, QFilterCondition> {}

extension ParametresModelQuerySortBy
    on QueryBuilder<ParametresModel, ParametresModel, QSortBy> {
  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy> sortByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy> sortByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy> sortByValeur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.asc);
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy>
      sortByValeurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.desc);
    });
  }
}

extension ParametresModelQuerySortThenBy
    on QueryBuilder<ParametresModel, ParametresModel, QSortThenBy> {
  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy> thenByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy> thenByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy> thenByValeur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.asc);
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QAfterSortBy>
      thenByValeurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.desc);
    });
  }
}

extension ParametresModelQueryWhereDistinct
    on QueryBuilder<ParametresModel, ParametresModel, QDistinct> {
  QueryBuilder<ParametresModel, ParametresModel, QDistinct> distinctByNom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParametresModel, ParametresModel, QDistinct> distinctByValeur() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valeur');
    });
  }
}

extension ParametresModelQueryProperty
    on QueryBuilder<ParametresModel, ParametresModel, QQueryProperty> {
  QueryBuilder<ParametresModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ParametresModel, String, QQueryOperations> nomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nom');
    });
  }

  QueryBuilder<ParametresModel, int, QQueryOperations> valeurProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valeur');
    });
  }
}
