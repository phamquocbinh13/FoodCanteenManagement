/// Formats [Money] for customer-facing display.
String formatMoneyDisplay({
  required int amountMinor,
  required String currencyCode,
}) {
  final amount = (amountMinor / 100).round();
  final formatted = amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
  if (currencyCode == 'VND') return '$formatted ₫';
  return '\$${(amountMinor / 100).toStringAsFixed(2)}';
}
