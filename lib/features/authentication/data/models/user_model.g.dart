// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      name: fields[2] as String?,
      imageUrl: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      createdAt: fields[5] as String?,
      role: fields[6] as String?,
      gender: fields[7] as String?,
      bio: fields[8] as String?,
      dob: fields[9] as String?,
      loginType: fields[10] as String?,
      fcmToken: fields[11] as String?,
      country: fields[12] as String?,
      ip: fields[13] as String?,
      status: fields[14] as String?,
      lastLogin: fields[15] as String?,
      userId: fields[16] as int?,
      onboarded: fields[17] as bool?,
      updatedAt: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.role)
      ..writeByte(7)
      ..write(obj.gender)
      ..writeByte(8)
      ..write(obj.bio)
      ..writeByte(9)
      ..write(obj.dob)
      ..writeByte(10)
      ..write(obj.loginType)
      ..writeByte(11)
      ..write(obj.fcmToken)
      ..writeByte(12)
      ..write(obj.country)
      ..writeByte(13)
      ..write(obj.ip)
      ..writeByte(14)
      ..write(obj.status)
      ..writeByte(15)
      ..write(obj.lastLogin)
      ..writeByte(16)
      ..write(obj.userId)
      ..writeByte(17)
      ..write(obj.onboarded)
      ..writeByte(18)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
