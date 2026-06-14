/// Converts between DTOs (data layer) and domain entities.
///
/// Mapping must never happen inside UI widgets.
abstract interface class Mapper<From, To> {
  To map(From source);
}

/// Bidirectional mapper for entities that round-trip through persistence.
abstract interface class BidirectionalMapper<Entity, Dto> {
  Entity toEntity(Dto dto);
  Dto toDto(Entity entity);
}

/// Batch mapper for lists.
extension MapperListExtension<From, To> on Mapper<From, To> {
  List<To> mapList(Iterable<From> sources) =>
      sources.map(map).toList(growable: false);
}
