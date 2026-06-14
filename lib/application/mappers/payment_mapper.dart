import '../../domain/entities/session_payment.dart';
import 'mapper.dart';

typedef PaymentDto = Map<String, dynamic>;

final class PaymentMapper
    implements BidirectionalMapper<SessionPayment, PaymentDto> {
  const PaymentMapper();

  @override
  SessionPayment toEntity(PaymentDto dto) {
    throw UnimplementedError('PaymentMapper.toEntity not implemented');
  }

  @override
  PaymentDto toDto(SessionPayment entity) {
    throw UnimplementedError('PaymentMapper.toDto not implemented');
  }
}
