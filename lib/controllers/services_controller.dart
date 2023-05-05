import '../models/service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = "https://dummyjson.com/posts";

class ServicesController {
  Future<List<Map<String, dynamic>>?>? services;

  ServicesController() {
    services = get_services();
  }

  Future<List<Map<String, dynamic>>> get_services() async {
    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
    });
    print(response.body);
    List<Map<String, dynamic>> services = [];
    if (response.statusCode == 200) {
      List array = jsonDecode(response.body)["posts"];
      for (var element in array) {
        services.add(element);
      }
    }
    return services;
  }

  Future<void> refresh() async {
    services = get_services();
  }

  // Future<List<Service>> filter(String contains) async {
  //   return services!.then((value) {
  //     return value!
  //         .where((element) => element.name.toLowerCase().contains(contains))
  //         .toList();
  //   });
  // }

  Future<bool> create(Map<String, String> data) async {
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> update(Map<String, String> data) async {
    var response = await http.put(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> delete(String id) async {
    var response = await http.delete(Uri.parse(url + id), headers: {
      'Content-Type': 'application/json',
    });
    print(id);
    print(response.body);
    if (response.statusCode == 200) {
      // services = services!.then((value) => value!.where((element) => element.id.toString() != id).toList());
      return true;
    }
    return false;
  }
}
