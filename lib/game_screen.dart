import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer' as developer;
import 'confetti_animation.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Map<String, String>> questions = [
    {
      'question': 'Qual é o animal que mia?',
      'answer': 'Gato',
    },
    {
      'question': 'Qual é o animal que é considerado amigo do homem?',
      'answer': 'Cachorro',
    },
    {
      'question': 'Qual é o único mamífero capaz de voar?',
      'answer': 'morcego',
    },
    {
      'question': 'O que é um ano bissexto?',
      'answer': 'um ano com 366 dias',
    },
    {
      'question': 'Quanro é 2x3?',
      'answer': '6',
    },
    {
      'question': 'Quanto é a raiz quadrada de 16',
      'answer': '4',
    },
    {
      'question': 'Quem é o protagonista de One Piece?',
      'answer': 'Luffy',
    },
    {
      'question': 'Qual o nome do bando dos piratas liderado por Luffy?',
      'answer': 'chapéu de palha',
    },
    {
      'question': 'O que são Akuma no Mi?',
      'answer':'Frustas místicas que concedem habilidades especiais a quem as come',
    },
    {
      'question': 'Quais saõ os três tipos de Akuma no Mi? ',
      'answer': 'paramecia, logia e zoan',
    },
    {
      'question': 'Quais são os três tipos de Haki?',
      'answer': 'haki de observação, haki de armamento e haki o rei',
    },
    {
      'question': 'Qual a comida favorita de Luffy?',
      'answer': 'carne',
    },
    {
      'question': 'Qual o sonho de Zoro?',
      'answer': 'se tornar o espadachim mais forte do mundo',
    },
    {
      'question': 'Qual é o maior rio do Brasil?',
      'answer': 'Amazonas',
    },
    {
      'question': 'Qual é a moeda oficial do Brasil?',
      'answer': 'real (BRL)',
    },
    {
      'question': 'Qual é o animal mais rápido do mundo?',
      'answer': 'guepardo',
    },
    {
      'question': 'Quantos dentes tem um tubarão?',
      'answer': 'de 30 a 300',
    },
    {
      'question': 'Qual é a capital do Brasil?',
      'answer': 'Brasília',
    },
    {
      'question': 'Quem foi o primeiro presidente do Brasil?',
      'answer': 'Marechal Deodoro da Fonseca',
    },
    {
      'question': 'Em que ano o Brasil se tornou independente?',
      'answer': '1822',
    },
  ];

  int score = 0;
  int currentQuestionIndex = 0;
  final TextEditingController answerController = TextEditingController();
  bool isCorrect = false;
  bool showFeedback = false;
  bool showConfetti = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void checkAnswer() {
    if (answerController.text.trim().toLowerCase() ==
        questions[currentQuestionIndex]['answer']!.toLowerCase()) {
      setState(() {
        score += 3;
        isCorrect = true;
        showFeedback = true;
        showConfetti = true;
        _audioPlayer.play(DeviceFileSource('som/certo.mp3')).then((_) {
          developer.log('Correct sound played successfully');
        }).catchError((error) {
          developer.log('Error playing correct sound: $error');
        });
      });

      _animationController.forward();
    } else {
      setState(() {
        score -= 2;
        isCorrect = false;
        showFeedback = true;
      });
      _audioPlayer.play(DeviceFileSource('som/erro.mp3')).then((_) {
        developer.log('Error sound played successfully');
      }).catchError((error) {
        developer.log('Error playing error sound: $error');
      });
    }

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showFeedback = false;
        showConfetti = false;
      });
      _animationController.reset();
    });

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answerController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Resultado'),
            content: Text('Sua pontuação final é: $score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    score = 0;
                    currentQuestionIndex = 0;
                  });
                },
                child: const Text('Reiniciar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo de Perguntas'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  questions[currentQuestionIndex]['question']!,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    hintText: 'Digite sua resposta...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    checkAnswer();
                  },
                  autofocus: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    checkAnswer();
                  },
                  child: const Text(
                    'Enviar Resposta',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pontuação: $score',
                  style: TextStyle(
                    color: score > 0
                        ? Colors.green
                        : (score < 0 ? Colors.red : Colors.black),
                  ),
                ),
                if (showFeedback) ...[
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      isCorrect ? 'Você acertou!' : 'Você errou!',
                      style: TextStyle(
                          fontSize: 24,
                          color: isCorrect ? Colors.green : Colors.red),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showConfetti) ...[
            const ConfettiAnimation(),
          ],
        ],
      ),
    );
  }
}
