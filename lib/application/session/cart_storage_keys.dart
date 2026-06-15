/// Local storage keys for session-scoped cart persistence.
abstract final class CartStorageKeys {
  static String cartJson(String sessionId) => 'cart:session:$sessionId';
}
