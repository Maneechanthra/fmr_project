class Comments {
  final String name;
  final String title;
  final String dateReview;
  final String content;
  final double rating;
  final String imageUrl;
  final String type_restaurant;
  final int amountReview;

  Comments({
    required this.name,
    required this.title,
    required this.dateReview,
    required this.content,
    required this.rating,
    required this.imageUrl,
    required this.type_restaurant,
    required this.amountReview,
  });
}

// Sample list of restaurants
List<Comments> Comment = [
  Comments(
    name: "BossKA",
    rating: 4.5,
    imageUrl:
        "https://images.pexels.com/photos/699953/pexels-photo-699953.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    type_restaurant: 'อาหารตามสั่ง',
    dateReview: '23 ม.ค. 2024',
    title: 'ร้านดีบอกต่อด่วน',
    content:
        'ร้านปิ้งย่างโคขุนในสกลนครมีเยอะมากกก หลายร้านหลายทำเล ร้านนี้ก็เป็นอีกร้านอาหารสกลนครแห่งหนึ่งที่เป็นที่ยอดนิยมของชาวสกลนคร จัดร้านเป็นสวน ๆ ร่มรื่นดีครับ มีทั้งอาหารจานเดียว อ่านต่อได้ที่ https://www.wongnai.com/listings/sakonnakhon-restaurants?ref=ct',
    amountReview: 230,
  ),
  Comments(
    name: "Niceky",
    rating: 4.5,
    imageUrl:
        "https://welovetogo.com/wp-content/uploads/2020/08/%E0%B8%AB%E0%B8%A1%E0%B9%88%E0%B8%B2%E0%B8%A5%E0%B9%88%E0%B8%B28-1068x712.jpg",
    type_restaurant: 'อาหารตามสั่ง',
    dateReview: '14 ก.พ. 2024',
    title: 'อาหารดี สะอาดมาก ห้องน้ำสวย',
    content:
        'ร้านอาหารสวยมาก น่านั่งทาน มีทั้งแบบกลับบ้านและนั่งทานที่ร้าน พนักงานบริการดีมาก ๆ',
    amountReview: 230,
  ),
];
