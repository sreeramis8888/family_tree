<<<<<<< HEAD
final RegExp _youtubeUrlPattern = RegExp(
  r"^(https?:\/\/)?(www\.)?(youtube\.com\/(watch\?v=|shorts\/)|youtu\.be\/)[\w\-]+(\?[\w=&%-]*)?$",
);

String? validateYouTubeUrl(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a YouTube link';
  }
  if (!_youtubeUrlPattern.hasMatch(value)) {
    return 'Please enter a valid YouTube video or Shorts link';
  }
  return null;
}
=======
final RegExp _youtubeUrlPattern = RegExp(
  r"^(https?:\/\/)?(www\.)?(youtube\.com\/(watch\?v=|shorts\/)|youtu\.be\/)[\w\-]+(\?[\w=&%-]*)?$",
);

String? validateYouTubeUrl(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a YouTube link';
  }
  if (!_youtubeUrlPattern.hasMatch(value)) {
    return 'Please enter a valid YouTube video or Shorts link';
  }
  return null;
}
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
