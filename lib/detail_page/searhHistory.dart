import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryPage extends StatefulWidget {
  const SearchHistoryPage({super.key});

  @override
  State<SearchHistoryPage> createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  late TextEditingController _searchController;
  late List<String> _searchHistory;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchHistory = [];
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? searchHistory = prefs.getStringList('search_history');
    if (searchHistory != null) {
      final now = DateTime.now();
      final filteredSearchHistory = searchHistory.where((query) {
        final queryDate = DateTime.parse(query.split(' | ')[1]);
        return now.difference(queryDate).inDays <= 30;
      }).toList();
      setState(() {
        _searchHistory = filteredSearchHistory;
      });
    }
  }

  Future<void> _saveSearchHistory(String query) async {
    final String now = DateTime.now().toIso8601String();
    final String queryWithDate = '$query|$now';

    setState(() {
      _searchHistory.insert(0, queryWithDate);
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
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
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(96, 209, 209, 209),
                                blurRadius: 0.8,
                                offset: Offset(0, 5),
                              ),
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
                          color: const Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(96, 209, 209, 209),
                              blurRadius: 10.0,
                              offset: Offset(5, 10),
                            ),
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
                                  onChanged: (value) {
                                    // Handle search
                                  },
                                  onSubmitted: (query) async {
                                    // Handle search submission
                                    await _saveSearchHistory(query);
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'ค้นหาร้านอาหาร',
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.search,
                                color: Color.fromARGB(255, 107, 107, 107),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Display search history here
                if (_searchHistory.isNotEmpty) ...[
                  Text(
                    'ประวัติการค้นหา',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _searchHistory.map((query) {
                      return GestureDetector(
                        onTap: () {
                          // Handle tapping on search history item
                          _searchController.text = query;
                          // Perform search operation
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey)),
                          ),
                          child: Text(
                            query,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    }).toList(),
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
