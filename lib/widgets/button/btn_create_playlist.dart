import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/fonts.dart';
import '../../assets/icos.dart';
import '../../controllers/btn_controllers.dart';
import '../../lang/strs.dart';
import '../../models/user_data.dart';
import 'tap_effect.dart';

class BtnCreatePlaylist extends StatelessWidget {
  const BtnCreatePlaylist({Key? key, this.size = 30}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width / 4,
      child: Center(
        child: TapEffect(
          onTap: () {
            bottomSheet(context);
          },
          child: Icon(
            Icos.createPlaylist,
            size: size,
          ),
        ),
      ),
    );
  }

  Object bottomSheet(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final TextEditingController textEditingController = TextEditingController();
    final isUniqueName = true.obs;
    return Get.bottomSheet(
      Padding(
        padding: EdgeInsets.symmetric(vertical: size.height / 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Strs.createPlaylistStr.tr,
              style: Fonts.overlock_14_w700.copyWith(color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height / 40),
              child: SizedBox(
                width: size.width / 1.3,
                child: Text(
                  Strs.enterPlaylistNameStr.tr,
                  style: Fonts.overlock_20_w700.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(
              width: size.width / 1.3,
              child: GetInputPlaylistNameTextField(
                isUniqueName: isUniqueName,
                controller: textEditingController,
              ),
            ),
            SizedBox(height: size.height / 40),
            SizedBox(
              width: size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      enableFeedback: false,
                      primary: Colors.white70,
                      onPrimary: Colors.black,
                      minimumSize: Size(size.width / 3, 36),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1000),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.cancel_outlined,
                    ),
                    label: Text(Strs.cancelStr.tr),
                  ),
                  Obx(() {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        enableFeedback: false,
                        primary: isUniqueName.isTrue ? null : Colors.grey,
                        onPrimary: Colors.black,
                        minimumSize: Size(size.width / 3, 36),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(1000),
                          ),
                        ),
                      ),
                      onPressed: isUniqueName.isFalse
                          ? null
                          : () {
                              btnCreatePlaylistTaped(
                                  textEditingController.text);
                              Navigator.pop(context);
                            },
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                      ),
                      label: Text(Strs.createStr.tr),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
      enableDrag: false,
      backgroundColor: Colors.blueGrey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
    );
  }
}

class GetInputPlaylistNameTextField extends StatefulWidget {
  const GetInputPlaylistNameTextField(
      {Key? key, required this.isUniqueName, required this.controller})
      : super(key: key);

  final TextEditingController controller;
  final RxBool isUniqueName;

  @override
  State<GetInputPlaylistNameTextField> createState() =>
      _GetInputPlaylistNameTextFieldState();
}

class _GetInputPlaylistNameTextFieldState
    extends State<GetInputPlaylistNameTextField> {
  late final TextEditingController _controller;
  final FocusNode _focusController = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller..text = UserData().getDefaultPlaylistName();
    _focusController.addListener(() {
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    });
    _controller.addListener(() => widget.isUniqueName.value =
        UserData().checkIsPlaylistNameUnique(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusController,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        fillColor: Theme.of(context).cardColor,
        filled: true,
      ),
      maxLines: 1,
      style: Fonts.itim_16_1dot5,
    );
  }
}
