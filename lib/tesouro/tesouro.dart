///classe abstrata tesouro que serve apenas como modelo para os tesouros concretos
abstract class Tesouro {
  final String nome;
  final double valor;
  final int pesoEstimado;
  final int volume;
  final String descricao;

  Tesouro({
    required this.nome,
    required this.valor,
    required this.pesoEstimado,
    required this.volume,
    required this.descricao,
  });

  String descricaoCompleta() {
    return """Descrição -> $descricao\nvalor -> $valor peças de ouro\npeso estimado -> $pesoEstimado\nvolume -> $volume\n""";
  }
}
