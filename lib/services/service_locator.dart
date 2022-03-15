import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

import 'audio_handler.dart';

var getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<AudioHandler>(await initAudioService());
}
