import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:work_tracker/app/constants/constants.dart';
import 'package:work_tracker/app/screens/home_screen/add_todo.dart';
import 'package:work_tracker/app/utils/widgets/my_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<QuerySnapshot<Map<String, dynamic>>?> fatchData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Get the user's document from 'User Info' collection
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('User Info')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? userData = snapshot.data();
      String username = userData!['name'];
      Logger().i(username);

      // Get the user's collection using their username
      QuerySnapshot<Map<String, dynamic>> collectionSnapshot =
          await FirebaseFirestore.instance.collection(username).get();

      return collectionSnapshot;
    } else {
      Logger().i("Not fatched");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: const MyAppBar(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddTodo()));
            },
            label: const Text("Create Todo"),
            backgroundColor: scaffoldBackgroundColor,
          ),
          body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>?>(
              future: fatchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>> collectionSnapshot =
                        snapshot.data!;
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        documents = collectionSnapshot.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic>? documentData =
                            documents[index].data();
                        String title = documentData['title'];
                        String description = documentData['description'];

                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              text: 'Title: ',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.grey.shade200,
                            child: Text(description),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  updateTask(title, description);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                ),
                                onPressed: () async {
                                  await deleteTask(documents[index].id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                }
              }),
        ),
      ),
    );
  }

  void updateTask(String currentTitle, String currentDescription) {
    showDialog(
      context: context,
      builder: (context) {
        String newTitle = currentTitle;
        String newDescription = currentDescription;

        return AlertDialog(
          title: const Text('Update Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  newTitle = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  newDescription = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                String userId = FirebaseAuth.instance.currentUser!.uid;

                // Get the user's document from 'User Info' collection
                DocumentSnapshot<Map<String, dynamic>> snapshot =
                    await FirebaseFirestore.instance
                        .collection('User Info')
                        .doc(userId)
                        .get();

                if (snapshot.exists) {
                  Map<String, dynamic>? userData = snapshot.data();
                  String username = userData!['name'];

                  // Update the task document in the user's collection
                  await FirebaseFirestore.instance
                      .collection(username)
                      .doc(userId)
                      .update({
                    'title': newTitle,
                    'description': newDescription,
                  });
                } else {
                  Logger().i("Error!");
                }
                setState(() {
                  fatchData();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteTask(String taskId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Get the user's document from 'User Info' collection
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('User Info')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? userData = snapshot.data();
      String username = userData!['name'];

      // Delete the task document from the user's collection
      await FirebaseFirestore.instance
          .collection(username)
          .doc(taskId)
          .delete();
    } else {
      Logger().i("Error!");
    }
    setState(() {
      fatchData();
    });
  }
}
