import 'package:flutter/material.dart';
import '../controllers/services_controller.dart';

import '../models/service.dart';

class ServiceTile extends StatefulWidget {
  final Service service;
  final VoidCallback deleteCallback;
  const ServiceTile({
    super.key,
    required this.service,
    required this.deleteCallback,
  });

  @override
  State<ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text("Update"),
              onTap: () async {
//                await Navigator.of(context).pushNamed(
                //                   "/update",
                //                  arguments: [widget.service, widget.deleteCallback],
                //             );
                () async {}().then((value) {
                  Navigator.of(context).pushNamed(
                    "/update",
                    arguments: [widget.service, widget.deleteCallback],
                  );
                });
              },
            ),
            PopupMenuItem(
              child: Text("Delete"),
              onTap: () {
                ServicesController()
                    .delete(widget.service.id.toString())
                    .then((value) {
                  widget.deleteCallback();
                  print(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Successfully Deleted!"),
                    ),
                  );
                });
              },
            ),
          ];
        },
      ),
      shape: BeveledRectangleBorder(side: BorderSide.none),
      title: Text(widget.service.name),
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(widget.service.description),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
