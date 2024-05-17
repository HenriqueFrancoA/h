abstract class Api {
  Future<dynamic> create(Object object);
  Future<bool> update(Object object);
  Future<bool> delete(String id);
}
