// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_ticket_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScannedTicketCollection on Isar {
  IsarCollection<ScannedTicket> get scannedTickets => this.collection();
}

const ScannedTicketSchema = CollectionSchema(
  name: r'ScannedTicket',
  id: -7054834632476106998,
  properties: {
    r'arretArrivee': PropertySchema(
      id: 0,
      name: r'arretArrivee',
      type: IsarType.string,
    ),
    r'arretDepart': PropertySchema(
      id: 1,
      name: r'arretDepart',
      type: IsarType.string,
    ),
    r'billetId': PropertySchema(
      id: 2,
      name: r'billetId',
      type: IsarType.long,
    ),
    r'busImmatriculation': PropertySchema(
      id: 3,
      name: r'busImmatriculation',
      type: IsarType.string,
    ),
    r'busNumero': PropertySchema(
      id: 4,
      name: r'busNumero',
      type: IsarType.string,
    ),
    r'chauffeurMatricule': PropertySchema(
      id: 5,
      name: r'chauffeurMatricule',
      type: IsarType.string,
    ),
    r'clientNom': PropertySchema(
      id: 6,
      name: r'clientNom',
      type: IsarType.string,
    ),
    r'clientTelephone': PropertySchema(
      id: 7,
      name: r'clientTelephone',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 8,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dateVoyage': PropertySchema(
      id: 9,
      name: r'dateVoyage',
      type: IsarType.string,
    ),
    r'devise': PropertySchema(
      id: 10,
      name: r'devise',
      type: IsarType.string,
    ),
    r'heureDepart': PropertySchema(
      id: 11,
      name: r'heureDepart',
      type: IsarType.string,
    ),
    r'modePaiement': PropertySchema(
      id: 12,
      name: r'modePaiement',
      type: IsarType.string,
    ),
    r'numeroBillet': PropertySchema(
      id: 13,
      name: r'numeroBillet',
      type: IsarType.string,
    ),
    r'prixPaye': PropertySchema(
      id: 14,
      name: r'prixPaye',
      type: IsarType.double,
    ),
    r'receveurMatricule': PropertySchema(
      id: 15,
      name: r'receveurMatricule',
      type: IsarType.string,
    ),
    r'scannedAt': PropertySchema(
      id: 16,
      name: r'scannedAt',
      type: IsarType.dateTime,
    ),
    r'scannedBy': PropertySchema(
      id: 17,
      name: r'scannedBy',
      type: IsarType.string,
    ),
    r'statutBillet': PropertySchema(
      id: 18,
      name: r'statutBillet',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 19,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _scannedTicketEstimateSize,
  serialize: _scannedTicketSerialize,
  deserialize: _scannedTicketDeserialize,
  deserializeProp: _scannedTicketDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _scannedTicketGetId,
  getLinks: _scannedTicketGetLinks,
  attach: _scannedTicketAttach,
  version: '3.1.0+1',
);

int _scannedTicketEstimateSize(
  ScannedTicket object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.arretArrivee.length * 3;
  bytesCount += 3 + object.arretDepart.length * 3;
  {
    final value = object.busImmatriculation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.busNumero;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chauffeurMatricule;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.clientNom;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.clientTelephone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.dateVoyage.length * 3;
  bytesCount += 3 + object.devise.length * 3;
  {
    final value = object.heureDepart;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.modePaiement.length * 3;
  bytesCount += 3 + object.numeroBillet.length * 3;
  {
    final value = object.receveurMatricule;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.scannedBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.statutBillet.length * 3;
  return bytesCount;
}

void _scannedTicketSerialize(
  ScannedTicket object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.arretArrivee);
  writer.writeString(offsets[1], object.arretDepart);
  writer.writeLong(offsets[2], object.billetId);
  writer.writeString(offsets[3], object.busImmatriculation);
  writer.writeString(offsets[4], object.busNumero);
  writer.writeString(offsets[5], object.chauffeurMatricule);
  writer.writeString(offsets[6], object.clientNom);
  writer.writeString(offsets[7], object.clientTelephone);
  writer.writeDateTime(offsets[8], object.createdAt);
  writer.writeString(offsets[9], object.dateVoyage);
  writer.writeString(offsets[10], object.devise);
  writer.writeString(offsets[11], object.heureDepart);
  writer.writeString(offsets[12], object.modePaiement);
  writer.writeString(offsets[13], object.numeroBillet);
  writer.writeDouble(offsets[14], object.prixPaye);
  writer.writeString(offsets[15], object.receveurMatricule);
  writer.writeDateTime(offsets[16], object.scannedAt);
  writer.writeString(offsets[17], object.scannedBy);
  writer.writeString(offsets[18], object.statutBillet);
  writer.writeDateTime(offsets[19], object.updatedAt);
}

ScannedTicket _scannedTicketDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScannedTicket(
    arretArrivee: reader.readStringOrNull(offsets[0]) ?? '',
    arretDepart: reader.readStringOrNull(offsets[1]) ?? '',
    billetId: reader.readLongOrNull(offsets[2]),
    busImmatriculation: reader.readStringOrNull(offsets[3]),
    busNumero: reader.readStringOrNull(offsets[4]),
    chauffeurMatricule: reader.readStringOrNull(offsets[5]),
    clientNom: reader.readStringOrNull(offsets[6]),
    clientTelephone: reader.readStringOrNull(offsets[7]),
    dateVoyage: reader.readStringOrNull(offsets[9]) ?? '',
    devise: reader.readStringOrNull(offsets[10]) ?? 'CDF',
    heureDepart: reader.readStringOrNull(offsets[11]),
    modePaiement: reader.readStringOrNull(offsets[12]) ?? '',
    numeroBillet: reader.readStringOrNull(offsets[13]) ?? '',
    prixPaye: reader.readDoubleOrNull(offsets[14]) ?? 0.0,
    receveurMatricule: reader.readStringOrNull(offsets[15]),
    scannedAt: reader.readDateTime(offsets[16]),
    scannedBy: reader.readStringOrNull(offsets[17]),
    statutBillet: reader.readStringOrNull(offsets[18]) ?? 'utilise',
  );
  object.createdAt = reader.readDateTime(offsets[8]);
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[19]);
  return object;
}

P _scannedTicketDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 10:
      return (reader.readStringOrNull(offset) ?? 'CDF') as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 14:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset) ?? 'utilise') as P;
    case 19:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scannedTicketGetId(ScannedTicket object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scannedTicketGetLinks(ScannedTicket object) {
  return [];
}

void _scannedTicketAttach(
    IsarCollection<dynamic> col, Id id, ScannedTicket object) {
  object.id = id;
}

extension ScannedTicketQueryWhereSort
    on QueryBuilder<ScannedTicket, ScannedTicket, QWhere> {
  QueryBuilder<ScannedTicket, ScannedTicket, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScannedTicketQueryWhere
    on QueryBuilder<ScannedTicket, ScannedTicket, QWhereClause> {
  QueryBuilder<ScannedTicket, ScannedTicket, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterWhereClause> idBetween(
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

extension ScannedTicketQueryFilter
    on QueryBuilder<ScannedTicket, ScannedTicket, QFilterCondition> {
  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arretArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'arretArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'arretArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'arretArrivee',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'arretArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'arretArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'arretArrivee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'arretArrivee',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arretArrivee',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretArriveeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'arretArrivee',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arretDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'arretDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'arretDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'arretDepart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'arretDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'arretDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'arretDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'arretDepart',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arretDepart',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      arretDepartIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'arretDepart',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      billetIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'billetId',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      billetIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'billetId',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      billetIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billetId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      billetIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'billetId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      billetIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'billetId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      billetIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'billetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'busImmatriculation',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'busImmatriculation',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'busImmatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'busImmatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'busImmatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'busImmatriculation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'busImmatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'busImmatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'busImmatriculation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'busImmatriculation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'busImmatriculation',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busImmatriculationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'busImmatriculation',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'busNumero',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'busNumero',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'busNumero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'busNumero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'busNumero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'busNumero',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'busNumero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'busNumero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'busNumero',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'busNumero',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'busNumero',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      busNumeroIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'busNumero',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chauffeurMatricule',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chauffeurMatricule',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chauffeurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chauffeurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chauffeurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chauffeurMatricule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chauffeurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chauffeurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chauffeurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chauffeurMatricule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chauffeurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      chauffeurMatriculeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chauffeurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clientNom',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clientNom',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientNom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clientNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clientNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientNom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientNom',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientNomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientNom',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clientTelephone',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clientTelephone',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientTelephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientTelephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientTelephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientTelephone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clientTelephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clientTelephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientTelephone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientTelephone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientTelephone',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      clientTelephoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientTelephone',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
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

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateVoyage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateVoyage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateVoyage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateVoyage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateVoyage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateVoyage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateVoyage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateVoyage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateVoyage',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      dateVoyageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateVoyage',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'devise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'devise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'devise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'devise',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'devise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'devise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'devise',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'devise',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'devise',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      deviseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'devise',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'heureDepart',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'heureDepart',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heureDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'heureDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'heureDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'heureDepart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'heureDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'heureDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'heureDepart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'heureDepart',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heureDepart',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      heureDepartIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'heureDepart',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
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

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modePaiement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modePaiement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modePaiement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modePaiement',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modePaiement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modePaiement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modePaiement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modePaiement',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modePaiement',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      modePaiementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modePaiement',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numeroBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numeroBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numeroBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numeroBillet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'numeroBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'numeroBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'numeroBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'numeroBillet',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numeroBillet',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      numeroBilletIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'numeroBillet',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      prixPayeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prixPaye',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      prixPayeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prixPaye',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      prixPayeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prixPaye',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      prixPayeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prixPaye',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'receveurMatricule',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'receveurMatricule',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receveurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receveurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receveurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receveurMatricule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receveurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receveurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receveurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receveurMatricule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receveurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      receveurMatriculeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receveurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scannedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scannedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scannedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scannedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scannedBy',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scannedBy',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scannedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scannedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scannedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scannedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scannedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scannedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scannedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scannedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scannedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      scannedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scannedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statutBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statutBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statutBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statutBillet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statutBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statutBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statutBillet',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statutBillet',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statutBillet',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      statutBilletIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statutBillet',
        value: '',
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
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

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterFilterCondition>
      updatedAtBetween(
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

extension ScannedTicketQueryObject
    on QueryBuilder<ScannedTicket, ScannedTicket, QFilterCondition> {}

extension ScannedTicketQueryLinks
    on QueryBuilder<ScannedTicket, ScannedTicket, QFilterCondition> {}

extension ScannedTicketQuerySortBy
    on QueryBuilder<ScannedTicket, ScannedTicket, QSortBy> {
  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByArretArrivee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arretArrivee', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByArretArriveeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arretArrivee', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByArretDepart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arretDepart', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByArretDepartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arretDepart', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByBilletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billetId', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByBilletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billetId', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByBusImmatriculation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busImmatriculation', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByBusImmatriculationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busImmatriculation', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByBusNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busNumero', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByBusNumeroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busNumero', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByChauffeurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chauffeurMatricule', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByChauffeurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chauffeurMatricule', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByClientNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientNom', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByClientNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientNom', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByClientTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientTelephone', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByClientTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientTelephone', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByDateVoyage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateVoyage', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByDateVoyageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateVoyage', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByDevise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devise', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByDeviseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devise', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByHeureDepart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heureDepart', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByHeureDepartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heureDepart', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByModePaiement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modePaiement', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByModePaiementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modePaiement', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByNumeroBillet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroBillet', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByNumeroBilletDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroBillet', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByPrixPaye() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prixPaye', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByPrixPayeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prixPaye', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByReceveurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receveurMatricule', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByReceveurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receveurMatricule', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByScannedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scannedAt', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByScannedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scannedAt', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByScannedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scannedBy', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByScannedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scannedBy', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByStatutBillet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statutBillet', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByStatutBilletDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statutBillet', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ScannedTicketQuerySortThenBy
    on QueryBuilder<ScannedTicket, ScannedTicket, QSortThenBy> {
  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByArretArrivee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arretArrivee', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByArretArriveeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arretArrivee', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByArretDepart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arretDepart', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByArretDepartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arretDepart', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByBilletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billetId', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByBilletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billetId', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByBusImmatriculation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busImmatriculation', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByBusImmatriculationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busImmatriculation', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByBusNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busNumero', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByBusNumeroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busNumero', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByChauffeurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chauffeurMatricule', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByChauffeurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chauffeurMatricule', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByClientNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientNom', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByClientNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientNom', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByClientTelephone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientTelephone', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByClientTelephoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientTelephone', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByDateVoyage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateVoyage', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByDateVoyageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateVoyage', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByDevise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devise', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByDeviseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devise', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByHeureDepart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heureDepart', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByHeureDepartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heureDepart', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByModePaiement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modePaiement', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByModePaiementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modePaiement', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByNumeroBillet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroBillet', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByNumeroBilletDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroBillet', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByPrixPaye() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prixPaye', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByPrixPayeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prixPaye', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByReceveurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receveurMatricule', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByReceveurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receveurMatricule', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByScannedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scannedAt', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByScannedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scannedAt', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByScannedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scannedBy', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByScannedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scannedBy', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByStatutBillet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statutBillet', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByStatutBilletDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statutBillet', Sort.desc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ScannedTicketQueryWhereDistinct
    on QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> {
  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByArretArrivee(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arretArrivee', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByArretDepart(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arretDepart', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByBilletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'billetId');
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct>
      distinctByBusImmatriculation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'busImmatriculation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByBusNumero(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'busNumero', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct>
      distinctByChauffeurMatricule({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chauffeurMatricule',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByClientNom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientNom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct>
      distinctByClientTelephone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientTelephone',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByDateVoyage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateVoyage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByDevise(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'devise', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByHeureDepart(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heureDepart', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByModePaiement(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modePaiement', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByNumeroBillet(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numeroBillet', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByPrixPaye() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prixPaye');
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct>
      distinctByReceveurMatricule({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receveurMatricule',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByScannedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scannedAt');
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByScannedBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scannedBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByStatutBillet(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statutBillet', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScannedTicket, ScannedTicket, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ScannedTicketQueryProperty
    on QueryBuilder<ScannedTicket, ScannedTicket, QQueryProperty> {
  QueryBuilder<ScannedTicket, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScannedTicket, String, QQueryOperations> arretArriveeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arretArrivee');
    });
  }

  QueryBuilder<ScannedTicket, String, QQueryOperations> arretDepartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arretDepart');
    });
  }

  QueryBuilder<ScannedTicket, int?, QQueryOperations> billetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'billetId');
    });
  }

  QueryBuilder<ScannedTicket, String?, QQueryOperations>
      busImmatriculationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'busImmatriculation');
    });
  }

  QueryBuilder<ScannedTicket, String?, QQueryOperations> busNumeroProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'busNumero');
    });
  }

  QueryBuilder<ScannedTicket, String?, QQueryOperations>
      chauffeurMatriculeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chauffeurMatricule');
    });
  }

  QueryBuilder<ScannedTicket, String?, QQueryOperations> clientNomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientNom');
    });
  }

  QueryBuilder<ScannedTicket, String?, QQueryOperations>
      clientTelephoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientTelephone');
    });
  }

  QueryBuilder<ScannedTicket, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ScannedTicket, String, QQueryOperations> dateVoyageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateVoyage');
    });
  }

  QueryBuilder<ScannedTicket, String, QQueryOperations> deviseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'devise');
    });
  }

  QueryBuilder<ScannedTicket, String?, QQueryOperations> heureDepartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heureDepart');
    });
  }

  QueryBuilder<ScannedTicket, String, QQueryOperations> modePaiementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modePaiement');
    });
  }

  QueryBuilder<ScannedTicket, String, QQueryOperations> numeroBilletProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numeroBillet');
    });
  }

  QueryBuilder<ScannedTicket, double, QQueryOperations> prixPayeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prixPaye');
    });
  }

  QueryBuilder<ScannedTicket, String?, QQueryOperations>
      receveurMatriculeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receveurMatricule');
    });
  }

  QueryBuilder<ScannedTicket, DateTime, QQueryOperations> scannedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scannedAt');
    });
  }

  QueryBuilder<ScannedTicket, String?, QQueryOperations> scannedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scannedBy');
    });
  }

  QueryBuilder<ScannedTicket, String, QQueryOperations> statutBilletProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statutBillet');
    });
  }

  QueryBuilder<ScannedTicket, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
