// import 'package:flutter/material.dart';
// import 'package:fmr_project/add/addRestuarant.dart';

// class TypeRestaurantPage extends StatefulWidget {
//   const TypeRestaurantPage({
//     Key? key,
//     required this.selectedCategories,
//   }) : super(key: key);

//   final List<Map<String, dynamic>> selectedCategories;

//   @override
//   State<TypeRestaurantPage> createState() => _TypeRestaurantPageState();
// }

// List<Map<String, dynamic>> categories = [
//   {"name": "อาหารอีสาน", "isChecked": false},
//   {"name": "อาหารจีน", "isChecked": false},
//   {"name": "หมูกระทะ", "isChecked": false},
//   {"name": "คาเฟ่", "isChecked": false},
//   {"name": "อาหารไทย ", "isChecked": false},
//   {"name": "ก๋วยเตี๋ยว ", "isChecked": false},
// ];

// List<Map<String, dynamic>> selectedCategories = [];

// class _TypeRestaurantPageState extends State<TypeRestaurantPage> {
//   List<Map<String, dynamic>> selectedCategories = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "ประเภทร้านอาหาร",
//           style: TextStyle(
//             fontSize: 18,
//           ),
//         ),
//         // centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 children: List.generate(categories.length, (index) {
//                   return CheckboxListTile(
//                     activeColor: Color.fromARGB(255, 0, 161, 94),
//                     checkboxShape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                     value: categories[index]["isChecked"],
//                     title: Text(categories[index]["name"]),
//                     onChanged: (val) {
//                       setState(() {
//                         categories[index]["isChecked"] = val;
//                         if (val == true) {
//                           selectedCategories.add(categories[index]);
//                         } else {
//                           selectedCategories.remove(categories[index]);
//                         }
//                       });
//                     },
//                   );
//                 }),
//               ),
//               const SizedBox(height: 10),
//               const Divider(),
//               const SizedBox(height: 10),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: selectedCategories.length,
//                 itemBuilder: (context, index) {
//                   final category = selectedCategories[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 3.0),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.5,
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 0, 161, 94),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               category["name"],
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   categories[categories.indexWhere((element) =>
//                                           element["name"] == category["name"])]
//                                       ["isChecked"] = false;
//                                   selectedCategories.remove(category);
//                                 });
//                               },
//                               child: const Icon(
//                                 Icons.delete_forever_rounded,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       persistentFooterButtons: [
//         Container(
//           height: 80,
//           width: double.infinity,
//           child: ButtonBar(
//             alignment: MainAxisAlignment.center,
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AddResPage(
//                         selectedCategories: selectedCategories,
//                         userId: null,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   height: 100,
//                   width: 330,
//                   margin: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.blue,
//                   ),
//                   child: Center(
//                     child: Text(
//                       "บันทึกข้อมูล",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
