import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AllCourse extends StatefulWidget {
  const AllCourse({super.key});

  @override
  State<AllCourse> createState() => _AllCourseState();
}

class _AllCourseState extends State<AllCourse> {
  List<dynamic> courses = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
  final dio = Dio();
  const defaultFilters = {
    "page": 1,
    "size": 10,
    "search": null,
    "category": null,
    "language": null,
    "rating": null,
    "minPrice": 0,
    "maxPrice": 999999,
    "sortPrice": null,
    "sortDate": null,
  };

try {
  final response = await dio.post(
    "http://localhost:7501/api/courses",
    data: defaultFilters,
    options: Options(headers: {"Content-Type": "application/json"}),
  );
  print("✅ Status: tttt");
  print("✅ Response: ${response.data}");

  setState(() {
    courses = response.data['data'] ?? [];
    isLoading = false;
  });
} catch (e) {
    if (e is DioException) {
    print("❌ Dio Error: ${e.message}");
    print("❌ Response: ${e.response?.data}");
    print("❌ Status Code: ${e.response?.statusCode}");
  } else {
    print("❌ Unknown Error: $e");
  }
}

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Courses")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : courses.isEmpty
                  ? const Center(child: Text("ไม่มีข้อมูล"))
                  : ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return ListTile(
                          title: Text(course['title'] ?? 'No Title',style: const TextStyle(color: Colors.white),),
                          subtitle: Text(course['author'] ?? 'Unknown Author',style: const TextStyle(color: Colors.white)),
                        );
                      },
                    ),
    );
  }
}
