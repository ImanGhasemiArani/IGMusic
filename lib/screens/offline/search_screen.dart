import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/fonts.dart';
import '../../assets/icos.dart';
import '../../lang/strs.dart';
import '../../models/user_data.dart';
import '../../widgets/button/tap_effect.dart';
import '../../widgets/card/search_items.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  var isFocused = false.obs;
  var isShowClearIcon = false.obs;
  final List<Widget> _searchResults = <Widget>[].obs;

  @override
  void initState() {
    _searchFocusNode
        .addListener(() => isFocused.value = _searchFocusNode.hasFocus);
    _searchController.addListener(() {
      isShowClearIcon.value = _searchController.text.isNotEmpty;
      updateSearchResults(_searchController.text);
    });
    FocusScope.of(Get.context!).requestFocus(_searchFocusNode);

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void updateSearchResults(String searchText) {
    var newResultsID = UserData().searchSong(searchText);
    var tmp = UserData().audiosMetadataMapToID;
    var newResults = <SearchSongItem>[];
    newResults = newResultsID
        .map((id) => SearchSongItem(audioMetadata: tmp[id]!))
        .toList();
    _searchResults.clear();
    _searchResults.addAll(newResults);
  }

  @override
  Widget build(BuildContext context) {
    var appBarSize = AppBar().preferredSize;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: appBar(appBarSize, context),
      body: Obx(
        () => ListView.builder(
          addAutomaticKeepAlives: true,
          physics: const BouncingScrollPhysics(),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            return _searchResults[index];
          },
        ),
      ),
    );
  }

  AppBar appBar(Size appBarSize, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(10),
      )),
      centerTitle: true,
      leading: Obx(
        () => AnimatedRotation(
          duration: const Duration(milliseconds: 200),
          turns: isFocused.value ? 0 : 0.25,
          child: TapEffect(
            onTap: isFocused.value
                ? () => _searchFocusNode.unfocus()
                : () => Get.back(),
            child: const Icon(Icos.down_arrow_2),
          ),
        ),
      ),
      title: SizedBox(
        height: appBarSize.height * 0.68,
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: Strs.searchStr.tr,
            hintMaxLines: 1,
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
            contentPadding: const EdgeInsets.all(0),
            fillColor: Theme.of(context).cardColor,
            filled: true,
            prefixIcon: Obx(
              () => Visibility(
                visible: isShowClearIcon.value,
                child: GestureDetector(
                  onTap: _searchController.clear,
                  child: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 25,
                  ),
                ),
              ),
            ),
            suffixIcon: Icon(
              Icos.search,
              color: Theme.of(context).colorScheme.primary,
              size: 25,
            ),
          ),
          maxLines: 1,
          style: Fonts.regular_16_2,
        ),
      ),
    );
  }
}
