import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  String stringFromLocalData = '';
  bool isLoading = true;
  List<String> stringList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

//Запис стрінги
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('string', nameController.text);
    nameController.clear();
    getData();
  }

  //Читання стрінги  і ліста
  Future<void> getData() async {
    isLoading = true;
    Future.delayed(
      const Duration(
        seconds: 6,
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      stringFromLocalData = prefs.getString('string') ?? '';
      stringList = prefs.getStringList('list_string') ?? [];
      isLoading = false;
    });
  }

  void addItemToList() {
   setState(() {
     stringList.add(nameController.text);
     nameController.clear();
   });
    saveItemToList();
  }

  // Зберігаєм елемент до списку в локальну базу
  Future<void> saveItemToList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('list_string', stringList);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: addItemToList,
                    child: const Text(
                      'Зберегти',
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: stringList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const  EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Text(stringList[index]),
                          );
                        }),
                  )
                ],
              ),
            ),
    );
  }
}
