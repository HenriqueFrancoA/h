import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/animated_bar_component.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/card_post_component.dart';
import 'package:h/components/card_user_component.dart';
import 'package:h/components/circular_progress_component.dart';
import 'package:h/components/container_background_component.dart';
import 'package:h/controllers/publication_controller.dart';
import 'package:h/controllers/user_controller.dart';
import 'package:h/models/publication.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RxBool showBar = RxBool(true);
  RxBool searched = RxBool(false);
  RxBool searchedUser = RxBool(true);
  RxBool keyboardOpen = RxBool(false);
  RxBool loading = RxBool(false);

  bool waintingResponse = false;

  RxList<Publication> listPublicationsFound = RxList<Publication>();

  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  ScrollController scrollController = ScrollController();

  final _userController = Get.put(UserController());
  final _publicationController = Get.put(PublicationController());

  final _textFieldFocus = FocusNode();

  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userController.searchAll(null, context);
    scrollController.addListener(scrollListener);
    _textFieldFocus.addListener(
      () {
        keyboardOpen.value = _textFieldFocus.hasFocus;
      },
    );
  }

  void scrollListener() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset &&
        !waintingResponse) {
      if (_userController.finalList.isFalse) {
        waintingResponse = true;
        await _userController.searchAll(
          _userController.listUsers.last,
          context,
        );
        waintingResponse = false;
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    _textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            final scrollPosition = notification.metrics.pixels;

            if (keyboardOpen.isTrue) {
              showBar.value = scrollPosition <= 0 || notification.depth == 0;
            }

            return false;
          },
          child: ContainerBackgroundComponent(
            widget: Stack(
              children: [
                Obx(
                  () => Column(
                    children: [
                      SizedBox(height: searched.isTrue ? 15.h : 10.h),
                      SizedBox(
                        height: keyboardOpen.isTrue
                            ? 60.h - 80
                            : searched.isTrue
                                ? 85.h - 80
                                : 90.h - 80,
                        width: 100.w,
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: searched.isTrue
                              ? searchedUser.isTrue
                                  ? _userController.listUsersFound.length
                                  : _publicationController
                                      .listPublicationsFound.length
                              : _userController.listUsers.length,
                          itemBuilder: (context, index) => searchedUser.isTrue
                              ? CardUserComponent(
                                  user: searched.isTrue
                                      ? _userController.listUsersFound[index]
                                      : _userController.listUsers[index],
                                )
                              : CardPostComponent(
                                  publication: _publicationController
                                      .listPublicationsFound[index],
                                  sharing: false,
                                  replyScreen: false,
                                  replyDirectly: false,
                                  replyPublication: false,
                                  contador: 0,
                                ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 1.h),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Obx(
                      () => AnimatedBarComponent(
                        showBar: showBar,
                        getBack: false,
                        hasFocus: keyboardOpen.value,
                        focusNode: _textFieldFocus,
                        textController: _textController,
                        onSubmitted: (text) async {
                          loading.value = true;
                          if (searchedUser.isTrue) {
                            await _userController.searchContainsUsername(
                              text,
                              context,
                            );
                          } else {
                            await _publicationController.searchContainsText(
                              text,
                              context,
                            );
                          }
                          searched.value = true;
                          loading.value = false;
                        },
                        onTapCancel: () {
                          _textFieldFocus.unfocus();
                          _textController.clear();
                          searched.value = false;
                          searchedUser.value = true;
                        },
                        searched: searched.value,
                      ),
                    ),
                    Obx(
                      () => searched.isTrue
                          ? Column(
                              children: [
                                SizedBox(height: 1.h),
                                Container(
                                  width: 100.w,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          loading.value = true;
                                          searchedUser.value = true;
                                          await _userController
                                              .searchContainsUsername(
                                            _textController.text,
                                            context,
                                          );
                                          loading.value = false;
                                        },
                                        child: Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: searchedUser.isTrue
                                                      ? Colors.blue
                                                      : Colors.transparent,
                                                  width: 3,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Usuários',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          loading.value = true;
                                          searchedUser.value = false;
                                          await _publicationController
                                              .searchContainsText(
                                            _textController.text,
                                            context,
                                          );
                                          loading.value = false;
                                        },
                                        child: Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: searchedUser.isFalse
                                                      ? Colors.blue
                                                      : Colors.transparent,
                                                  width: 3,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Posts',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100.w,
                                  height: 0.5,
                                  color: Colors.grey,
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ],
                ),
                Obx(
                  () => keyboardOpen.isTrue
                      ? Container()
                      : BottomBarComponent(
                          showBar: showBar,
                          index: 1,
                        ),
                ),
                CircularProgressComponent(loading: loading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
