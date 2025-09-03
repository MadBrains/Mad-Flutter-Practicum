// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyDto _$CurrencyDtoFromJson(Map<String, dynamic> json) => CurrencyDto(
      id: json['ID'] as String? ?? '',
      nominal: (json['Nominal'] as num?)?.toInt() ?? 0,
      name: json['Name'] as String? ?? '',
      symbol: json['CharCode'] as String? ?? '',
      value: (json['Value'] as num?)?.toDouble() ?? 0,
      previousValue: (json['Previous'] as num?)?.toDouble() ?? 0,
    );

CurrencyListResponseDto _$CurrencyListResponseDtoFromJson(Map<String, dynamic> json) => CurrencyListResponseDto(
      valute: (json['Valute'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, CurrencyDto.fromJson(e as Map<String, dynamic>)),
          ) ??
          {},
    );
