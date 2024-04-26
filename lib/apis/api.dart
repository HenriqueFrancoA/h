abstract class Api {
  Future<dynamic> criar(Object objeto);
  Future<bool> atualizar(Object objeto);
  Future<bool> deletar(String id);
}
