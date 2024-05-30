import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:fmr_project/api/category/category_api.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<CategoryModel>> futureCategory;

  @override
  void initState() {
    futureCategory = fetchCategory();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          EneftyIcons.arrow_circle_left_bold,
          size: 30,
        ),
        title: Text(
          "ประเภทร้านอาหาร",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CategoryModel>>(
          future: futureCategory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text("ไม่มีข้อมูล"),
              );
            } else {
              final category = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount =
                          MediaQuery.of(context).size.width ~/ 110;
                      if (crossAxisCount < 2) {
                        crossAxisCount = 3;
                      }
                      return GridView.builder(
                        itemCount: category.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = category[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => newOfCategory(
                              //       Category_id: item.id,
                              //       Category_title: item.title,
                              //     ),
                              //   ),
                              // );
                              // print(item.id.toString() + " " + item.title);
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 5),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      item.title,
                                      scale: 12,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 14),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.235,
                                  child: Text(
                                    item.title,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }
          }),
    );
  }
}
