import '../../domain/entities/staff_user.dart';
import 'mapper.dart';

typedef UserDto = Map<String, dynamic>;

final class UserMapper implements BidirectionalMapper<StaffUser, UserDto> {
  const UserMapper();

  @override
  StaffUser toEntity(UserDto dto) {
    throw UnimplementedError('UserMapper.toEntity not implemented');
  }

  @override
  UserDto toDto(StaffUser entity) {
    throw UnimplementedError('UserMapper.toDto not implemented');
  }
}
