import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des candidats',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
      ),
      home: CandidateListPage(),
    );
  }
}

class CandidateListPage extends StatefulWidget {
  @override
  _CandidateListPageState createState() => _CandidateListPageState();
}

class _CandidateListPageState extends State<CandidateListPage> {
  List<Candidate> candidates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des candidats'),
      ),
      body: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: candidates[index].photo != null
                  ? AssetImage(candidates[index].photo!)
                  : AssetImage('assets/default_avatar.png'),
            ),
            title: Text(
              candidates[index].name,
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              candidates[index].description,
              style: TextStyle(fontSize: 14),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CandidateDetailsPage(
                    candidate: candidates[index],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CandidateFormPage()),
          ).then((value) {
            if (value != null && value is Candidate) {
              setState(() {
                candidates.add(value);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CandidateFormPage extends StatefulWidget {
  @override
  _CandidateFormPageState createState() => _CandidateFormPageState();
}

class _CandidateFormPageState extends State<CandidateFormPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController partyController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire du candidat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Ajouter la logique pour prendre une photo ici
              },
              child: Text('Prendre une photo'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: surnameController,
              decoration: InputDecoration(
                labelText: 'Prénom',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: partyController,
              decoration: InputDecoration(
                labelText: 'Parti politique',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Date de naissance'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    surnameController.text.isEmpty ||
                    partyController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    _selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez remplir tous les champs'),
                    ),
                  );
                } else {
                  Candidate candidate = Candidate(
                    name: nameController.text + ' ' + surnameController.text,
                    photo: null, // Remplacer par le chemin de la photo
                    birthDate: _selectedDate!,
                    description: descriptionController.text,
                    party: partyController.text,
                  );
                  Navigator.pop(context, candidate);
                }
              },
              child: Text('Valider les informations'),
            ),
          ],
        ),
      ),
    );
  }
}

class CandidateDetailsPage extends StatelessWidget {
  final Candidate candidate;

  CandidateDetailsPage({required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du candidat'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nom du parti politique: ${candidate.party}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Nom: ${candidate.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              backgroundImage: candidate.photo != null
                  ? AssetImage(candidate.photo!)
                  : AssetImage('assets/default_avatar.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Description: ${candidate.description}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class Candidate {
  final String name;
  final String? photo;
  final DateTime birthDate;
  final String description;
  final String party;

  Candidate({
  required this.name,
  this.photo,
  required this.birthDate,
  required this.description,
  required this.party,
  });
}
