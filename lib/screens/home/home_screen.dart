import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/animated_bar_component.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/card_post_component.dart';
import 'package:h/components/container_background_component.dart';
import 'package:h/controllers/publication_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RxBool showBar = RxBool(true);
  double prevScrollPosition = 0.0;

  final _publicationController = Get.put(PublicationController());

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _publicationController.searchAll(null, context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final scrollDirection =
        _scrollController.position.pixels - prevScrollPosition;
    if (scrollDirection > 0) {
      showBar.value = false;
    } else {
      showBar.value = true;
    }
    prevScrollPosition = _scrollController.position.pixels;
  }

  Future<void> _refresh() async {
    _publicationController.searchAll(null, context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: ContainerBackgroundComponent(
          widget: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _refresh,
                backgroundColor: Colors.white,
                child: Obx(
                  () => _publicationController.listPublication.isNotEmpty
                      ? ListView.separated(
                          controller: _scrollController,
                          itemCount:
                              _publicationController.listPublication.length + 2,
                          itemBuilder: (context, index) {
                            index = index - 1;

                            if (index ==
                                _publicationController.listPublication.length) {
                              if (_publicationController.finalList.isFalse) {
                                _publicationController.searchAll(
                                    _publicationController
                                        .listPublication[index - 1],
                                    context);
                              }
                              return FutureBuilder(
                                future:
                                    Future.delayed(const Duration(seconds: 3)),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      height: 15.h,
                                      padding: const EdgeInsets.all(5),
                                      child: const Align(
                                        alignment: Alignment.topCenter,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 15.h,
                                    );
                                  }
                                },
                              );
                            }
                            return index < 0
                                ? SizedBox(
                                    height: 10.h,
                                  )
                                : CardPostComponent(
                                    publication: _publicationController
                                        .listPublication[index],
                                    sharing: false,
                                    replyScreen: false,
                                    replyDirectly: false,
                                    replyPublication: false,
                                    contador: 0,
                                  );
                          },
                          separatorBuilder: (context, index) => index == 0
                              ? Container()
                              : Container(
                                  width: 100.w,
                                  height: 0.5,
                                  color: Colors.grey,
                                ),
                        )
                      : Container(),
                ),
              ),
              AnimatedBarComponent(
                showBar: showBar,
                getBack: false,
                hasFocus: false,
                searched: false,
                onTapPublish: () => Get.toNamed(
                  '/publish',
                  arguments: {
                    'commenting': null,
                    'sharing': null,
                  },
                ),
              ),
              BottomBarComponent(
                showBar: showBar,
                index: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
