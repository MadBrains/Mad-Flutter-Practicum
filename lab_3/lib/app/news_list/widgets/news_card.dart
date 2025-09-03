import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/utils/url_launcher.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  static const String _url = 'https://flutter.dev';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => tryLaunchUrl(_url),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Вводятся новые правила допуска на финансовый рынок кредитных потребительских кооперативов',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ср. 10:47 05.02.25',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF505050),
                    ),
                  ),
                  Text(
                    'cbr.ru',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF505050),
                    ),
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
