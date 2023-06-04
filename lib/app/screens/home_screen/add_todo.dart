import 'package:flutter/material.dart';
import 'package:work_tracker/app/Models/item_model.dart';
import 'package:work_tracker/app/constants/constants.dart';
import 'package:work_tracker/app/core/Repositories/item_repository.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        title: const Text("Add Your Task"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          TextField(
            decoration: const InputDecoration(hintText: "Title"),
            maxLines: 1,
            controller: titleController,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            controller: descriptionController,
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                if(titleController.text.isEmpty || descriptionController.text.isEmpty){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error!'),
                          content: const Text(
                              'Please Enter Title & Description!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                }
                else{
                ItemRepository itemRepository = ItemRepository(context: context);
                itemRepository.submitData(titleController.text, descriptionController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: scaffoldBackgroundColor,
              ),
              child: const Text("Add Item"))
        ],
      ),
    );
  }
}
