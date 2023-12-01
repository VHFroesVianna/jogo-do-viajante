import 'dart:io';
import 'package:trabalho_ed1/mochila/mochila.dart';
import 'package:trabalho_ed1/tesouro/tesouro.dart';
import 'package:trabalho_ed1/tesouro/tesouros/anel.dart';
import 'package:trabalho_ed1/tesouro/tesouros/barra.dart';
import 'package:trabalho_ed1/tesouro/tesouros/bracelete.dart';
import 'package:trabalho_ed1/tesouro/tesouros/brinco.dart';
import 'package:trabalho_ed1/tesouro/tesouros/calice.dart';
import 'package:trabalho_ed1/tesouro/tesouros/colar.dart';
import 'package:trabalho_ed1/tesouro/tesouros/coroa.dart';
import 'package:trabalho_ed1/tesouro/tesouros/corrente.dart';
import 'package:trabalho_ed1/tesouro/tesouros/espada.dart';
import 'package:trabalho_ed1/tesouro/tesouros/gema_preciosa.dart';
import 'package:trabalho_ed1/tesouro/tesouros/moedas.dart';
import 'package:trabalho_ed1/tesouro/tesouros/pulseira.dart';

void main(List<String> args) async {
  //criada instância da classe mochila
  final mochila = Mochila();

  //lista de tesouros usando a função selectTesouros() que retorna essa lista
  final tesourosSorteados = sortearTesouros();

  //melhor resultado possível utilizando o pricípio de algoritmos gulosos
  final gabarito = gabaritoGuloso(tesourosSorteados);

  //primeiro parágrafo do programa
  final paragrafo1 = getParagrafos(tesourosSorteados)['p1'];
  await printParagrafoComDelay(paragrafo1!);

  //tela de seleção dos tesouros
  await selecionarTesouros(mochila, tesourosSorteados);

  //segundo parágrafo do programa
  final paragrafo2 = getParagrafos(tesourosSorteados)['p2'];
  await printParagrafoComDelay(paragrafo2!);

  mochila.tesourosGuardados.sort((a, b) => b.valor.compareTo(a.valor));
  gabarito.sort((a, b) => b.valor.compareTo(a.valor));

  if (mochila.tesourosGuardados.contains(gabarito[0]) &&
      mochila.tesourosGuardados.contains(gabarito[1]) &&
      mochila.tesourosGuardados.contains(gabarito[2])) {
    //terceiro parágrafo do programa
    final paragrafo3 = getParagrafos(tesourosSorteados)['p3'];
    await printParagrafoComDelay(paragrafo3!);
  } else {
    //quarto parágrafo do programa
    final paragrafo4 = getParagrafos(tesourosSorteados)['p4'];
    await printParagrafoComDelay(paragrafo4!);
    print('GABARITO:');
    for (var tesouro in gabarito) {
      print('Nome do item: ${tesouro.nome}');
    }
  }
}

///laço while que só para de executar quando o jogador guardar 3 tesouros
Future<void> selecionarTesouros(
  Mochila mochila,
  List<Tesouro> tesourosSorteados,
) async {
  while (mochila.tesourosGuardados.length < 3) {
    //guarda na mochila o tesouro no índice que o jogador escolher
    mochila.guardarTesouro(
        tesourosSorteados[int.parse(stdin.readLineSync()!) - 1]);
    //se a soma dos volumes dos tesouros escolhidos for maior que o volume total da mochila, ela será esvaziada
    if (mochila.volumeOcupado > mochila.volumeInterno) {
      await volumeExcedido(tesourosSorteados, mochila);
    }
  }
}

///função que limpa a mochila e avisa ao usuário que escolheu uma combinação inválida
Future<void> volumeExcedido(
  List<Tesouro> tesourosSorteados,
  Mochila mochila,
) async {
  mochila.limparMochila();
  await printParagrafoComDelay(
      """SUA MOCHILA NÃO É GRANDE O SUFICIENTE PARA GUARDAR ESSA COMBINAÇÃO DE TESOUROS.
ESCOLHA NOVAMENTE.""");
  print("""${descricaoTodosTesouros(tesourosSorteados)}\n
  SELECIONE OS NÚMEROS DOS TESOUROS QUE DESEJA GUARDAR EM SUA MOCHILA:""");
}

///retorna todos os parágrafos usados no programa
Map<String, String> getParagrafos(List<Tesouro> tesourosSorteados) => {
      'p1':
          """VIAJANTE, SELECIONE OS TESOUROS QUE DESEJA, PEGUE 3 OU SEJA AMALDIÇOADO POR SUA GANÂNCIA!
VOCÊ DEVE FAZER UMA ESCOLHA QUE PREENCHA AO MÁXIMO SUA MOCHILA, QUE TENHA O MAIOR VALOR EM OURO POSSÍVEL
E QUE TENHA O MENOR PESO.\n
SUAS OPÇÕES SÃO:\n
${descricaoTodosTesouros(tesourosSorteados)}\n
SELECIONE OS NÚMEROS DOS TESOUROS QUE DESEJA GUARDAR EM SUA MOCHILA:""",
      'p2': """VOCÊ FEZ SUA ESCOLHA, VIAJANTE.\n
SERÁ QUE FOI A MELHOR DECISÃO POSSÍVEL?\n""",
      'p3': """PARABÉNS VIAJANTE!\n VOCÊ FEZ A MELHOR ESCOLHA POSSÍVEL E
AO CHEGAR SEGURO EM SUA CIDADE, VENDEU OS TESOUROS E FICOU RICO!""",
      'p4': """NÃO FOI A MELHOR ESCOLHA, VIAJANTE.\n
NO CAMINHO DE VOLTA PARA CASA SUA CASA SUA MOCHILA SE ABRIU E VOCÊ 
PERDEU TODOS OS ITENS QUE COLETOU. VOCÊ ENCONTROU UM GRUPO DE GOBLINS E FOI MORTO.\n
MAIS SORTE DA PRÓXIMA VEZ!"""
    };

///recebe uma string como parâmetro e printa no console a mesma só que um certo delay
Future<void> printParagrafoComDelay(String paragrafo) async {
  String novaFrase = '';
  for (int i = 0; i < paragrafo.length; i++) {
    novaFrase += paragrafo[i]; //adiciona à nova frase uma nova letra
    limpaTela();
    print(novaFrase);
    //aqui o programa irá esperar 50 milisegundos para printar
    //cada nova frase, dando a impressão de um jogo antigo!
    await Future.delayed(Duration(microseconds: 1));
  }
}

///limpa a tela do console
void limpaTela() {
  print(Process.runSync("clear", [], runInShell: true).stdout);
  print("\x1B[2J\x1B[0;0H");
}

///retorna um bloco de string com a descrição de todos os tesouros passados
String descricaoTodosTesouros(List<Tesouro> tesouros) {
  String string = '';
  for (int i = 0; i < tesouros.length; i++) {
    string +=
        'Tesouro ${i + 1}: ${tesouros[i].nome}\n${tesouros[i].descricaoCompleta()}\n';
  }
  return string;
}

///função que retorna a lista dos 5 tesouros, já embaralhados
List<Tesouro> sortearTesouros() {
  //pegamos a lista com TODOS os 12 tesouros usando o getTesouros() e em seguida embaralhamos
  List<Tesouro> tesourosSelecionados = getTesouros();
  //shuffle embaralha a lista
  tesourosSelecionados.shuffle();
  //método sublist corta essa lista e pega os 5 primeiros elementos
  return tesourosSelecionados.sublist(0, 5);
}

///aqui eu simplesmente criei todos os tesouros diferentes e retorno eles em uma lista
List<Tesouro> getTesouros() {
  return [
    Anel(
      valor: 13,
      pesoEstimado: 2,
      volume: 2,
      descricao: 'Um simples anel de ouro adornado com rubis.',
      nome: 'Anel',
    ),
    Barra(
      valor: 40,
      pesoEstimado: 30,
      volume: 5,
      descricao: 'Uma barra maciça de ouro.',
      nome: 'Barra',
    ),
    Bracelete(
      valor: 11,
      pesoEstimado: 2,
      volume: 4,
      descricao: 'Um bracelete da realeza, incrustado com joias negras.',
      nome: 'Bracelete',
    ),
    Brincos(
      valor: 15,
      pesoEstimado: 2,
      volume: 3,
      descricao: 'Brincos de roubados do túmulo da falecida rainha do reino.',
      nome: 'Brincos',
    ),
    Calice(
      valor: 9,
      pesoEstimado: 3,
      volume: 6,
      descricao:
          'Um lindo cálice ornamentado. Usado pelos nobres da região para beber vinho.',
      nome: 'Cálice',
    ),
    Colar(
      valor: 15,
      pesoEstimado: 4,
      volume: 4,
      descricao:
          'Um colar com uma inscrição, parecem ser as inicias de algum joalheiro.',
      nome: 'Colar',
    ),
    Coroa(
      valor: 20,
      pesoEstimado: 4,
      volume: 5,
      descricao:
          'É de conhecimento geral que que coroas são extremamente raras fora da posse de um rei.',
      nome: 'Coroa',
    ),
    Corrente(
      valor: 12,
      pesoEstimado: 10,
      volume: 4,
      descricao:
          'Uma corrente enferrujada da antiguidade, talvez tenha valor histórico.',
      nome: 'Corrente',
    ),
    Espada(
      valor: 26,
      pesoEstimado: 10,
      volume: 9,
      descricao: 'Uma espada lendária de um comandante que morreu em combate.',
      nome: 'Espada',
    ),
    GemaPreciosa(
      valor: 10,
      pesoEstimado: 2,
      volume: 2,
      descricao: 'Uma gema lapidada de obsidiana pura.',
      nome: 'Gema Preciosa',
    ),
    Moedas(
      valor: 17,
      pesoEstimado: 5,
      volume: 7,
      descricao: 'Um saco de moedas de ouro e platina misturadas.',
      nome: 'Moedas',
    ),
    Pulseira(
      valor: 7,
      pesoEstimado: 2,
      volume: 2,
      descricao:
          'Uma pulseira simples, provavelmente feita por algum artesão camponês.',
      nome: 'Pulseira',
    )
  ];
}

///recebe um tesouro e retorna seu valor
double valorDoTesouro(Tesouro tesouro) =>
    ((tesouro.valor * 1.4) - (tesouro.pesoEstimado * 1.2)).roundToDouble();

///retorna a melhor resposta possível da combinação dos 3 tesouros
List<Tesouro> gabaritoGuloso(List<Tesouro> tesouros) {
  List<Tesouro> melhorCombinacao = [];
  double melhorValor = 0.0;

  //gera todas as combinações de 3 tesouros
  for (int i = 0; i < tesouros.length - 2; i++) {
    for (int j = i + 1; j < tesouros.length - 1; j++) {
      for (int k = j + 1; k < tesouros.length; k++) {
        List<Tesouro> combinacaoAtual = [tesouros[i], tesouros[j], tesouros[k]];

        //calcula o volume total da combinação atual
        double volumeTotal =
            combinacaoAtual.fold(0.0, (acc, tesouro) => acc + tesouro.volume);

        //verifica se o volume total está dentro do limite da mochila
        if (volumeTotal <= Mochila().volumeInterno) {
          //calcula o valor total para a combinação atual
          double valorTotal = combinacaoAtual.fold(
              0.0, (acc, tesouro) => acc + valorDoTesouro(tesouro));

          //atualiza o valor da melhor combinação caso a combinação atual seja melhor
          if (valorTotal > melhorValor) {
            melhorCombinacao = combinacaoAtual;
            melhorValor = valorTotal;
          }
        }
      }
    }
  }

  return melhorCombinacao;
}
