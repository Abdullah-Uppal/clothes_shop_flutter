import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:last_assignment/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../app_state.dart';

class ClothesListPage extends StatefulWidget {
  const ClothesListPage({super.key});

  @override
  State<ClothesListPage> createState() => _ClothesListPageState();
}

class _ClothesListPageState extends State<ClothesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.shoppingBag),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("New", style: Theme.of(context).textTheme.headlineLarge),
            Text("Collection",
                style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 100,
                left: 20,
                right: 20,
              ),
              child: Consumer<AppState>(
                builder: (context, state, child) {
                  final List<Future<String>> firstImages =
                      state.clothes.map((e) async {
                    return await FirebaseStorage.instance
                        .ref(e.images[0])
                        .getDownloadURL();
                  }).toList();
                  return FutureBuilder<List<String>>(
                    future: Future.wait(firstImages),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        snapshot.data!.forEach((element) {
                          print(element);
                        });
                        return MasonryGridView.builder(
                          shrinkWrap: true,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onDoubleTap: () {
                                print("LIKED");
                              },
                              onLongPress: () {
                                showMenu(
                                  context: context,
                                  position:
                                      RelativeRect.fromLTRB(100, 100, 0, 0),
                                  items: [
                                    PopupMenuItem(
                                      child: Text("Delete"),
                                      onTap: () {},
                                    ),
                                    PopupMenuItem(
                                      child: Text("Add to Cart"),
                                    ),
                                  ],
                                );
                              },
                              onTap: () {
                                context.push(
                                  "/detail",
                                  extra: state.clothes[index],
                                );
                              },
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      snapshot.data![index],
                                      loadingBuilder:
                                          (context, child, loadingProgress) =>
                                              loadingProgress == null
                                                  ? child
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          state.deleteCloth(
                                              state.clothes[index].id ?? "");
                                        },
                                      )),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
