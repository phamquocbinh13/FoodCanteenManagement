import 'package:json_annotation/json_annotation.dart';

import 'money.dart';
import 'percentage.dart';
import 'phone_number.dart';
import 'quantity.dart';
import 'session_token.dart';
import 'table_qr_token.dart';

/// Serializes [Money] as `{amount_minor, currency_code}`.
class MoneyConverter implements JsonConverter<Money, Map<String, dynamic>> {
  const MoneyConverter();

  @override
  Money fromJson(Map<String, dynamic> json) => Money.fromJson(json);

  @override
  Map<String, dynamic> toJson(Money object) => object.toJson();
}

/// Serializes [Quantity] as integer minor units count.
class QuantityConverter implements JsonConverter<Quantity, int> {
  const QuantityConverter();

  @override
  Quantity fromJson(int json) => Quantity(json);

  @override
  int toJson(Quantity object) => object.value;
}

/// Serializes [Percentage] as basis points integer.
class PercentageConverter implements JsonConverter<Percentage, int> {
  const PercentageConverter();

  @override
  Percentage fromJson(int json) => Percentage(json);

  @override
  int toJson(Percentage object) => object.basisPoints;
}

/// Serializes [PhoneNumber] as E.164-ish string.
class PhoneNumberConverter implements JsonConverter<PhoneNumber, String> {
  const PhoneNumberConverter();

  @override
  PhoneNumber fromJson(String json) => PhoneNumber(json);

  @override
  String toJson(PhoneNumber object) => object.value;
}

/// Serializes opaque [SessionToken] bearer string.
class SessionTokenConverter implements JsonConverter<SessionToken, String> {
  const SessionTokenConverter();

  @override
  SessionToken fromJson(String json) => SessionToken(json);

  @override
  String toJson(SessionToken object) => object.value;
}

/// Serializes opaque [TableQrToken] join string.
class TableQrTokenConverter implements JsonConverter<TableQrToken, String> {
  const TableQrTokenConverter();

  @override
  TableQrToken fromJson(String json) => TableQrToken(json);

  @override
  String toJson(TableQrToken object) => object.value;
}
