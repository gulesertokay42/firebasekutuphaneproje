import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Güleser Tokay Kütüphane',
      color: Color.fromARGB(253, 255, 255, 255),
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 231, 225, 241)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Güleser Tokay Kütüphane Yönetimi'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 86, 232),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 20.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BookList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SecondPage()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Kitaplar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Satın Al',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        selectedItemColor: Colors.blue,
        onTap: (int index) {},
      ),
    );
  }
}

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('kutuphane').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final books = snapshot.data!.docs;
        final visibleBooks = books.where((book) {
          final bookData = book.data() as Map<String, dynamic>;
          final bool shouldShow = bookData['kutuphaneyeEklenmis'] ?? false;
          return shouldShow;
        }).toList();

        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  'Kitap Adı: ${book['kitapadi']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Yazar: ${book['yazarlar']}, Sayfa Sayısı: ${book['sayfaSayisi']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondPage(
                              book: book,
                              onUpdate: () {
                                print(
                                    'Update button pressed for ${book['kitapadi']}');
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('DİKKAT!'),
                              content: const Text(
                                  'Bu Kaydı Silmeyi Onaylıyor musunuz?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('kutuphane')
                                        .doc(books[index].id)
                                        .delete();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SecondPage extends StatefulWidget {
  final Map<String, dynamic>? book;
  final VoidCallback? onUpdate;

  const SecondPage({Key? key, this.book, this.onUpdate}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final kitapAdiController = TextEditingController();
  final yayineviController = TextEditingController();
  final yazarlarController = TextEditingController();
  final kategoriController = TextEditingController();
  final sayfaSayisiController = TextEditingController();
  final basimYiliController = TextEditingController();
  bool publishToLibrary = false;

  String? selectedCategory;
  List<String> categories = [
    'Roman',
    'Tarih',
    'Edebiyat',
    'Şiir',
    'Ansiklopedi',
    'Hikaye',
    'Masal'
  ];

  late DocumentReference<Map<String, dynamic>> _documentReference;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      publishToLibrary = widget.book!['kutuphaneyeEklenmis'] ?? false;
    }
    sayfaSayisiController.addListener(() {});
    basimYiliController.addListener(() {});
  }

  void populateControllers() {
    kitapAdiController.text = widget.book!['kitapadi'] ?? '';
    yayineviController.text = widget.book!['yayinevi'] ?? '';
    yazarlarController.text = widget.book!['yazarlar'] ?? '';
    sayfaSayisiController.text = widget.book!['sayfaSayisi'] ?? '';
    basimYiliController.text = widget.book!['basimYili'] ?? '';

    publishToLibrary = widget.book!['kutuphaneyeEklenmis'] ?? false;
  }

  Future<void> _createBook() async {
    try {
      final kitapadi = kitapAdiController.text;
      final yayinevi = yayineviController.text;
      final yazarlar = yazarlarController.text;
      final sayfaSayisi = sayfaSayisiController.text;
      final basimYili = basimYiliController.text;

      if (kitapadi.isEmpty ||
          yayinevi.isEmpty ||
          yazarlar.isEmpty ||
          selectedCategory == null ||
          !isNumeric(sayfaSayisi) ||
          !isNumeric(basimYili)) {
        return;
      }
      final bookData = {
        'kitapadi': kitapadi,
        'yayinevi': yayinevi,
        'yazarlar': yazarlar,
        'kategori': selectedCategory,
        'sayfaSayisi': sayfaSayisi,
        'basimYili': basimYili,
        'kutuphaneyeEklenmis': publishToLibrary,
      };

      if (widget.book != null) {
        await FirebaseFirestore.instance
            .collection('kutuphane')
            .doc(widget.book!['id'])
            .update(bookData);
      } else {
        await FirebaseFirestore.instance.collection('kutuphane').add(bookData);
      }

      if (widget.onUpdate != null) {
        widget.onUpdate!();
      }

      Navigator.pop(context);
    } catch (e) {
      print('Firestore Hatası: $e');
    }
  }

  bool isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: const Text('Kitap Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: kitapAdiController,
                decoration: const InputDecoration(
                  labelText: 'Kitap adı',
                ),
              ),
              TextField(
                controller: yayineviController,
                decoration: const InputDecoration(
                  labelText: 'Yayınevi',
                ),
              ),
              TextField(
                controller: yazarlarController,
                decoration: const InputDecoration(
                  labelText: 'Yazarlar',
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (value) {
                  if (widget.book == null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                ),
              ),
              TextField(
                controller: sayfaSayisiController,
                decoration: const InputDecoration(
                  labelText: 'Sayfa Sayısı',
                ),
              ),
              TextField(
                controller: basimYiliController,
                decoration: const InputDecoration(
                  labelText: 'Basım Yılı',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(' Listede Yayınlanacak mı?'),
                  ),
                  Checkbox(
                    value: publishToLibrary,
                    onChanged: (value) {
                      setState(() {
                        publishToLibrary = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  onPressed: () {
                    _createBook();
                    Navigator.pop(context);
                  },
                  child: const Text("Kaydet"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
