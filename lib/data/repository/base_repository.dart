abstract class ApiRepository<T> {
  /// Fetch all items
  Future<T?> getAll();

  /// Create a new item
  Future<T> create(Map<String, dynamic> data);

  /// Update an item by ID
  Future updateById(String id, Map<String, dynamic> data);

  /// Delete an item by ID
  Future deleteById(String id);
}
