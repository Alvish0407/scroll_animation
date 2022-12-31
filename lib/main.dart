import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:scroll_animation/main_controller.dart';

final List<String> images = [
  "https://upload.wikimedia.org/wikipedia/commons/c/c1/Ed_Sheeran-6886_%28cropped%29.jpg",
  "https://www.wonderwall.com/wp-content/uploads/sites/2/2022/06/shutterstock_editorial_390860fk.jpg",
  "https://static.wikia.nocookie.net/justin-bieber/images/6/64/119825887_10159146072413888_1705069436830960386_n.jpg/revision/latest?cb=20200917072111",
  "https://m.media-amazon.com/images/M/MV5BMTUxMzU2MTk1OF5BMl5BanBnXkFtZTgwNzg4NjAwMzI@._V1_.jpg",
  "https://www.neste.com/sites/neste.com/files/release_attachments/neste_coldplay_collaboration_release_photo._photo_courtesy_of_coldplay_2.jpg",
  "https://i.pinimg.com/originals/08/07/9c/08079c3d51b4881a089faaf152b6edeb.jpg",
  "https://i.scdn.co/image/ab6761610000e5eb288ac05481cedc5bddb5b11b",
  "https://i.scdn.co/image/ab6761610000e5ebec05963eab63676a539fef13",
  "https://i.scdn.co/image/ab6761610000e5eb920dc1f617550de8388f368e",
  "https://wp.inews.co.uk/wp-content/uploads/2021/08/PRI_195037896-e1629450988315.jpg",
  "https://media.gq-magazine.co.uk/photos/6061a1a9a01cc0d39931f9a3/master/pass/29032021_FD_HP.jpg",
  "https://play-lh.googleusercontent.com/x1Wb3lyzFgnmmLHoDYWEjWba8sm1-y3fCX4IPxynTUUTpyNejwMpQe8kkvHhtr4S4g",
];

void main() {
  runApp(const ScrollAnimationView());
}

class ScrollAnimationView extends StatelessWidget {
  const ScrollAnimationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Scroll Animation',
      debugShowCheckedModeBanner: false,
      home: _ColumnView(),
    );
  }
}

class _ColumnView extends StatelessWidget {
  const _ColumnView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      builder: (controller) {
        return SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: List.generate(
              images.length,
              (index) => _Image(index: index),
            ),
          ),
        );
      },
    );
  }
}

class _Image extends StatefulWidget {
  const _Image({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<_Image> createState() => _ImageState();
}

class _ImageState extends State<_Image> {
  RxDouble x = 0.0.obs;
  RxDouble y = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) {
        return GestureDetector(
          onPanUpdate: (details) {
            x.value = x.value + details.delta.dx / 100;
            y.value = y.value - details.delta.dy / 100;
          },
          onPanEnd: (_) {
            x.value = 0;
            y.value = 0;
          },
          child: Obx(
            () {
              int currentOffsetIndex =
                  controller.scrollController.offset ~/ controller.maxHeight;
              double currentOffsetIndexDouble =
                  controller.scrollController.offset / controller.maxHeight;

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateZ(x.value)
                  ..rotateY(y.value),
                alignment: FractionalOffset.center,
                child: SizedBox(
                  height: math.max(
                      0,
                      (currentOffsetIndex >= widget.index)
                          // 1
                          ? controller.maxHeight
                          : (currentOffsetIndexDouble < widget.index &&
                                  widget.index == currentOffsetIndex + 1)
                              // 2
                              ? controller.height +
                                  (currentOffsetIndexDouble -
                                          currentOffsetIndex) *
                                      (controller.maxHeight - controller.height)
                              // 3
                              : controller.height),
                  width: controller.width,
                  child: Opacity(
                    opacity: widget.index < currentOffsetIndexDouble
                        ? 1 - (currentOffsetIndexDouble - currentOffsetIndex)
                        : 1,
                    child: Image.network(
                      images[widget.index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
