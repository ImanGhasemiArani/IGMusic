import 'package:flutter/material.dart';

import 'first_layer.dart';
import 'second_layer.dart';
import 'third_layer.dart';

class MainBody extends StatelessWidget {
  MainBody({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 32, 41, 1)),
      height: double.infinity,
      width: double.infinity,
      child: CustomScrollView(
        controller: _scrollController,
        shrinkWrap: true,
        slivers: [
          SliverPersistentHeader(
              delegate:
                  PersistentHeader(widget: const FirstLayer(), extent: 200)),
          SliverPersistentHeader(
              pinned: true,
              delegate:
                  PersistentHeader(widget: const SecondLayer(), extent: 55)),
          const ThirdLayer(),
          SliverPersistentHeader(
              delegate: PersistentHeader(
                  widget: Container(
                    height: 90,
                    color: Colors.transparent,
                  ),
                  extent: 90))
        ],
      ),
    );
  }
}

//
//
//
//
//
class PersistentHeader extends SliverPersistentHeaderDelegate {
  final double extent;
  final Widget widget;

  PersistentHeader({required this.widget, required this.extent});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
        width: double.infinity, height: extent, child: Center(child: widget));
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;
}
