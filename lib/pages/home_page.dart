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
    prefs.setString('string',
        nameController.text); // Записуєм дані у форматі ключ - значення. Ключ придумовуємо самі.
    nameController.clear();
    getData();
  }

  //Читання стрінги і ліста
  Future<void> getData() async {
    isLoading = true;
    Future.delayed(
      const Duration(seconds: 2),
    );
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      stringFromLocalData = prefs.getString('string') ??
          ''; // Читаєм стрінгу по ключу і відразу записуєм значення з локальної бази в нашу зміну
      stringList = prefs.getStringList('list_string') ??
          []; // Читаєм список по ключу і відразу записуєм значення з локальної бази в нашу зміну
      isLoading = false;
    });
  }

  // Додаєм елемент до списку
  void addItemToList() {
    setState(() {
      stringList.add(nameController.text); // Додаєм елемнт в зміну - список stringList
      nameController.clear();
    });
    saveList(); // Викликаємо метод
  }

  // Зберігаєм список в локальну базу
  Future<void> saveList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('list_string', stringList); // Записуєм список в локальну базу
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
                  const Text('Test'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: addItemToList,
                    child: const Text(
                      'Зберегти',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: stringList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
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
