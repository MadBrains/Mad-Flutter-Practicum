import 'package:mad_flutter_practicum/app/app.dart';

import 'widgets/widgets.dart';

class CurrencyDetailPage extends StatefulWidget {
  const CurrencyDetailPage({super.key, required this.title});

  final String title;

  @override
  State<CurrencyDetailPage> createState() => _CurrencyDetailPageState();
}

class _CurrencyDetailPageState extends State<CurrencyDetailPage> {
  double _opacityLevel = 0;

  static const double _defaultLeadingWidth = 56;
  static const double _titleSpacing = 24;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _opacityLevel = 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: _defaultLeadingWidth + _titleSpacing,
        titleSpacing: _titleSpacing,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 40),
        child: AnimatedOpacity(
          opacity: _opacityLevel,
          duration: const Duration(milliseconds: 400),
          child: Column(
            children: [
              for (int i = 0; i < 5; i++)
                Padding(
                  padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
                  child: CurrencyInfoCard(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
