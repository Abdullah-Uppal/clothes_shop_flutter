import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  late Timer _timer;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/demo-video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Video'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(),
          ),
          StreamBuilder(
            stream: _controller.position.asStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                double _value = snapshot.data!.inMilliseconds /
                    _controller.value.duration.inMilliseconds;
                return LinearProgressIndicator(
                  value: _value == double.infinity || _value.isNaN ? 0 : _value,
                  color: Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
                  backgroundColor: Colors.transparent,
                );
              }
              // else
              return SizedBox();
            },
          ),
          Positioned(
            bottom: 30,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    icon: Icon(_controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
