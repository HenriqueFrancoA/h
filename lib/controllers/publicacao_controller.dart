import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/models/comentario.dart';
import 'package:h/models/publicacao.dart';

class PublicacaoController extends GetxController {
  final loginController = Get.put(LoginController());

  RxList<Publicacao> listPublicacao = RxList<Publicacao>();
  RxList<Comentario> listComentario = RxList<Comentario>();

  carregarPublicacao() async {
    listPublicacao.clear();

    Publicacao publi = Publicacao(
      usuario: loginController.usuarioLogado.first,
      imagem: true,
      texto:
          'Eu e o meu parceiro @FinnBolado #deOntem #HdA #ReiGeladoNaoGuenta',
      dataCriacao: Timestamp.now(),
      curtidas: 320,
      comentarios: 15,
      compartilhamentos: 10,
    );
    Publicacao outraPubli = Publicacao(
      usuario: loginController.usuarioLogado.first,
      imagem: false,
      texto: 'ESSE GAROTO É LOUCO',
      dataCriacao: Timestamp.now(),
      curtidas: 999,
      comentarios: 54,
      compartilhamento: publi,
      compartilhamentos: 252,
    );

    listPublicacao.add(publi);
    listPublicacao.add(outraPubli);
    listPublicacao.add(publi);
    listPublicacao.add(outraPubli);
    listPublicacao.add(publi);
    listPublicacao.add(outraPubli);
    listPublicacao.add(publi);
    listPublicacao.add(outraPubli);
    listPublicacao.add(publi);
    listPublicacao.add(outraPubli);

    publi.imagem = false;
    outraPubli.compartilhamento = null;
    Comentario coment = Comentario(
      publicacao: publi,
      resposta: publi,
    );
    Comentario comentario = Comentario(
      publicacao: publi,
      resposta: outraPubli,
    );

    listComentario.add(coment);
    listComentario.add(comentario);
    listComentario.add(coment);
    listComentario.add(comentario);
    listComentario.add(coment);
    listComentario.add(comentario);
  }
}
