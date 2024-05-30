import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/api/category/category_api.dart';
import 'package:google_fonts/google_fonts.dart';

class TypeCategoryScreen extends StatefulWidget {
  const TypeCategoryScreen({Key? key}) : super(key: key);

  @override
  State<TypeCategoryScreen> createState() => _TypeCategoryScreenState();
}

class _TypeCategoryScreenState extends State<TypeCategoryScreen> {
  List<String> selectedTags = [];

  late Future<List<CategoryModel>> futureCategories;

  @override
  void initState() {
    futureCategories = fetchCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ประเภทร้านอาหาร",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final categories = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    ChipsChoice<String>.multiple(
                      value: selectedTags,
                      onChanged: (val) => setState(() => selectedTags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: categories
                            .map((category) => category.title)
                            .toList(),
                        value: (i, v) => v,
                        label: (i, v) => v,
                      ),
                      wrapped: true,
                      choiceCheckmark: true,
                      choiceStyle: C2ChipStyle(
                        backgroundColor: Color.fromARGB(31, 173, 173, 173),
                        borderRadius: BorderRadius.circular(5),
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        foregroundStyle: GoogleFonts.prompt(),
                        checkmarkColor: Color.fromARGB(255, 0, 180, 9),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        List<Map<String, dynamic>> selectedCategories =
                            selectedTags.map((tag) {
                          var category = categories
                              .firstWhere((element) => element.title == tag);
                          return {
                            "id": category.id,
                            "name": tag,
                          };
                        }).toList();
                        Navigator.pop(context, selectedCategories);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "บันทึกข้อมูล",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
