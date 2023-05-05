import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:last_assignment/widgets/custom_button.dart';
import '../models/cloth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ClothDetailPage extends StatefulWidget {
  final Cloth? cloth;
  const ClothDetailPage({super.key, required this.cloth});

  @override
  State<ClothDetailPage> createState() => _ClothDetailPageState();
}

class _ClothDetailPageState extends State<ClothDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: PageView.builder(
                    itemCount: widget.cloth!.images.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CachedNetworkImage(
                                useOldImageOnUrlChange: true,
                                imageUrl: snapshot.data.toString(),
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                          future: FirebaseStorage.instance
                              .ref(widget.cloth!.images[index])
                              .getDownloadURL());
                      return Image.network(
                        widget.cloth!.images[index],
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.5,
                      );
                    },
                  ),
                ),
                // Image.network(widget.cloth!.images[0]),
                Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.cloth!.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      // show gender
                      Text(
                        widget.cloth!.sex,
                      )
                    ],
                  ),
                  Text(
                    widget.cloth!.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${widget.cloth!.price}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      CustomButton(
                        backgroundColor: Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
                        text: "Add to Cart",
                        onPressed: () {},
                        size: Size.fromWidth(150),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
