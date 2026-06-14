import '../../domain/entities/menu_item.dart';
import 'mapper.dart';

typedef MenuItemDto = Map<String, dynamic>;

final class MenuMapper implements BidirectionalMapper<MenuItem, MenuItemDto> {
  const MenuMapper();

  @override
  MenuItem toEntity(MenuItemDto dto) {
    throw UnimplementedError('MenuMapper.toEntity not implemented');
  }

  @override
  MenuItemDto toDto(MenuItem entity) {
    throw UnimplementedError('MenuMapper.toDto not implemented');
  }
}
