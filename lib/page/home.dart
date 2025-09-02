import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detailpage.dart';
import 'package:myapp/page/team_list_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.to(() => const TeamListPage()),
              child: const Text('ไปยังหน้ารายการทีม'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-to-detail',
        onPressed: () => Get.to(() => const DetailPage(title: 'Detail Page')),
        tooltip: 'Go to Detail',
        child: Image.asset(
          'assets/images/Logo.jpeg',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
