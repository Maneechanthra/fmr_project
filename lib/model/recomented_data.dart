class Restaurant_2 {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double rating;
  final String imageUrl;
  final double kilomate;
  final int review;
  final String type_restaurant;

  Restaurant_2(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.rating,
      required this.imageUrl,
      required this.kilomate,
      required this.review,
      required this.type_restaurant});
}

// Sample list of restaurants
List<Restaurant_2> allRestaurants_2 = [
  Restaurant_2(
    id: 1,
    name: "ร้านครัวตามสั่ง",
    latitude: 17.27274239,
    longitude: 104.1265007,
    rating: 4.5,
    imageUrl:
        "https://images.pexels.com/photos/699953/pexels-photo-699953.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    kilomate: 4,
    review: 20,
    type_restaurant: 'อาหารตามสั่ง',
  ),
  Restaurant_2(
    id: 2,
    name: "ร้านบาบีคิวสกลนคร",
    latitude: 17.263816461915756,
    longitude: 104.1287784673422,
    rating: 3.2,
    imageUrl: "https://f.ptcdn.info/492/018/000/1399095907-pantiptalk-o.jpg",
    kilomate: 11,
    review: 39,
    type_restaurant: 'บาบีคิว',
  ),
  Restaurant_2(
    id: 3,
    name: "ร้านหม่าล่าม.เกษตรสกลนคร",
    latitude: 17.27422278532229,
    longitude: 104.13365916486865,
    rating: 4.8,
    imageUrl:
        "https://welovetogo.com/wp-content/uploads/2020/08/%E0%B8%AB%E0%B8%A1%E0%B9%88%E0%B8%B2%E0%B8%A5%E0%B9%88%E0%B8%B28-1068x712.jpg",
    kilomate: 3,
    review: 102,
    type_restaurant: 'อาหารจีน',
  ),
  Restaurant_2(
      id: 4,
      name: "ร้านมีหมูกระทะ",
      latitude: 17.27422278532224,
      longitude: 104.13365916486865,
      rating: 2.9,
      imageUrl: "https://mpics.mgronline.com/pics/Images/566000009640506.JPEG",
      kilomate: 2.9,
      review: 56,
      type_restaurant: "ชาบู/หมูกระทะ"),
];
