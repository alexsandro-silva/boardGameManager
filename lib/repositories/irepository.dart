abstract class IRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getOneById(String id);
  Future<void> insert(T t);
  Future<void> update(T t);
  Future<void> delete(String id);
}
