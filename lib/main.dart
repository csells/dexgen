import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* dexgen rules
Name:
Age:
Class: Fighter, Paladin, Ranger, Mage, Cleric, Druid, Thief, Monk, Newfangler, Archer, Monk, Bard, Barbarian, Aes Sedai, Warder

Roll 4d6 and use top 3 for the following.
If you roll a natural 18 [in three out of four dice], roll a secondary % score.
You can move points around 2 for 1 in the top five categories.
STR
INT
WIS
DEX
CON
CHA
COM  

Secondary Skill: %
Ethnic Background/Race: Human, Dwarf, Elf, Gnome, Half-orc, Dwome, Gelf, Half-dragon
Country of Birth: %
Inherited Social Level: %
Father's Skill: %
Gold on Hand: %/2
Mystery #1: %
Mystery #2: %
Mystery #3: %
Mystery #4: %
Alignment: Lawful Good, Chaotic Good, Neutral Good, True Neutral, Lawful Evil, Chaotic Evil, Neutral Evil
*/

void main() => runApp(const App());

class Character extends ChangeNotifier {
  final _rnd = Random();

  var _str = 0;
  var _int = 0;
  var _wis = 0;
  var _dex = 0;
  var _con = 0;
  var _cha = 0;
  var _com = 0;

  Character() {
    regen();
  }

  void regen() {
    _str = _ability();
    _int = _ability();
    _wis = _ability();
    _dex = _ability();
    _con = _ability();
    _cha = _ability();
    _com = _ability();
  }

  int get strength => _str;
  set str(int val) {
    _str = val;
    notifyListeners();
  }

  int get intelligence => _int;
  set intelligence(int val) {
    _int = val;
    notifyListeners();
  }

  int get wisdom => _wis;
  set wisdom(int val) {
    _wis = val;
    notifyListeners();
  }

  int get dexterity => _dex;
  set dexterity(int val) {
    _dex = val;
    notifyListeners();
  }

  int get constitution => _con;
  set constitution(int val) {
    _con = val;
    notifyListeners();
  }

  int get charisma => _cha;
  set charisma(int val) {
    _cha = val;
    notifyListeners();
  }

  int get comeliness => _com;
  set comeliness(int val) {
    _com = val;
    notifyListeners();
  }

  @override
  String toString() => '''
STR: $_str
INT: $_int
WIS: $_wis
DEX: $_dex
CON: $_con
CHA: $_cha
COM: $_com
''';

  int _ability() =>
      List<int>.generate(4, (_) => _rnd.nextInt(6) + 1).sorted().skip(1).sum();
}

class ChangeNotifierBuilder<T extends ChangeNotifier> extends AnimatedBuilder {
  ChangeNotifierBuilder({
    Key? key,
    required T notifier,
    required Widget Function(BuildContext context, T listenable, Widget? child)
        builder,
    Widget? child,
  }) : super(
            key: key,
            animation: notifier,
            child: child,
            builder: (context, child) => builder(context, notifier, child));
}

class App extends StatelessWidget {
  static const title = 'dexgen';
  static final character = Character();

  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: title,
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(App.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(context),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshPressed,
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ChangeNotifierBuilder<Character>(
              notifier: App.character,
              builder: (context, character, child) => Column(
                children: [
                  LabeledText(
                    character.strength.toString(),
                    label: 'Strength',
                  ),
                  LabeledText(
                    character.intelligence.toString(),
                    label: 'Intellgence',
                  ),
                  LabeledText(
                    character.wisdom.toString(),
                    label: 'Wisdom',
                  ),
                  LabeledText(
                    character.dexterity.toString(),
                    label: 'Dexterity',
                  ),
                  LabeledText(
                    character.constitution.toString(),
                    label: 'Constitution',
                  ),
                  LabeledText(
                    character.charisma.toString(),
                    label: 'Charisma',
                  ),
                  LabeledText(
                    character.comeliness.toString(),
                    label: 'Comeliness',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _refreshPressed() => App.character.regen();
  void _copyToClipboard(BuildContext context) =>
      Clipboard.setData(ClipboardData(text: App.character.toString()))
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Character stats copied to clipboard')),
        );
      });
}

class LabeledText extends StatefulWidget {
  final String label;
  final String text;

  const LabeledText(this.text, {super.key, required this.label});

  @override
  State<LabeledText> createState() => _LabeledTextState();
}

class _LabeledTextState extends State<LabeledText> {
  late final TextEditingController _text;

  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: _text,
        readOnly: true,
        decoration: InputDecoration(
          label: Text(widget.label),
          border: InputBorder.none,
        ),
      );
}
