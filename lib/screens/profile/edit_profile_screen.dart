import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/circular_progress_component.dart';
import 'package:h/components/container_background_component.dart';
import 'package:h/components/user_default_image_component.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/textfield_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/user_controller.dart';
import 'package:h/utils/image_configs.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  Function onTap;
  EditProfileScreen({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _userNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _localizationController = TextEditingController();

  final _loginController = Get.put(LoginController());
  final _userController = Get.put(UserController());

  File? coverImg;
  File? userImg;

  RxBool coverImageSelected = RxBool(false);
  RxBool userImageSelected = RxBool(false);
  RxBool saving = RxBool(false);

  @override
  void initState() {
    super.initState();

    if (_loginController.userLogged.isNotEmpty) {
      _userNameController.text = _loginController.userLogged.first.userName;
      _bioController.text = _loginController.userLogged.first.biography ?? '';
      _localizationController.text =
          _loginController.userLogged.first.location ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: saving.isTrue ? false : true,
      child: Stack(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            color: Colors.black87,
          ),
          Dismissible(
            key: const Key(''),
            onDismissed: (direction) => widget.onTap(),
            direction: DismissDirection.down,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: ContainerBackgroundComponent(
                  widget: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => widget.onTap(),
                              child: SizedBox(
                                width: 20.w,
                                child: Text(
                                  'Cancelar',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            Text(
                              'Editar Perfil',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            GestureDetector(
                              onTap: () {
                                saving.value = true;

                                _userController
                                    .updateUser(
                                  userName: _userNameController.text,
                                  biography: _bioController.text,
                                  location: _localizationController.text,
                                  userImg: userImg,
                                  coverImg: coverImg,
                                  user: _loginController.userLogged.first,
                                  context: context,
                                )
                                    .then((value) {
                                  Future.delayed(const Duration(seconds: 2),
                                      () async {
                                    await _loginController.loadImages();
                                    saving.value = false;
                                    widget.onTap();
                                    Get.offNamed(
                                      '/profile/${_loginController.userLogged.first.id}',
                                      arguments: {
                                        'user': null,
                                      },
                                    );
                                  });
                                });
                              },
                              child: SizedBox(
                                width: 20.w,
                                child: Text(
                                  textAlign: TextAlign.end,
                                  'Salvar',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        height: 25.h,
                        child: Stack(
                          children: [
                            Obx(
                              () => coverImageSelected.isTrue
                                  ? Container(
                                      width: 100.h,
                                      height: 18.h,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(
                                            coverImg!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : _loginController.userLogged.first.coverImage
                                      ? Obx(
                                          () => Container(
                                            color: Colors.transparent,
                                            child: Image(
                                              image: ResizeImage(
                                                FileImage(
                                                  File(
                                                    _loginController
                                                        .coverImage.value,
                                                  ),
                                                ),
                                                width: 486,
                                                height: 864,
                                              ),
                                              width: 100.w,
                                              height: 18.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 100.w,
                                          height: 18.h,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                "assets/images/capa.jpg",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                coverImageSelected.value = false;
                                await getImage(true, true).then(
                                  (image) {
                                    if (image != null) {
                                      coverImageSelected.value = true;
                                      coverImg = image;
                                    }
                                  },
                                );
                              },
                              child: Container(
                                width: 100.w,
                                height: 18.h,
                                color: Colors.black54,
                                child: const Center(
                                  child: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 13.h,
                                height: 13.h,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                padding: const EdgeInsets.all(6),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Stack(
                                      children: [
                                        Obx(
                                          () => userImageSelected.isTrue
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                        userImg!,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : _loginController.userLogged
                                                      .first.userImage
                                                  ? Image(
                                                      fit: BoxFit.cover,
                                                      image: ResizeImage(
                                                        FileImage(
                                                          File(
                                                            _loginController
                                                                .userImage
                                                                .value,
                                                          ),
                                                        ),
                                                        width: 156,
                                                        height: 275,
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      width: 13.h,
                                                      height: 13.h,
                                                      child:
                                                          UserDefaultImageComponent(),
                                                    ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            userImageSelected.value = false;
                                            await getImage(true, false).then(
                                              (image) {
                                                if (image != null) {
                                                  userImageSelected.value =
                                                      true;
                                                  userImg = image;
                                                }
                                              },
                                            );
                                          },
                                          child: Container(
                                            color: Colors.black54,
                                            child: const Center(
                                              child: Icon(
                                                Icons
                                                    .add_photo_alternate_outlined,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        width: 100.w,
                        height: 0.1,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 35.w,
                              child: Text(
                                'Nome',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            SizedBox(
                              width: 65.w - 20,
                              child: TextFieldComponent(
                                controller: _userNameController,
                                labelText: '',
                                color: Colors.transparent,
                                maxLength: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100.w,
                        height: 0.1,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: 35.w,
                                  height: 50,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Bio',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 65.w - 20,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: _bioController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle:
                                      Theme.of(context).textTheme.labelSmall,
                                ),
                                style: Theme.of(context).textTheme.labelMedium,
                                cursorColor: Colors.white,
                                minLines: 4,
                                maxLines: 4,
                                maxLength: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100.w,
                        height: 0.1,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 35.w,
                              child: Text(
                                'Localização',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            SizedBox(
                              width: 65.w - 20,
                              child: TextFieldComponent(
                                controller: _localizationController,
                                labelText: '',
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100.w,
                        height: 0.1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CircularProgressComponent(loading: saving),
        ],
      ),
    );
  }
}
