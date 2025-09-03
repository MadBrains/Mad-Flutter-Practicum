class NewsModel {
  const NewsModel({
    required this.title,
    required this.link,
    this.date,
  });

  final String title;
  final String link;
  final DateTime? date;
}
