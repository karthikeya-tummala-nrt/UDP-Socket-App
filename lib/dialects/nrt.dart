import 'dart:typed_data';
import 'package:mavlink_nrt/mavlink_dialect.dart';
import 'package:mavlink_nrt/mavlink_message.dart';
import 'package:mavlink_nrt/types.dart';

/// NRT_CONSTANTS
typedef NrtConstants = int;

/// FOUNDED_YEAR
const NrtConstants foundedYear = 2017;

/// OPERATIONAL_TRUE
const NrtConstants operationalTrue = 1;

/// Company information
/// NRT_COMPANY_INFO
class NrtCompanyInfo implements MavlinkMessage {
  static const int _mavlinkMessageId = 200;

  static const int _mavlinkCrcExtra = 85;

  static const int mavlinkEncodedLength = 23;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  ///
  /// MAVLink type: uint16_t
  /// founded_year
  final uint16_t foundedYear;

  ///
  /// MAVLink type: char[20]
  /// headquarters
  final List<char> headquarters;

  ///
  /// MAVLink type: uint8_t
  /// operational
  final uint8_t operational;

  NrtCompanyInfo({
    required this.foundedYear,
    required this.headquarters,
    required this.operational,
  });

  NrtCompanyInfo copyWith({
    uint16_t? foundedYear,
    List<char>? headquarters,
    uint8_t? operational,
  }) {
    return NrtCompanyInfo(
      foundedYear: foundedYear ?? this.foundedYear,
      headquarters: headquarters ?? this.headquarters,
      operational: operational ?? this.operational,
    );
  }

  factory NrtCompanyInfo.parse(ByteData data_) {
    if (data_.lengthInBytes < NrtCompanyInfo.mavlinkEncodedLength) {
      var len = NrtCompanyInfo.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var foundedYear = data_.getUint16(0, Endian.little);
    var headquarters = MavlinkMessage.asInt8List(data_, 2, 20);
    var operational = data_.getUint8(22);

    return NrtCompanyInfo(
      foundedYear: foundedYear,
      headquarters: headquarters,
      operational: operational,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint16(0, foundedYear, Endian.little);
    MavlinkMessage.setInt8List(data_, 2, headquarters);
    data_.setUint8(22, operational);
    return data_;
  }
}

/// Company location
/// NRT_LOCATION
class NrtLocation implements MavlinkMessage {
  static const int _mavlinkMessageId = 201;

  static const int _mavlinkCrcExtra = 216;

  static const int mavlinkEncodedLength = 20;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  ///
  /// MAVLink type: char[20]
  /// city
  final List<char> city;

  NrtLocation({required this.city});

  NrtLocation copyWith({List<char>? city}) {
    return NrtLocation(city: city ?? this.city);
  }

  factory NrtLocation.parse(ByteData data_) {
    if (data_.lengthInBytes < NrtLocation.mavlinkEncodedLength) {
      var len = NrtLocation.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var city = MavlinkMessage.asInt8List(data_, 0, 20);

    return NrtLocation(city: city);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    MavlinkMessage.setInt8List(data_, 0, city);
    return data_;
  }
}

/// Operational status
/// NRT_STATUS
class NrtStatus implements MavlinkMessage {
  static const int _mavlinkMessageId = 202;

  static const int _mavlinkCrcExtra = 195;

  static const int mavlinkEncodedLength = 1;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  ///
  /// MAVLink type: uint8_t
  /// active
  final uint8_t active;

  NrtStatus({required this.active});

  NrtStatus copyWith({uint8_t? active}) {
    return NrtStatus(active: active ?? this.active);
  }

  factory NrtStatus.parse(ByteData data_) {
    if (data_.lengthInBytes < NrtStatus.mavlinkEncodedLength) {
      var len = NrtStatus.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var active = data_.getUint8(0);

    return NrtStatus(active: active);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint8(0, active);
    return data_;
  }
}

class MavlinkDialectNrt implements MavlinkDialect {
  static const int mavlinkVersion = 3;

  @override
  int get version => mavlinkVersion;

  @override
  MavlinkMessage? parse(int messageID, ByteData data) {
    switch (messageID) {
      case 200:
        return NrtCompanyInfo.parse(data);
      case 201:
        return NrtLocation.parse(data);
      case 202:
        return NrtStatus.parse(data);
      default:
        return null;
    }
  }

  @override
  int crcExtra(int messageID) {
    switch (messageID) {
      case 200:
        return NrtCompanyInfo._mavlinkCrcExtra;
      case 201:
        return NrtLocation._mavlinkCrcExtra;
      case 202:
        return NrtStatus._mavlinkCrcExtra;
      default:
        return -1;
    }
  }
}
