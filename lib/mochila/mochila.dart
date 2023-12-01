import 'package:trabalho_ed1/tesouro/tesouro.dart';

class Mochila {
  //inventário do jogador, aqui ficarão todos os tesouros que o mesmo escolher guardar
  List<Tesouro> tesourosGuardados = [];

  //capacidade da mochila, não será permitido passar de 15 somando todos os itens
  static const int _volumeInterno = 15;

  get volumeInterno => _volumeInterno;

  int get volumeOcupado {
    int volumeOcupado = 0;
    for (Tesouro tesouro in tesourosGuardados) {
      volumeOcupado += tesouro.volume;
    }
    return volumeOcupado;
  }

  ///método que guarda o tesouro passado na mochila
  void guardarTesouro(Tesouro tesouro) => tesourosGuardados.add(tesouro);

  ///método que guarda todos os tesouros de uma vez, recebe a lista com os tesouros selecionados pelo jogador
  void guardarTodos(List<Tesouro> tesouros) =>
      tesourosGuardados.addAll(tesouros);

  ///esvazia a mochila
  void limparMochila() => tesourosGuardados = [];
}
