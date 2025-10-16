// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_session_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDriverSessionCollection on Isar {
  IsarCollection<DriverSession> get driverSessions => this.collection();
}

const DriverSessionSchema = CollectionSchema(
  name: r'DriverSession',
  id: 5082153524280878435,
  properties: {
    r'busNumber': PropertySchema(
      id: 0,
      name: r'busNumber',
      type: IsarType.string,
    ),
    r'chauffeurMatricule': PropertySchema(
      id: 1,
      name: r'chauffeurMatricule',
      type: IsarType.string,
    ),
    r'controleurMatricule': PropertySchema(
      id: 2,
      name: r'controleurMatricule',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(
      id: 4,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'loginTimestamp': PropertySchema(
      id: 5,
      name: r'loginTimestamp',
      type: IsarType.dateTime,
    ),
    r'logoutTimestamp': PropertySchema(
      id: 6,
      name: r'logoutTimestamp',
      type: IsarType.dateTime,
    ),
    r'receveurMatricule': PropertySchema(
      id: 7,
      name: r'receveurMatricule',
      type: IsarType.string,
    ),
    r'route': PropertySchema(
      id: 8,
      name: r'route',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _driverSessionEstimateSize,
  serialize: _driverSessionSerialize,
  deserialize: _driverSessionDeserialize,
  deserializeProp: _driverSessionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _driverSessionGetId,
  getLinks: _driverSessionGetLinks,
  attach: _driverSessionAttach,
  version: '3.1.0+1',
);

int _driverSessionEstimateSize(
  DriverSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.busNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.chauffeurMatricule.length * 3;
  bytesCount += 3 + object.controleurMatricule.length * 3;
  bytesCount += 3 + object.receveurMatricule.length * 3;
  {
    final value = object.route;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _driverSessionSerialize(
  DriverSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.busNumber);
  writer.writeString(offsets[1], object.chauffeurMatricule);
  writer.writeString(offsets[2], object.controleurMatricule);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeBool(offsets[4], object.isActive);
  writer.writeDateTime(offsets[5], object.loginTimestamp);
  writer.writeDateTime(offsets[6], object.logoutTimestamp);
  writer.writeString(offsets[7], object.receveurMatricule);
  writer.writeString(offsets[8], object.route);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

DriverSession _driverSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DriverSession(
    busNumber: reader.readStringOrNull(offsets[0]),
    chauffeurMatricule: reader.readStringOrNull(offsets[1]) ?? '',
    controleurMatricule: reader.readStringOrNull(offsets[2]) ?? '',
    isActive: reader.readBoolOrNull(offsets[4]) ?? true,
    logoutTimestamp: reader.readDateTimeOrNull(offsets[6]),
    receveurMatricule: reader.readStringOrNull(offsets[7]) ?? '',
    route: reader.readStringOrNull(offsets[8]),
  );
  object.createdAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.loginTimestamp = reader.readDateTime(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  return object;
}

P _driverSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _driverSessionGetId(DriverSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _driverSessionGetLinks(DriverSession object) {
  return [];
}

void _driverSessionAttach(
    IsarCollection<dynamic> col, Id id, DriverSession object) {
  object.id = id;
}

extension DriverSessionQueryWhereSort
    on QueryBuilder<DriverSession, DriverSession, QWhere> {
  QueryBuilder<DriverSession, DriverSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DriverSessionQueryWhere
    on QueryBuilder<DriverSession, DriverSession, QWhereClause> {
  QueryBuilder<DriverSession, DriverSession, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DriverSession, DriverSession, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterWhereClause> idBetween(
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

extension DriverSessionQueryFilter
    on QueryBuilder<DriverSession, DriverSession, QFilterCondition> {
  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'busNumber',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'busNumber',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'busNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'busNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'busNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'busNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'busNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'busNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'busNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'busNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'busNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      busNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'busNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      chauffeurMatriculeEqualTo(
    String value, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      chauffeurMatriculeGreaterThan(
    String value, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      chauffeurMatriculeLessThan(
    String value, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      chauffeurMatriculeBetween(
    String lower,
    String upper, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      chauffeurMatriculeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chauffeurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      chauffeurMatriculeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chauffeurMatricule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      chauffeurMatriculeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chauffeurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      chauffeurMatriculeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chauffeurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'controleurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'controleurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'controleurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'controleurMatricule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'controleurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'controleurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'controleurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'controleurMatricule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'controleurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      controleurMatriculeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'controleurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      loginTimestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loginTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      loginTimestampGreaterThan(
    DateTime value, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      loginTimestampLessThan(
    DateTime value, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      loginTimestampBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      logoutTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'logoutTimestamp',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      logoutTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'logoutTimestamp',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      logoutTimestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoutTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      logoutTimestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoutTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      logoutTimestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoutTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      logoutTimestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoutTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      receveurMatriculeEqualTo(
    String value, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      receveurMatriculeGreaterThan(
    String value, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      receveurMatriculeLessThan(
    String value, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      receveurMatriculeBetween(
    String lower,
    String upper, {
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      receveurMatriculeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receveurMatricule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      receveurMatriculeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receveurMatricule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      receveurMatriculeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receveurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      receveurMatriculeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receveurMatricule',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'route',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'route',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'route',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'route',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'route',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'route',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'route',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'route',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'route',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'route',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'route',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      routeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'route',
        value: '',
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

  QueryBuilder<DriverSession, DriverSession, QAfterFilterCondition>
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

extension DriverSessionQueryObject
    on QueryBuilder<DriverSession, DriverSession, QFilterCondition> {}

extension DriverSessionQueryLinks
    on QueryBuilder<DriverSession, DriverSession, QFilterCondition> {}

extension DriverSessionQuerySortBy
    on QueryBuilder<DriverSession, DriverSession, QSortBy> {
  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> sortByBusNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busNumber', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByBusNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busNumber', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByChauffeurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chauffeurMatricule', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByChauffeurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chauffeurMatricule', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByControleurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'controleurMatricule', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByControleurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'controleurMatricule', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByLoginTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loginTimestamp', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByLoginTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loginTimestamp', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByLogoutTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoutTimestamp', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByLogoutTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoutTimestamp', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByReceveurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receveurMatricule', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByReceveurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receveurMatricule', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> sortByRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'route', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> sortByRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'route', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DriverSessionQuerySortThenBy
    on QueryBuilder<DriverSession, DriverSession, QSortThenBy> {
  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> thenByBusNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busNumber', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByBusNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'busNumber', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByChauffeurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chauffeurMatricule', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByChauffeurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chauffeurMatricule', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByControleurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'controleurMatricule', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByControleurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'controleurMatricule', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByLoginTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loginTimestamp', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByLoginTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loginTimestamp', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByLogoutTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoutTimestamp', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByLogoutTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoutTimestamp', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByReceveurMatricule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receveurMatricule', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByReceveurMatriculeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receveurMatricule', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> thenByRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'route', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> thenByRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'route', Sort.desc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DriverSessionQueryWhereDistinct
    on QueryBuilder<DriverSession, DriverSession, QDistinct> {
  QueryBuilder<DriverSession, DriverSession, QDistinct> distinctByBusNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'busNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QDistinct>
      distinctByChauffeurMatricule({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chauffeurMatricule',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QDistinct>
      distinctByControleurMatricule({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'controleurMatricule',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DriverSession, DriverSession, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<DriverSession, DriverSession, QDistinct>
      distinctByLoginTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loginTimestamp');
    });
  }

  QueryBuilder<DriverSession, DriverSession, QDistinct>
      distinctByLogoutTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoutTimestamp');
    });
  }

  QueryBuilder<DriverSession, DriverSession, QDistinct>
      distinctByReceveurMatricule({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receveurMatricule',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QDistinct> distinctByRoute(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'route', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DriverSession, DriverSession, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DriverSessionQueryProperty
    on QueryBuilder<DriverSession, DriverSession, QQueryProperty> {
  QueryBuilder<DriverSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DriverSession, String?, QQueryOperations> busNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'busNumber');
    });
  }

  QueryBuilder<DriverSession, String, QQueryOperations>
      chauffeurMatriculeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chauffeurMatricule');
    });
  }

  QueryBuilder<DriverSession, String, QQueryOperations>
      controleurMatriculeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'controleurMatricule');
    });
  }

  QueryBuilder<DriverSession, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DriverSession, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<DriverSession, DateTime, QQueryOperations>
      loginTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loginTimestamp');
    });
  }

  QueryBuilder<DriverSession, DateTime?, QQueryOperations>
      logoutTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoutTimestamp');
    });
  }

  QueryBuilder<DriverSession, String, QQueryOperations>
      receveurMatriculeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receveurMatricule');
    });
  }

  QueryBuilder<DriverSession, String?, QQueryOperations> routeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'route');
    });
  }

  QueryBuilder<DriverSession, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
