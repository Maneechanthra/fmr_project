class Comments {
  final int id;
  final String name;
  final String title;
  final String dateReview;
  final String content;
  final double rating;
  final List<String> imageUrls;
  final String type_restaurant;
  final int amountReview;

  Comments({
    required this.id,
    required this.name,
    required this.title,
    required this.dateReview,
    required this.content,
    required this.rating,
    required this.imageUrls,
    required this.type_restaurant,
    required this.amountReview,
  });
}

// Sample list of restaurants
List<Comments> Comment = [
  Comments(
    name: "BossKA",
    rating: 4,
    imageUrls: [
      "assets/img/foods/13.jpg",
      "assets/img/restaurant/01.jpg",
      "assets/img/foods/15.jpg",
    ],
    type_restaurant: 'อาหารตามสั่ง',
    dateReview: '23 ม.ค. 2024',
    title: 'ร้านดีบอกต่อด่วน',
    content:
        'ร้านปิ้งย่างโคขุนในสกลนครมีเยอะมากกก หลายร้านหลายทำเล ร้านนี้ก็เป็นอีกร้านอาหารสกลนครแห่งหนึ่งที่เป็นที่ยอดนิยมของชาวสกลนคร จัดร้านเป็นสวน ๆ ร่มรื่นดีครับ มีทั้งอาหารจานเดียว อ่านต่อได้ที่ https://www.wongnai.com/listings/sakonnakhon-restaurants?ref=ct',
    amountReview: 230,
    id: 1,
  ),
  Comments(
    name: "Niceky",
    rating: 4,
    imageUrls: [
      "assets/img/restaurant/02.jpg",
      "assets/img/restaurant/03.jpg",
      "assets/img/foods/18.jpg",
    ],
    type_restaurant: 'อาหารตามสั่ง',
    dateReview: '14 ก.พ. 2024',
    title: 'อาหารดี สะอาดมาก ห้องน้ำสวย',
    content:
        'ร้านอาหารสวยมาก น่านั่งทาน มีทั้งแบบกลับบ้านและนั่งทานที่ร้าน พนักงานบริการดีมาก ๆ',
    amountReview: 230,
    id: 2,
  ),
  Comments(
    name: "Sumet MANEECHATHRA",
    rating: 4,
    imageUrls: [
      "assets/img/foods/19.jpg",
      "assets/img/foods/20.jpg",
      "assets/img/foods/21.jpg",
    ],
    type_restaurant: 'อาหารจีน ',
    dateReview: '2 มี.ค. 2024',
    title: 'อาหารอร่อยมาก เผ็ดแซ่บที่สุด',
    content:
        'อาหารอร่อยมาก ร้านบริการ เนื้อนำเข้าโดยตรง อาหารออกเร็ว ราคาไม่แรงเกินไป รวมๆ 10/10',
    amountReview: 743,
    id: 3,
  ),
];
