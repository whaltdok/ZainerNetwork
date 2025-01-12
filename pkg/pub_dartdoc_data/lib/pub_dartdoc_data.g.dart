// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pub_dartdoc_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PubDartdocData _$PubDartdocDataFromJson(Map<String, dynamic> json) =>
    PubDartdocData(
      coverage: json['coverage'] == null
          ? null
          : Coverage.fromJson(json['coverage'] as Map<String, dynamic>),
      apiElements: (json['apiElements'] as List<dynamic>?)
          ?.map((e) => ApiElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PubDartdocDataToJson(PubDartdocData instance) =>
    <String, dynamic>{
      'coverage': instance.coverage,
      'apiElements': instance.apiElements,
    };

ApiElement _$ApiElementFromJson(Map<String, dynamic> json) => ApiElement(
      name: json['name'] as String,
      kind: json['kind'] as String,
      parent: json['parent'] as String?,
      source: json['source'] as String?,
      href: json['href'] as String?,
      documentation: json['documentation'] as String?,
    );

Map<String, dynamic> _$ApiElementToJson(ApiElement instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'kind': instance.kind,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('parent', instance.parent);
  writeNotNull('source', instance.source);
  writeNotNull('href', instance.href);
  writeNotNull('documentation', instance.documentation);
  return val;
}

Coverage _$CoverageFromJson(Map<String, dynamic> json) => Coverage(
      total: json['total'] as int,
      documented: json['documented'] as int,
    );

Map<String, dynamic> _$CoverageToJson(Coverage instance) => <String, dynamic>{
      'total': instance.total,
      'documented': instance.documented,
    };
