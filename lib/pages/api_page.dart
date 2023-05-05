import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/service.dart';
import '../widgets/service_tile.dart';
import '../controllers/services_controller.dart';

class APIPage extends StatefulWidget {
  APIPage({super.key, required this.title});

  final String title;

  @override
  State<APIPage> createState() => _APIPageState();
}

class _APIPageState extends State<APIPage> {
  final ValueNotifier<int> isSearchBarVisible = ValueNotifier(0);
  final controller = TextEditingController();
  ServicesController servicesController = ServicesController();
  void changeVisibility() {
    isSearchBarVisible.value = (isSearchBarVisible.value + 1) % 2;
  }

  @override
  Widget build(BuildContext context) {
    print("HomePage changed");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: changeVisibility,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Services",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(
                  "/new",
                  arguments: () {
                    setState(() {
                      servicesController = ServicesController();
                    });
                  },
                );
              },
              title: Text(
                "Create New",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: servicesController.get_services(),
        builder: (context, snapshot) {
          print("Building List");
          if (snapshot.hasData) {
            return Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: isSearchBarVisible,
                  builder: (context, value, child) {
                    return AnimatedOpacity(
                      curve: Curves.decelerate,
                      opacity: value == 1 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Visibility(
                        visible: (value == 1),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CupertinoSearchTextField(
                            controller: controller,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      print("Refresh");
                      setState(() {
                        servicesController = ServicesController();
                      });
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // return ServiceTile(
                        //   service: snapshot.data![index],
                        //   deleteCallback: () {
                        //     setState(() {
                        //       servicesController = ServicesController();
                        //     });
                        //   },
                        // );
                        return ExpansionTile(
                          title: Text(snapshot.data![index]["title"] ?? "No Title"),
                          children: [
                            Text(snapshot.data![index]["body"] ?? "No Description"),
                          ],
                        
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: const Text("No internet connection"),
            );
          } else if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
