import 'package:flutter/material.dart';

class CurrencyInfoCard extends StatelessWidget {
  const CurrencyInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 24, 8, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                'Ср. 10:47 05.02.25',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(
              '60.99',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1FD522),
              ),
            ),
          ),
          Image.asset(
            'assets/icons/arrow_up.png',
            width: 10,
            height: 10,
          ),
        ],
      ),
    );
  }
}
