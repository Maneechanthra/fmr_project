import 'package:flutter/material.dart';
import 'package:fmr_project/api/getRestaurantSearch_api.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant.dart';
import 'package:fmr_project/detail_restaurant/detail_restaurant_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryPage extends StatefulWidget {
  final userId;
  const SearchHistoryPage(this.userId, {super.key});

  @override
  State<SearchHistoryPage> createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  late Future<List<GetRestaurantsSearchByName>>
      futureGetRestaurantSearchByName; // ประกาศตัวแปรประเภทใหม่
  late TextEditingController _searchController;
  late List<String> _searchHistory;
  late List<GetRestaurantsSearchByName> _searchResult; // แก้ไขตัวแปรประเภทใหม่
  late List<GetRestaurantsSearchByName> allRestaurantsByName;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchResult = [];
    _searchHistory = [];
    futureGetRestaurantSearchByName = fetchRestaurantSearch();
    futureGetRestaurantSearchByName.then((restaurants) {
      allRestaurantsByName = restaurants;
      _loadSearchHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _removeSearchHistory(String queryWithDate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updatedSearchHistory = [..._searchHistory];
    updatedSearchHistory.remove(queryWithDate);
    await prefs.setStringList('search_history', updatedSearchHistory);
    setState(() {
      _searchHistory = updatedSearchHistory;
    });
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? searchHistory = prefs.getStringList('search_history');

    if (searchHistory != null) {
      setState(() {
        _searchHistory = searchHistory;
      });
    }
  }

  void _clearSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() {
      _searchHistory.clear();
    });
  }

  void searchRestaurant(String query) {
    _searchResult.clear();

    for (GetRestaurantsSearchByName restaurant in allRestaurantsByName) {
      if (restaurant.restaurantName.contains(query)) {
        _searchResult.add(restaurant);
      }
    }
    setState(() {});
  }

  Future<void> _saveSearchHistory(String query) async {
    final String now = DateTime.now().toIso8601String();
    final String queryWithDate = '$query';

    setState(() {
      _searchHistory.insert(0, queryWithDate);
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
    _loadSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.15,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              // BoxShadow(
                              //   color: const Color.fromARGB(96, 209, 209, 209),
                              //   blurRadius: 0.8,
                              //   offset: Offset(0, 5),
                              // ),
                            ]),
                        child: Center(child: Icon(Icons.arrow_back_ios)),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(148, 223, 223, 223),
                          boxShadow: [
                            // BoxShadow(
                            //   color: const Color.fromARGB(96, 209, 209, 209),
                            //   blurRadius: 10.0,
                            //   offset: Offset(5, 10),
                            // ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) {},
                                  onSubmitted: (query) async {
                                    searchRestaurant(query);
                                    await _saveSearchHistory(query);
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'ค้นหาร้านอาหาร',
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final query = _searchController.text;
                                  searchRestaurant(query);
                                  await _saveSearchHistory(query);
                                },
                                child: Icon(
                                  Icons.search,
                                  color: Color.fromARGB(255, 107, 107, 107),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     _clearSearchHistory();
                              //   },
                              //   child: Icon(
                              //     Icons.clear,
                              //     color: Color.fromARGB(255, 107, 107, 107),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_searchHistory.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ประวัติการค้นหา',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black45),
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _searchHistory.map((queryWithDate) {
                      // final query = queryWithDate;
                      final query = queryWithDate.split('|').first;
                      return GestureDetector(
                        onTap: () {
                          // _searchController.text = query;
                          // _removeSearchHistory(queryWithDate);
                          _searchController.text = query;
                          _removeSearchHistory(queryWithDate);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    query,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (_searchResult.isNotEmpty) ...[
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _searchResult.length,
                    itemBuilder: (context, index) {
                      final item = _searchResult[index];
                      final String imageUrl =
                          'https://www.smt-online.com/api/public/${item.imagePath}';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailRestaurantScreen(
                                          restaurantId: item.id,
                                          userId: widget.userId,
                                        )));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  // BoxShadow(
                                  //   color: Colors.black38,
                                  //   offset: Offset(0, 5),
                                  //   blurRadius: 10,
                                  // )
                                ]),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl,
                                    width: 120,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.restaurantName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          item.restaurantCategory.join(" / "),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.amber[600],
                                          ),
                                          Row(
                                            children: [
                                              item.averageRating == null
                                                  ? Text(
                                                      "0",
                                                    )
                                                  : Text(
                                                      "${item.averageRating.toString()}",
                                                    ),
                                              Text(
                                                " (${item.reviewCount.toString()} รีวิว)",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        90, 0, 0, 0)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
