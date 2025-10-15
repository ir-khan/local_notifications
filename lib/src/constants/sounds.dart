enum SoundConstants {
  sound1(android: 'sound1', iOS: 'sound1.wav'),
  sound2(android: 'sound2', iOS: 'sound2.wav'),
  sound3(android: 'sound3', iOS: 'sound3.wav');

  final String android;
  final String iOS;

  const SoundConstants({required this.android, required this.iOS});
}
