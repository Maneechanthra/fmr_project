class Restaurant_2 {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String> imageUrls;
  final int views;
  final double kilomate;
  final int review;
  final String type_restaurant;
  final int status;
  final int verified;
  final int favorites;
  final String address;
  final String telephone_1;
  final String telephone_2;

  Restaurant_2(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.rating,
      required this.imageUrls,
      required this.kilomate,
      required this.review,
      required this.type_restaurant,
      required this.status,
      required this.verified,
      required this.views,
      required this.favorites,
      required this.address,
      required this.telephone_1,
      required this.telephone_2});
}

List<Restaurant_2> allRestaurants_2 = [
  Restaurant_2(
    id: 1,
    name: "ร้านครัวตามสั่ง",
    latitude: 17.27274239,
    longitude: 104.1265007,
    rating: 4.5,
    imageUrls: [
      "assets/img/foods/01.jpg",
      "assets/img/foods/02.jpg",
      "assets/img/foods/03.jpg",
    ],
    kilomate: 4,
    review: 20,
    type_restaurant: 'อาหารตามสั่ง',
    status: 1,
    verified: 2,
    views: 23,
    favorites: 10,
    address: '460 หมู่1 ตำบล เชียงเครือ อำเภอเมืองสกลนคร สกลนคร 47000',
    telephone_1: '0626649261',
    telephone_2: '',
  ),
  Restaurant_2(
    id: 2,
    name: "ร้านบาบีคิวสกลนคร",
    latitude: 17.263816461915756,
    longitude: 104.1287784673422,
    rating: 3.2,
    imageUrls: [
      "assets/img/foods/04.jpg",
      "assets/img/foods/05.jpg",
      "assets/img/foods/06.jpg",
    ],
    kilomate: 11,
    review: 39,
    type_restaurant: 'บาบีคิว',
    status: 1,
    verified: 1,
    views: 84,
    favorites: 43,
    address:
        '747H+CPR Unnamed Road ตำบล เชียงเครือ อำเภอเมืองสกลนคร สกลนคร 47000',
    telephone_1: '0970945972',
    telephone_2: '0630038428',
  ),
  Restaurant_2(
    id: 3,
    name: "ร้านหม่าล่าม.เกษตรสกลนคร",
    latitude: 17.27422278532229,
    longitude: 104.13365916486865,
    rating: 4.8,
    imageUrls: [
      "assets/img/foods/07.jpg",
      "assets/img/foods/08.jpg",
      "assets/img/foods/09.jpg",
    ],
    kilomate: 3,
    review: 102,
    type_restaurant: 'อาหารจีน',
    status: 1,
    verified: 2,
    views: 103,
    favorites: 54,
    address: '74CG+HH ตำบล เชียงเครือ อำเภอเมืองสกลนคร สกลนคร',
    telephone_1: '0852422165',
    telephone_2: '',
  ),
  Restaurant_2(
    id: 4,
    name: "ร้านมีหมูกระทะ",
    latitude: 17.28065284996071,
    longitude: 104.12346196633989,
    rating: 2.9,
    imageUrls: [
      "assets/img/foods/10.jpg",
      "assets/img/foods/11.jpg",
      "assets/img/foods/12.jpg",
    ],
    kilomate: 2.9,
    review: 56,
    type_restaurant: "ชาบู/หมูกระทะ",
    status: 1,
    verified: 0,
    views: 34,
    favorites: 432,
    address:
        '747H+CPR Unnamed Road ตำบล เชียงเครือ อำเภอเมืองสกลนคร สกลนคร 47000',
    telephone_1: '0862240280',
    telephone_2: '',
  ),
  Restaurant_2(
    id: 5,
    name: "ครัวแฝด เอ-โอ",
    latitude: 17.2695715354762,
    longitude: 104.126597300079,
    rating: 4.3,
    imageUrls: [
      "assets/img/foods/22.jpg",
      "assets/img/foods/23.jpg",
      "assets/img/foods/24.jpg",
    ],
    kilomate: 2.9,
    review: 56,
    type_restaurant: "อาหารตามสั่ง",
    status: -1,
    verified: 0,
    views: 53,
    favorites: 32,
    address: '74FG+HQ4 ตำบล เชียงเครือ อำเภอเมืองสกลนคร สกลนคร 47000',
    telephone_1: '0927796696',
    telephone_2: '',
  ),
];
