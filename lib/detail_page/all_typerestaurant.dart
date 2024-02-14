import 'package:flutter/material.dart';

class TypeRestaurantPage extends StatefulWidget {
  const TypeRestaurantPage({super.key});

  @override
  State<TypeRestaurantPage> createState() => _TypeRestaurantPageState();
}

class _TypeRestaurantPageState extends State<TypeRestaurantPage> {
  @override
  Widget build(BuildContext context) {
    List<Map> categories = [
      {"name": "อาหารอีสาน", "isChecked": false},
      {"name": "อาหารจีน", "isChecked": false},
      {"name": "หมูกระทะ", "isChecked": false},
      {"name": "คาเฟ่", "isChecked": false},
      {"name": "อาหารไทย ", "isChecked": false},
      {"name": "ก๋วยเตี๋ยว ", "isChecked": false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ประเภทร้านอาหาร",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Please Choose Your Favorite Category:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Column(
                children: categories.map((favorite) {
              return CheckboxListTile(
                  activeColor: Colors.deepPurpleAccent,
                  checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  value: favorite["isChecked"],
                  title: Text(favorite["name"]),
                  onChanged: (val) {
                    setState(() {
                      favorite["isChecked"] = val;
                    });
                  });
            }).toList()),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Wrap(
              children: categories.map((favorite) {
                if (favorite["isChecked"] == true) {
                  return Card(
                    elevation: 3,
                    color: Colors.deepPurpleAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            favorite["name"],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                favorite["isChecked"] = !favorite["isChecked"];
                              });
                            },
                            child: const Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              }).toList(),
            )
          ]),
        ),
      ),
    );
  }
}
