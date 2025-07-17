import 'package:flutter/material.dart';

class DuoRecapScreen extends StatelessWidget {
  final String player1;
  final String player2;
  final int score1;
  final int score2;

  const DuoRecapScreen({
    required this.player1,
    required this.player2,
    required this.score1,
    required this.score2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String winner;
    if (score1 > score2) {
      winner = '$player1 gagne !';
    } else if (score2 > score1) {
      winner = '$player2 gagne !';
    } else {
      winner = 'Égalité parfaite !';
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0075BE),
        title: Text('Fin de la partie', style: TextStyle(color: Color(0xFFFFCC00))),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tableau des scores', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Table(
                border: TableBorder.all(color: Colors.grey),
                children: [
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('Joueur', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8), child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold))),
                  ]),
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8), child: Text(player1)),
                    Padding(padding: EdgeInsets.all(8), child: Text('$score1 pts')),
                  ]),
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8), child: Text(player2)),
                    Padding(padding: EdgeInsets.all(8), child: Text('$score2 pts')),
                  ]),
                ],
              ),
              SizedBox(height: 30),
              Text(winner, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0075BE))),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('RETOUR À L’ACCUEIL'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0075BE),
                  foregroundColor: Color(0xFFFFCC00),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 