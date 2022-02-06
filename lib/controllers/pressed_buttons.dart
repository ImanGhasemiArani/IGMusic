import '../screens/offline/offline_screen.dart';

void playlistButtonPressed() {
  OfflineScreen.currentBodyNotifier.value = 1;
}

void favoritesButtonPressed() {
  OfflineScreen.currentBodyNotifier.value = 2;
}

void recentlyButtonPressed() {
  OfflineScreen.currentBodyNotifier.value = 3;
}
