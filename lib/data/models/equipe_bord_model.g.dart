// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipe_bord_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEquipeBordCollection on Isar {
  IsarCollection<EquipeBord> get equipeBords => this.collection();
}

const EquipeBordSchema = CollectionSchema(
  name: r'EquipeBord',
  id: -6383270617578294420,
  properties: {
    r'busAffecte': PropertySchema(
      id: 0,
      name: r'busAffecte',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'email': PropertySchema(
      id: 2,
      name: r'email',
      type: IsarType.string,
    ),
    r'isCurrentSession': PropertySchema(
      id: 3,
      name: r'isCurrentSession',
      type: IsarType.bool,
    ),
    r'loginTimestamp': PropertySchema(
      id: 4,
      name: r'loginTimestamp',
      type: IsarType.dateTime,
    ),
    r'matricule': PropertySchema(
      id: 5,
      name: r'matricule',
      type: IsarType.string,
    ),
    r'nom': PropertySchema(
      id: 6,
      name: r'nom',
      type: IsarType.string,
    ),
    r'poste': PropertySchema(
      id: 7,
      name: r'poste',
      type: IsarType.string,
    ),
    r'statut': PropertySchema(
      id: 8,
      name: r'statut',
      type: IsarType.string,
    ),
    r'telephone': PropertySchema(
      id: 9,
      name: r'telephone',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _equipeBordEstimateSize,
  serialize: _equipeBordSerialize,
  deserialize: _equipeBordDeserialize,
  deserializeProp: _equipeBordDeserializeProp,
  idName: r'id',
  indexes: {
    r'matricule': IndexSchema(
      id: -2931968585082441240,
      name: r'matricule',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'matricule',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _equipeBordGetId,
  getLinks: _equipeBordGetLinks,
  attach: _equipeBordAttach,
  version: '3.1.0+1',
);

int _equipeBordEstimateSize(
  EquipeBord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.busAffecte;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.matricule.length * 3;
  bytesCount += 3 + object.nom.length * 3;
  bytesCount += 3 + object.poste.length * 3;
  bytesCount += 3 + object.statut.length * 3;
  {
    final value = object.telephone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _equipeBordSerialize(
  EquipeBord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.busAffecte);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.email);
  writer.writeBool(offsets[3], object.isCurrentSession);
  writer.writeDateTime(offsets[4], object.loginTimestamp);
  writer.writeString(offsets[5], object.matricule);
  writer.writeString(offsets[6], object.nom);
  writer.writeString(offsets[7], object.poste);
  writer.writeString(offsets[8], object.statut);
  writer.writeString(offsets[9], object.telephone);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

EquipeBord _equipeBordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EquipeBord(
    busAffecte: reader.readStringOrNull(offsets[0]),
    email: reader.readStringOrNull(offsets[2]),
    isCurrentSession: reader.readBoolOrNull(offsets[3]) ?? false,
    loginTimestamp: reader.readDateTimeOrNull(offsets[4]),
    matricule: reader.readStringOrNull(offsets[5]) ?? '',
    nom: reader.readStringOrNull(offsets[6]) ?? '',
    poste: reader.readStringOrNull(offsets[7]) ?? '',
    statut: reader.readStringOrNull(offsets[8]) ?? 'actif',
    telephone: reader.readStringOrNull(offsets[9]),
  );
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[10]);
  return object;
}

P _equipeBordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? 'actif') as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _equipeBordGetId(EquipeBord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _equipeBordGetLinks(EquipeBord object) {
  return [];
}

void _equipeBordAttach(IsarCollection<dynamic> col, Id id, EquipeBord object) {
  object.id = id;
}

extension EquipeBordByIndex on IsarCollection<EquipeBord> {
  Future<EquipeBord?> getByMatricule(String matricule) {
    return getByIndex(r'matricule', [matricule]);
  }

  EquipeBord? getByMatriculeSync(String matricule) {
    return getByIndexSync(r'matricule', [matricule]);
  }

  Future<bool> deleteByMatricule(String matricule) {
    return deleteByIndex(r'matricule', [matricule]);
  }

  bool deleteByMatriculeSync(String matricule) {
    return deleteByIndexSync(r'matricule', [matricule]);
  }

  Future<List<EquipeBord?>> getAllByMatricule(List<String> matriculeValues) {
    final values = matriculeValues.map((e) => [e]).toList();
    return getAllByIndex(r'matricule', values);
  }

  List<EquipeBord?> getAllByMatriculeSync(List<String> matriculeValues) {
    final values = matriculeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'matricule', values);
  }

  Future<int> deleteAllByMatricule(List<String> matriculeValues) {
    final values = matriculeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'matricule', values);
  }

  int deleteAllByMatriculeSync(List<String> matriculeValues) {
    final values = matriculeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'matricule', values);
  }

  Future<Id> putByMatricule(EquipeBord object) {
    return putByIndex(r'matricule', object);
  }

  Id putByMatriculeSync(EquipeBord object, {bool saveLinks = true}) {
    return putByIndexSync(r'matricule', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMatricule(List<EquipeBord> objects) {
    return putAllByIndex(r'matricule', objects);
  }

  List<Id> putAllByMatriculeSync(List<EquipeBord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'matricule', objects, saveLinks: saveLinks);
  }
}

extension EquipeBordQueryWhereSort
    on QueryBuilder<EquipeBord, EquipeBord, QWhere> {
  QueryBuilder<EquipeBord, EquipeBord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EquipeBordQueryWhere
    on QueryBuilder<EquipeBord, EquipeBord, QWhereClause> {
  QueryBuilder<EquipeBord, EquipeBord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterWhereClause> idBetween(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterWhereClause> matriculeEqualTo(
      String matricule) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'matricule',
        value: [matricule],
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterWhereClause> matriculeNotEqualTo(
      String matricule) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matricule',
              lower: [],
              upper: [matricule],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matricule',
              lower: [matricule],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matricule',
              lower: [matricule],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matricule',
              lower: [],
              upper: [matricule],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EquipeBordQueryFilter
    on QueryBuilder<EquipeBord, EquipeBord, QFilterCondition> {
  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      busAffecteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'busAffecte',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      busAffecteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'busAffecte',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> busAffecteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'busAffecte',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      busAffecteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'busAffecte',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      busAffecteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'busAffecte',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> busAffecteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'busAffecte',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      busAffecteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'busAffecte',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      busAffecteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'busAffecte',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      busAffecteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'busAffecte',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> busAffecteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'busAffecte',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      busAffecteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'busAffecte',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      busAffecteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'busAffecte',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      isCurrentSessionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCurrentSession',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      loginTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'loginTimestamp',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      loginTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'loginTimestamp',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      loginTimestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loginTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      loginTimestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'loginTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      loginTimestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'loginTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      loginTimestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'loginTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> matriculeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      matriculeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> matriculeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> matriculeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matricule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      matriculeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> matriculeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> matriculeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> matriculeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matricule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      matriculeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matricule',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      matriculeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matricule',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomEqualTo(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomGreaterThan(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomLessThan(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomBetween(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomStartsWith(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomEndsWith(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomContains(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomMatches(
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

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> nomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> posteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poste',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> posteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poste',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> posteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poste',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> posteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poste',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> posteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'poste',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> posteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'poste',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> posteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'poste',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> posteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'poste',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> posteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poste',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      posteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'poste',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> statutEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> statutGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> statutLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> statutBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statut',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> statutStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> statutEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> statutContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> statutMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statut',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> statutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      statutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      telephoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'telephone',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      telephoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'telephone',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> telephoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      telephoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> telephoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> telephoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'telephone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      telephoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> telephoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> telephoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'telephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> telephoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'telephone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      telephoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telephone',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      telephoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'telephone',
        value: '',
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EquipeBordQueryObject
    on QueryBuilder<EquipeBord, EquipeBord, QFilterCondition> {}

extension EquipeBordQueryLinks
    on QueryBuilder<EquipeBord, EquipeBord, QFilterCondition> {}

extension EquipeBordQuerySortBy
    on QueryBuilder<EquipeBord, EquipeBord, QSortBy> {
  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByBusAffecte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busAffecte', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByBusAffecteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busAffecte', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByIsCurrentSession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrentSession', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy>
      sortByIsCurrentSessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrentSession', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByLoginTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loginTimestamp', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy>
      sortByLoginTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loginTimestamp', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricule', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricule', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByPoste() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poste', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByPosteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poste', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension EquipeBordQuerySortThenBy
    on QueryBuilder<EquipeBord, EquipeBord, QSortThenBy> {
  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByBusAffecte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busAffecte', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByBusAffecteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busAffecte', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByIsCurrentSession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrentSession', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy>
      thenByIsCurrentSessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCurrentSession', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByLoginTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loginTimestamp', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy>
      thenByLoginTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loginTimestamp', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricule', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricule', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByPoste() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poste', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByPosteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poste', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telephone', Sort.desc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension EquipeBordQueryWhereDistinct
    on QueryBuilder<EquipeBord, EquipeBord, QDistinct> {
  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByBusAffecte(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'busAffecte', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByIsCurrentSession() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCurrentSession');
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByLoginTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loginTimestamp');
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByMatricule(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matricule', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByNom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByPoste(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poste', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByStatut(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statut', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByTelephone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'telephone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EquipeBord, EquipeBord, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension EquipeBordQueryProperty
    on QueryBuilder<EquipeBord, EquipeBord, QQueryProperty> {
  QueryBuilder<EquipeBord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EquipeBord, String?, QQueryOperations> busAffecteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'busAffecte');
    });
  }

  QueryBuilder<EquipeBord, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<EquipeBord, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<EquipeBord, bool, QQueryOperations> isCurrentSessionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCurrentSession');
    });
  }

  QueryBuilder<EquipeBord, DateTime?, QQueryOperations>
      loginTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loginTimestamp');
    });
  }

  QueryBuilder<EquipeBord, String, QQueryOperations> matriculeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matricule');
    });
  }

  QueryBuilder<EquipeBord, String, QQueryOperations> nomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nom');
    });
  }

  QueryBuilder<EquipeBord, String, QQueryOperations> posteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poste');
    });
  }

  QueryBuilder<EquipeBord, String, QQueryOperations> statutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statut');
    });
  }

  QueryBuilder<EquipeBord, String?, QQueryOperations> telephoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'telephone');
    });
  }

  QueryBuilder<EquipeBord, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
