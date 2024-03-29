class dateOpening {
  final int id;
  final String day;
  final String timeopen;
  final String timeclose;

  dateOpening({
    required this.id,
    required this.day,
    required this.timeopen,
    required this.timeclose,
  });
}

List<dateOpening> getDateOpening = [
  dateOpening(
    id: 1,
    day: "วันจันทร์",
    timeopen: "09.00",
    timeclose: "17.00",
  ),
  dateOpening(
    id: 1,
    day: "วันอังคาร",
    timeopen: "09.00",
    timeclose: "17.00",
  ),
  dateOpening(
    id: 1,
    day: "วันพุธ",
    timeopen: "09.00",
    timeclose: "17.00",
  ),
  dateOpening(
    id: 1,
    day: "วันพฤหัสบดี",
    timeopen: "09.00",
    timeclose: "17.00",
  ),
  dateOpening(
    id: 1,
    day: "วันศุกร์",
    timeopen: "09.00",
    timeclose: "17.00",
  ),
  dateOpening(
    id: 1,
    day: "วันเสาร์",
    timeopen: "09.00",
    timeclose: "17.00",
  ),
  dateOpening(
    id: 1,
    day: "วันอาทิตย์",
    timeopen: "ปิด",
    timeclose: "ปิด",
  ),
];
