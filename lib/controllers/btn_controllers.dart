import '../screens/offline/offline_screen.dart';

void playlistBtnTaped() {
  OfflineScreen.currentBodyNotifier.value = 1;
}

void favoritesBtnTaped() {
  OfflineScreen.currentBodyNotifier.value = 2;
}

void recentlyBtnTaped() {
  OfflineScreen.currentBodyNotifier.value = 3;
}
