class Comments {
  final String name;
  final String title;
  final String dateReview;
  final String content;
  final double rating;
  final List<String> imageUrls;
  final String type_restaurant;
  final int amountReview;

  Comments({
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
    rating: 4.5,
    imageUrls: [
      "https://img.wongnai.com/p/1920x0/2023/11/28/130d0614397b4070bb649e7476de69f0.jpg",
      "https://img.wongnai.com/p/1920x0/2023/06/17/2c0dcb4b0b9c4e6d8d8b9efa25988dde.jpg",
      "https://img.wongnai.com/p/1920x0/2023/06/17/4b38e76fd1e8478497d5808107f38201.jpg",
    ],
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
    imageUrls: [
      "https://img.kapook.com/u/2021/wanwanat/207528-1.jpg",
      "https://www.homenayoo.com/wp-content/uploads/2016/01/9.jpg",
      "https://img-global.cpcdn.com/recipes/48e33e34797f81a9/1200x630cq70/photo.jpg",
    ],
    type_restaurant: 'อาหารตามสั่ง',
    dateReview: '14 ก.พ. 2024',
    title: 'อาหารดี สะอาดมาก ห้องน้ำสวย',
    content:
        'ร้านอาหารสวยมาก น่านั่งทาน มีทั้งแบบกลับบ้านและนั่งทานที่ร้าน พนักงานบริการดีมาก ๆ',
    amountReview: 230,
  ),
  Comments(
    name: "Sumet MANEECHATHRA",
    rating: 4.5,
    imageUrls: [
      "https://www.thestreetratchada.com/upload/contents/1698819486TSR%20-%20Oct%20%202%20(%E0%B9%80%E0%B8%A1%E0%B8%99%E0%B8%B9%E0%B8%AB%E0%B8%A1%E0%B9%88%E0%B8%B2%E0%B8%A5%E0%B9%88%E0%B8%B2)-02.jpg",
      "https://www.wandeehouse.com/static/upload/content/1/57/1.jpg",
      "https://static5-th.orstatic.com/userphoto/Article/0/2Z/000L7I4927F61925530E3Ej.jpg",
    ],
    type_restaurant: 'อาหารจีน ',
    dateReview: '2 มี.ค. 2024',
    title: 'อาหารอร่อยมาก เผ็ดแซ่บที่สุด',
    content:
        'อาหารอร่อยมาก ร้านบริการ เนื้อนำเข้าโดยตรง อาหารออกเร็ว ราคาไม่แรงเกินไป รวมๆ 10/10',
    amountReview: 743,
  ),
];
