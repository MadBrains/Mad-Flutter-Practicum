import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: context.fonts.regular12,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(13, 9, 11, 9),
          child: SizedBox.square(
            dimension: 20,
            child: Image.asset('assets/icons/search.png'),
          ),
        ),
        hintText: 'Поиск',
      ),
    );
  }
}
