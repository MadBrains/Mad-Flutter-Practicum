import 'package:json_annotation/json_annotation.dart';

part 'currency_dto.g.dart';

@JsonSerializable(createToJson: false)
class CurrencyDto {
  const CurrencyDto({
    required this.id,
    required this.nominal,
    required this.name,
    required this.symbol,
    required this.value,
    required this.previousValue,
  });

  factory CurrencyDto.fromJson(Map<String, dynamic> json) => _$CurrencyDtoFromJson(json);

  @JsonKey(name: 'ID', defaultValue: '')
  final String id;

  @JsonKey(name: 'Nominal', defaultValue: 0)
  final int nominal;

  @JsonKey(name: 'Name', defaultValue: '')
  final String name;

  @JsonKey(name: 'CharCode', defaultValue: '')
  final String symbol;

  @JsonKey(name: 'Value', defaultValue: 0)
  final double value;

  @JsonKey(name: 'Previous', defaultValue: 0)
  final double previousValue;
}

@JsonSerializable(createToJson: false)
class CurrencyListResponseDto {
  const CurrencyListResponseDto({required this.valute});

  factory CurrencyListResponseDto.fromJson(Map<String, dynamic> json) => _$CurrencyListResponseDtoFromJson(json);

  @JsonKey(name: 'Valute', defaultValue: <String, CurrencyDto>{})
  final Map<String, CurrencyDto> valute;
}
