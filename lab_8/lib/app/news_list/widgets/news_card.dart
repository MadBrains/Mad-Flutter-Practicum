import 'package:intl/intl.dart';
import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.model});

  final NewsModel model;

  static const String _resource = 'cbr.ru';

  @override
  Widget build(BuildContext context) {
    final DateTime? date = model.date;

    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;

    return GestureDetector(
      onTap: () => tryLaunchUrl(model.link),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: context.colors.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.title,
              style: fonts.semiBold12,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (date != null)
                    Text(
                      DateFormat(AppConstants.newsDateTimeFormat).format(date),
                      style: fonts.regular12.copyWith(color: colors.tin),
                    ),
                  Text(
                    _resource,
                    style: fonts.regular12.copyWith(color: colors.tin),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
