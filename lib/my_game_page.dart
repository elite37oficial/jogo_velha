// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class MyGame extends StatefulWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  List grade = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  String jogadorAtual = 'X';
  String textoInformativo = 'Vamos começar?';
  bool jogoIniciado = false;
  int jogadas = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AbsorbPointer(
            absorbing: !jogoIniciado,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Jogo da Velha",
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.black,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  myButton(linha: 0, coluna: 0),
                  myButton(linha: 0, coluna: 1),
                  myButton(linha: 0, coluna: 2),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  myButton(linha: 1, coluna: 0),
                  myButton(linha: 1, coluna: 1),
                  myButton(linha: 1, coluna: 2),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  myButton(linha: 2, coluna: 0),
                  myButton(linha: 2, coluna: 1),
                  myButton(linha: 2, coluna: 2),
                ]),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  textoInformativo,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              AbsorbPointer(
                  absorbing: jogoIniciado,
                  child: Opacity(
                      opacity: jogoIniciado ? 0 : 1, child: btInicio())),
            ],
          ),
        ],
      ),
    );
  }

  Widget myButton({required int linha, required int coluna}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AbsorbPointer(
        absorbing: grade[linha][coluna] == '' ? false : true,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              clique(coluna: coluna, linha: linha);
            });
          },
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(100, 100), primary: Colors.black38),
          child: Text(
            grade[linha][coluna],
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }

  Widget btInicio() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            jogoIniciado = true;
            jogadas = 0;
            grade = List.generate(3, (i) => List.filled(3, ''));
            textoInformativo = '$jogadorAtual é sua vez.';
          });
        },
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(200, 50), primary: Colors.amber),
        child: Text(
          jogadas > 0 ? "Jogar Novamente" : "Bora Jogar!",
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  //logica do click
  void clique({required int linha, required int coluna}) {
    jogadas++;
    grade[linha][coluna] = jogadorAtual;
    bool existeVencedor =
        verificaVencedor(jogador: jogadorAtual, linha: linha, coluna: coluna);

    if (existeVencedor) {
      textoInformativo = '$jogadorAtual Venceu!';
      jogoIniciado = false;
    } else if (existeVencedor == false && jogadas == 9) {
      textoInformativo = 'Empate!';
      jogoIniciado = false;
    } else {
      if (jogadorAtual == 'X') {
        jogadorAtual = 'O';
      } else {
        jogadorAtual = 'X';
      }
      textoInformativo = '$jogadorAtual é sua vez.';
    }
  }

  bool verificaVencedor(
      {required String jogador, required int linha, required int coluna}) {
    bool venceu = true;
    //verfica linha
    for (int i = 0; i < 3; i++) {
      if (grade[linha][i] != jogador) {
        venceu = false;
        break;
      }
    }
    //verifica coluna
    if (venceu == false) {
      for (int j = 0; j < 3; j++) {
        if (grade[j][coluna] != jogador) {
          venceu = false;
          break;
        } else {
          venceu = true;
        }
      }
    }

    //verifica diagonal
    if (venceu == false) {
      if (grade[1][1] == jogador) {
        if (grade[0][0] == jogador && grade[2][2] == jogador) {
          venceu = true;
        } else if (grade[0][2] == jogador && grade[2][0] == jogador) {
          venceu = true;
        }
      }
    }

    return venceu;
  }
}
