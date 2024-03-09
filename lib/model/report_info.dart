class report {
  final int id;
  final String title;
  final String description;
  final int countReport;
  final int restaurantId;

  report(
      {required this.id,
      required this.title,
      required this.description,
      required this.countReport,
      required this.restaurantId});
}

List<report> getReport = [
  report(
    id: 1,
    title: "ภาพไม่เหมาะสม",
    description:
        "ภาพที่นำมาใช้เป็นภาพจากร้านอื่น มีการนำภาพจากร้านบาร์บีคิวมาใช้งานโดยไม่ได้ขออนุญาตก่อน",
    countReport: 1,
    restaurantId: 1,
  ),
  report(
    id: 2,
    title: "ตำแหน่งร้านอาหารไม่ถูกต้อง",
    description: "ตำแหน่งร้านอาหารไม่ถูกต้อง ไปแล้วหลงทาง",
    countReport: 1,
    restaurantId: 2,
  ),
  report(
    id: 3,
    title: "ภาพไม่เหมาะสม",
    description: "ภาพที่นำมาใช้เป็นภาพจากร้านอื่น",
    countReport: 2,
    restaurantId: 1,
  ),
];
