import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ig_music/models/user_data.dart';
import 'package:ig_music/util/util_artwork.dart';

import '../../assets/fonts.dart';
import '../../assets/icos.dart';
import '../../assets/imgs.dart';
import '../../controllers/btn_controllers.dart';
import '../../util/audio_info.dart';
import '../../widgets/button/tap_effect.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  var isFocused = false.obs;
  final List<int> _searchResults = <int>[].obs;

  @override
  void initState() {
    _searchFocusNode
        .addListener(() => isFocused.value = _searchFocusNode.hasFocus);
    _searchController
        .addListener(() => updateSearchResults(_searchController.text));
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void updateSearchResults(String searchText) {
    var newResults = UserData().searchSong(searchText);
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
          physics: const BouncingScrollPhysics(),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            var item = UserData().audiosMetadataMapToID[_searchResults[index]]!;
            var list = exportData(item.title, item.artist, item.album);
            var trackName = list[0];
            var artistAlbumName = "${list[1]} | ${list[2]}";
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  songItemTaped(
                      playlist: UserData().audiosMetadata,
                      audioMetadata: item,
                      index: UserData().audiosMetadata.indexOf(item));
                },
                enableFeedback: false,
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          Imgs.imgDefaultMusicCover,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: getArtwork(artworkData: item.artwork),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      trackName,
                      style: Fonts.rajdhani_16_w900,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      artistAlbumName,
                      style: Fonts.overlock_14_w700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
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
            contentPadding: const EdgeInsets.all(0),
            fillColor: Theme.of(context).cardColor,
            filled: true,
            prefixIcon: GestureDetector(
              onTap: _searchController.clear,
              child: Icon(
                Icons.clear_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 25,
              ),
            ),
            suffixIcon: Icon(
              Icos.search,
              color: Theme.of(context).colorScheme.primary,
              size: 25,
            ),
          ),
          maxLines: 1,
          style: Fonts.itim_16_1dot5,
        ),
      ),
    );
  }
}
