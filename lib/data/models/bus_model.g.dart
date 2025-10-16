// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBusCollection on Isar {
  IsarCollection<Bus> get bus => this.collection();
}

const BusSchema = CollectionSchema(
  name: r'Bus',
  id: -2102093103472410960,
  properties: {
    r'annee': PropertySchema(
      id: 0,
      name: r'annee',
      type: IsarType.long,
    ),
    r'capacite': PropertySchema(
      id: 1,
      name: r'capacite',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'derniereActivite': PropertySchema(
      id: 3,
      name: r'derniereActivite',
      type: IsarType.dateTime,
    ),
    r'immatriculation': PropertySchema(
      id: 4,
      name: r'immatriculation',
      type: IsarType.string,
    ),
    r'kilometrage': PropertySchema(
      id: 5,
      name: r'kilometrage',
      type: IsarType.long,
    ),
    r'latitude': PropertySchema(
      id: 6,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'ligneAffectee': PropertySchema(
      id: 7,
      name: r'ligneAffectee',
      type: IsarType.string,
    ),
    r'longitude': PropertySchema(
      id: 8,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'marque': PropertySchema(
      id: 9,
      name: r'marque',
      type: IsarType.string,
    ),
    r'modele': PropertySchema(
      id: 10,
      name: r'modele',
      type: IsarType.string,
    ),
    r'modules': PropertySchema(
      id: 11,
      name: r'modules',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 12,
      name: r'notes',
      type: IsarType.string,
    ),
    r'numero': PropertySchema(
      id: 13,
      name: r'numero',
      type: IsarType.string,
    ),
    r'statut': PropertySchema(
      id: 14,
      name: r'statut',
      type: IsarType.string,
      enumMap: _BusstatutEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _busEstimateSize,
  serialize: _busSerialize,
  deserialize: _busDeserialize,
  deserializeProp: _busDeserializeProp,
  idName: r'id',
  indexes: {
    r'numero': IndexSchema(
      id: -2487710741234600426,
      name: r'numero',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'numero',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _busGetId,
  getLinks: _busGetLinks,
  attach: _busAttach,
  version: '3.1.0+1',
);

int _busEstimateSize(
  Bus object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.immatriculation.length * 3;
  {
    final value = object.ligneAffectee;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.marque;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.modele;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.modules;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.numero.length * 3;
  bytesCount += 3 + object.statut.name.length * 3;
  return bytesCount;
}

void _busSerialize(
  Bus object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.annee);
  writer.writeLong(offsets[1], object.capacite);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDateTime(offsets[3], object.derniereActivite);
  writer.writeString(offsets[4], object.immatriculation);
  writer.writeLong(offsets[5], object.kilometrage);
  writer.writeDouble(offsets[6], object.latitude);
  writer.writeString(offsets[7], object.ligneAffectee);
  writer.writeDouble(offsets[8], object.longitude);
  writer.writeString(offsets[9], object.marque);
  writer.writeString(offsets[10], object.modele);
  writer.writeString(offsets[11], object.modules);
  writer.writeString(offsets[12], object.notes);
  writer.writeString(offsets[13], object.numero);
  writer.writeString(offsets[14], object.statut.name);
  writer.writeDateTime(offsets[15], object.updatedAt);
}

Bus _busDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Bus(
    annee: reader.readLongOrNull(offsets[0]),
    capacite: reader.readLongOrNull(offsets[1]),
    derniereActivite: reader.readDateTimeOrNull(offsets[3]),
    immatriculation: reader.readStringOrNull(offsets[4]) ?? '',
    kilometrage: reader.readLongOrNull(offsets[5]),
    latitude: reader.readDoubleOrNull(offsets[6]),
    ligneAffectee: reader.readStringOrNull(offsets[7]),
    longitude: reader.readDoubleOrNull(offsets[8]),
    marque: reader.readStringOrNull(offsets[9]),
    modele: reader.readStringOrNull(offsets[10]),
    modules: reader.readStringOrNull(offsets[11]),
    notes: reader.readStringOrNull(offsets[12]),
    numero: reader.readStringOrNull(offsets[13]) ?? '',
    statut: _BusstatutValueEnumMap[reader.readStringOrNull(offsets[14])] ??
        BusStatut.actif,
  );
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[15]);
  return object;
}

P _busDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 14:
      return (_BusstatutValueEnumMap[reader.readStringOrNull(offset)] ??
          BusStatut.actif) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BusstatutEnumValueMap = {
  r'actif': r'actif',
  r'maintenance': r'maintenance',
  r'panne': r'panne',
  r'inactif': r'inactif',
};
const _BusstatutValueEnumMap = {
  r'actif': BusStatut.actif,
  r'maintenance': BusStatut.maintenance,
  r'panne': BusStatut.panne,
  r'inactif': BusStatut.inactif,
};

Id _busGetId(Bus object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _busGetLinks(Bus object) {
  return [];
}

void _busAttach(IsarCollection<dynamic> col, Id id, Bus object) {
  object.id = id;
}

extension BusByIndex on IsarCollection<Bus> {
  Future<Bus?> getByNumero(String numero) {
    return getByIndex(r'numero', [numero]);
  }

  Bus? getByNumeroSync(String numero) {
    return getByIndexSync(r'numero', [numero]);
  }

  Future<bool> deleteByNumero(String numero) {
    return deleteByIndex(r'numero', [numero]);
  }

  bool deleteByNumeroSync(String numero) {
    return deleteByIndexSync(r'numero', [numero]);
  }

  Future<List<Bus?>> getAllByNumero(List<String> numeroValues) {
    final values = numeroValues.map((e) => [e]).toList();
    return getAllByIndex(r'numero', values);
  }

  List<Bus?> getAllByNumeroSync(List<String> numeroValues) {
    final values = numeroValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'numero', values);
  }

  Future<int> deleteAllByNumero(List<String> numeroValues) {
    final values = numeroValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'numero', values);
  }

  int deleteAllByNumeroSync(List<String> numeroValues) {
    final values = numeroValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'numero', values);
  }

  Future<Id> putByNumero(Bus object) {
    return putByIndex(r'numero', object);
  }

  Id putByNumeroSync(Bus object, {bool saveLinks = true}) {
    return putByIndexSync(r'numero', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNumero(List<Bus> objects) {
    return putAllByIndex(r'numero', objects);
  }

  List<Id> putAllByNumeroSync(List<Bus> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'numero', objects, saveLinks: saveLinks);
  }
}

extension BusQueryWhereSort on QueryBuilder<Bus, Bus, QWhere> {
  QueryBuilder<Bus, Bus, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BusQueryWhere on QueryBuilder<Bus, Bus, QWhereClause> {
  QueryBuilder<Bus, Bus, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Bus, Bus, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Bus, Bus, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Bus, Bus, QAfterWhereClause> idBetween(
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

  QueryBuilder<Bus, Bus, QAfterWhereClause> numeroEqualTo(String numero) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'numero',
        value: [numero],
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterWhereClause> numeroNotEqualTo(String numero) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'numero',
              lower: [],
              upper: [numero],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'numero',
              lower: [numero],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'numero',
              lower: [numero],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'numero',
              lower: [],
              upper: [numero],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BusQueryFilter on QueryBuilder<Bus, Bus, QFilterCondition> {
  QueryBuilder<Bus, Bus, QAfterFilterCondition> anneeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'annee',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> anneeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'annee',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> anneeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'annee',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> anneeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'annee',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> anneeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'annee',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> anneeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'annee',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> capaciteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'capacite',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> capaciteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'capacite',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> capaciteEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capacite',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> capaciteGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'capacite',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> capaciteLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'capacite',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> capaciteBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'capacite',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> derniereActiviteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'derniereActivite',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> derniereActiviteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'derniereActivite',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> derniereActiviteEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derniereActivite',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> derniereActiviteGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'derniereActivite',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> derniereActiviteLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'derniereActivite',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> derniereActiviteBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'derniereActivite',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'immatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'immatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'immatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'immatriculation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'immatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'immatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'immatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'immatriculation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'immatriculation',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> immatriculationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'immatriculation',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> kilometrageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kilometrage',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> kilometrageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kilometrage',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> kilometrageEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kilometrage',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> kilometrageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kilometrage',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> kilometrageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kilometrage',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> kilometrageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kilometrage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> latitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> latitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> latitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> latitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> latitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ligneAffectee',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ligneAffectee',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ligneAffectee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ligneAffectee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ligneAffectee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ligneAffectee',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ligneAffectee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ligneAffectee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ligneAffectee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ligneAffectee',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ligneAffectee',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> ligneAffecteeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ligneAffectee',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> longitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> longitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> longitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> longitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> longitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'marque',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'marque',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marque',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'marque',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'marque',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'marque',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'marque',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'marque',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'marque',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'marque',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marque',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> marqueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'marque',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modele',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modele',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modele',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modele',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modele',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modele',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modeleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modele',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modules',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modules',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modules',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modules',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modules',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modules',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modules',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modules',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modules',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modules',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modules',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> modulesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modules',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numero',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'numero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'numero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'numero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'numero',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numero',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> numeroIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'numero',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutEqualTo(
    BusStatut value, {
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutGreaterThan(
    BusStatut value, {
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutLessThan(
    BusStatut value, {
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutBetween(
    BusStatut lower,
    BusStatut upper, {
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutStartsWith(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutEndsWith(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statut',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> statutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Bus, Bus, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Bus, Bus, QAfterFilterCondition> updatedAtBetween(
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

extension BusQueryObject on QueryBuilder<Bus, Bus, QFilterCondition> {}

extension BusQueryLinks on QueryBuilder<Bus, Bus, QFilterCondition> {}

extension BusQuerySortBy on QueryBuilder<Bus, Bus, QSortBy> {
  QueryBuilder<Bus, Bus, QAfterSortBy> sortByAnnee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annee', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByAnneeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annee', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByCapacite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacite', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByCapaciteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacite', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByDerniereActivite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derniereActivite', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByDerniereActiviteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derniereActivite', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByImmatriculation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'immatriculation', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByImmatriculationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'immatriculation', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByKilometrage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kilometrage', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByKilometrageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kilometrage', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByLigneAffectee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ligneAffectee', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByLigneAffecteeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ligneAffectee', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByMarque() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marque', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByMarqueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marque', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByModele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modele', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByModeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modele', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByModules() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modules', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByModulesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modules', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByNumeroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BusQuerySortThenBy on QueryBuilder<Bus, Bus, QSortThenBy> {
  QueryBuilder<Bus, Bus, QAfterSortBy> thenByAnnee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annee', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByAnneeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annee', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByCapacite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacite', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByCapaciteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacite', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByDerniereActivite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derniereActivite', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByDerniereActiviteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derniereActivite', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByImmatriculation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'immatriculation', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByImmatriculationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'immatriculation', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByKilometrage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kilometrage', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByKilometrageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kilometrage', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByLigneAffectee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ligneAffectee', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByLigneAffecteeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ligneAffectee', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByMarque() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marque', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByMarqueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marque', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByModele() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modele', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByModeleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modele', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByModules() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modules', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByModulesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modules', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByNumeroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Bus, Bus, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BusQueryWhereDistinct on QueryBuilder<Bus, Bus, QDistinct> {
  QueryBuilder<Bus, Bus, QDistinct> distinctByAnnee() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'annee');
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByCapacite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capacite');
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByDerniereActivite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'derniereActivite');
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByImmatriculation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'immatriculation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByKilometrage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kilometrage');
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByLigneAffectee(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ligneAffectee',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByMarque(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'marque', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByModele(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modele', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByModules(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modules', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByNumero(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numero', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByStatut(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statut', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bus, Bus, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension BusQueryProperty on QueryBuilder<Bus, Bus, QQueryProperty> {
  QueryBuilder<Bus, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Bus, int?, QQueryOperations> anneeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'annee');
    });
  }

  QueryBuilder<Bus, int?, QQueryOperations> capaciteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capacite');
    });
  }

  QueryBuilder<Bus, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Bus, DateTime?, QQueryOperations> derniereActiviteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'derniereActivite');
    });
  }

  QueryBuilder<Bus, String, QQueryOperations> immatriculationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'immatriculation');
    });
  }

  QueryBuilder<Bus, int?, QQueryOperations> kilometrageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kilometrage');
    });
  }

  QueryBuilder<Bus, double?, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<Bus, String?, QQueryOperations> ligneAffecteeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ligneAffectee');
    });
  }

  QueryBuilder<Bus, double?, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<Bus, String?, QQueryOperations> marqueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'marque');
    });
  }

  QueryBuilder<Bus, String?, QQueryOperations> modeleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modele');
    });
  }

  QueryBuilder<Bus, String?, QQueryOperations> modulesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modules');
    });
  }

  QueryBuilder<Bus, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Bus, String, QQueryOperations> numeroProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numero');
    });
  }

  QueryBuilder<Bus, BusStatut, QQueryOperations> statutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statut');
    });
  }

  QueryBuilder<Bus, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
