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

  Restaurant_2({
    required this.id,
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
  });
}

// Sample list of restaurants
List<Restaurant_2> allRestaurants_2 = [
  Restaurant_2(
      id: 1,
      name: "ร้านครัวตามสั่ง",
      latitude: 17.27274239,
      longitude: 104.1265007,
      rating: 4.5,
      imageUrls: [
        "https://img.wongnai.com/p/1920x0/2023/11/28/130d0614397b4070bb649e7476de69f0.jpg",
        "https://img.wongnai.com/p/1920x0/2023/06/17/2c0dcb4b0b9c4e6d8d8b9efa25988dde.jpg",
        "https://img.wongnai.com/p/1920x0/2023/06/17/4b38e76fd1e8478497d5808107f38201.jpg",
      ],
      kilomate: 4,
      review: 20,
      type_restaurant: 'อาหารตามสั่ง',
      status: 1,
      verified: 0,
      views: 23),
  Restaurant_2(
    id: 2,
    name: "ร้านบาบีคิวสกลนคร",
    latitude: 17.263816461915756,
    longitude: 104.1287784673422,
    rating: 3.2,
    imageUrls: [
      "https://img.kapook.com/u/2021/wanwanat/207528-1.jpg",
      "https://www.homenayoo.com/wp-content/uploads/2016/01/9.jpg",
      "https://img-global.cpcdn.com/recipes/48e33e34797f81a9/1200x630cq70/photo.jpg",
    ],
    kilomate: 11,
    review: 39,
    type_restaurant: 'บาบีคิว',
    status: -1,
    verified: 1,
    views: 84,
  ),
  Restaurant_2(
    id: 3,
    name: "ร้านหม่าล่าม.เกษตรสกลนคร",
    latitude: 17.27422278532229,
    longitude: 104.13365916486865,
    rating: 4.8,
    imageUrls: [
      "https://www.thestreetratchada.com/upload/contents/1698819486TSR%20-%20Oct%20%202%20(%E0%B9%80%E0%B8%A1%E0%B8%99%E0%B8%B9%E0%B8%AB%E0%B8%A1%E0%B9%88%E0%B8%B2%E0%B8%A5%E0%B9%88%E0%B8%B2)-02.jpg",
      "https://www.wandeehouse.com/static/upload/content/1/57/1.jpg",
      "https://static5-th.orstatic.com/userphoto/Article/0/2Z/000L7I4927F61925530E3Ej.jpg",
    ],
    kilomate: 3,
    review: 102,
    type_restaurant: 'อาหารจีน',
    status: -1,
    verified: 2,
    views: 103,
  ),
  Restaurant_2(
    id: 4,
    name: "ร้านมีหมูกระทะ",
    latitude: 17.27422278532224,
    longitude: 104.13365916486865,
    rating: 2.9,
    imageUrls: [
      "https://mpics.mgronline.com/pics/Images/566000009640506.JPEG",
      "https://img.wongnai.com/p/1920x0/2023/08/30/0d33e38bd30c40d58bde0890f36b99a5.jpg",
      "https://img.wongnai.com/p/1920x0/2023/08/30/74a27365fdb54b65b5b87df7ec2d1fa2.jpg",
    ],
    kilomate: 2.9,
    review: 56,
    type_restaurant: "ชาบู/หมูกระทะ",
    status: 1,
    verified: 0,
    views: 34,
  ),
];
