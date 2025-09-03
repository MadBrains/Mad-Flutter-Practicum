# Лабораторная работа №7. Работа с анимациями

## 1. Цель работы

Целью настоящей лабораторной работы является освоение инструментов и подходов к созданию анимаций во Flutter-приложении. В процессе выполнения студенты получают практические навыки:

- работы с анимациями на базе классов `AnimationController`, `Tween`, `AnimatedBuilder` и других компонентов фреймворка Flutter;
- управления состоянием анимации и её жизненным циклом;
- создания пользовательских и переходных анимаций при отображении элементов интерфейса;
- повышения интерактивности и отзывчивости приложения за счёт плавных визуальных переходов;
- соблюдения принципов адаптивного и доступного UI при использовании анимаций.

В рамках лабораторной работы реализуются анимированные переходы между экранами, а также анимации внутри отдельных компонентов пользовательского интерфейса. Результатом выполнения работы является улучшенное визуальное представление приложения, обеспечивающее более комфортное и современное взаимодействие с пользователем.

## 2. Общее описание

Анимации играют ключевую роль в создании современного пользовательского интерфейса, обеспечивая плавные переходы, визуальные отклики на действия пользователя и общее ощущение динамичности приложения. В данной лабораторной работе основное внимание уделяется реализации анимаций с использованием встроенных средств Flutter без применения сторонних библиотек.

Обучающиеся познакомятся с основными принципами построения анимаций во Flutter, включая:

- использование `AnimationController` для управления воспроизведением анимации;
- создание кривых интерполяции с помощью `CurvedAnimation`;
- применение `Tween` и его производных для задания промежуточных значений;
- обновление интерфейса на каждом кадре анимации через `AnimatedBuilder`;
- использование `AnimatedOpacity` для простых анимированных изменений без ручного управления состоянием.

Особое внимание в работе уделяется правильной организации кода и управлению жизненным циклом анимационных объектов (инициализация, запуск, остановка, утилизация). Также рассматривается подход к созданию анимированных переходов между состояниями и компонентами, включая появление/исчезновение элементов и изменение их параметров (размер, положение, прозрачность и т.д.).

Результатом выполнения лабораторной работы является прототип приложения, содержащий несколько взаимодействующих анимаций, улучшающих восприятие интерфейса и делающих его более отзывчивым.

## 3. Основная часть

При работе с управляемыми анимациями во Flutter (на базе `AnimationController`) требуется добавление миксина `SingleTickerProviderStateMixin` в класс состояния. Этот миксин предоставляет виджету тикер — объект, который сообщает контроллеру, когда следует обновить значение анимации, что позволяет синхронизировать её с кадровым циклом экрана. Без него `AnimationController` не сможет корректно работать, так как будет неоткуда получать временные метки.

В большинстве случаев используется упрощённая версия — `SingleTickerProviderStateMixin`, если в виджете требуется только один `AnimationController`. Если же контроллеров несколько, то нужно использовать полный `TickerProviderStateMixin`, чтобы каждый мог получать отдельный тикер.

Анимации во Flutter условно делятся на два типа:

- **Неуправляемые (implicit)** — задаются через виджеты `AnimatedFoo` (`AnimatedOpacity`, `AnimatedScale`, `AnimatedRotation` и т.д.), которые автоматически анимируют изменение значения (например, `AnimatedOpacity`, `AnimatedContainer`, `AnimatedAlign`). Это простой способ реализовать анимацию, когда нет необходимости управлять её состоянием вручную. Больше подробностей о неуправляемых анимациях в этой [документации](https://api.flutter.dev/flutter/widgets/ImplicitlyAnimatedWidget-class.html).
- **Управляемые (explicit)** — требуют явного создания `AnimationController`, `Tween`, `CurvedAnimation` и использования обёрток `AnimatedBuilder` или `FooTransition` (`FadeTransition`, `ScaleTransition`, `AlignTransition` и т.д.). Эти анимации дают полный контроль над процессом, включая воспроизведение, остановку, обратный запуск и реакции на завершение. Больше подробностей о управляемых анимациях в этой [документации](https://docs.flutter.dev/ui/animations#essential-animation-concepts-and-classes).

По сути, любой визуальный результат анимации может быть достигнут разными способами: через `AnimatedFoo`, `FooTransition` или с помощью `AnimatedBuilder`. Выбор зависит от необходимой гибкости и сложности сценария.

### Обновление splash-экрана (splash_page.dart)

Добавим анимацию поворота иконки с помощью `AnimatedRotation`. Это простая implicit-анимация, которая позволяет реализовать визуальное вращение без создания контроллера:

```dart
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _turns = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _turns = 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedRotation(
          turns: _turns,
          duration: Duration(milliseconds: 400),
          child: FlutterLogo(size: 128),
        ),
      ),
      backgroundColor: context.colors.primary,
    );
  }
}
```

![Splash Page Animation](/videos/splash_page_animation.gif)

### Обновление экрана авторизации (login_page.dart)

Добавим анимацию поворота кнопки с помощью `AnimatedBuilder`. В отличие от `AnimatedRotation`, этот способ требует явного контроллера, но даёт больше гибкости в настройке анимации:

```dart
import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          child: ElevatedButton(
            onPressed: () => context.read<SettingsRepository>().setToken(_generateRandomToken()),
            child: Text(
              'Войти',
              style: context.fonts.regular14,
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(angle: _controller.value * 2 * math.pi, child: child);
          },
        ),
      ),
    );
  }
}
```

![Login Page Animation](/videos/login_page_animation.gif)

> Результат анимаций на `SplashPage` и `LoginPage` по сути одинаковый (вращение), но способы реализации разные. Первый — декларативный и простой, второй — ручной и гибкий.

### Обновление экрана списка валют (currency_list_page.dart)

Добавим анимацию появления списка с помощью `FadeTransition`. Для этого используется `AnimationController` для управления анимацией и объект `Animation<double>`, определяющий уровень прозрачности согласно указанному диапазону. Такой подход позволяет более гибко управлять поведением анимации, включая её запуск и длительность. 

```dart
class _CurrencyListPageState extends State<CurrencyListPage> with SingleTickerProviderStateMixin {
  ...

  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initData();
  }

  @override
  void dispose() {
    _filteredCurrenciesNotifier.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
  }

  void _initData() {
    final currencyRepository = context.read<CurrencyRepository>();

    _currencyListFuture = currencyRepository.getCurrencyList().then((List<CurrencyModel> value) {
      _allCurrencies = value;
      _filteredCurrenciesNotifier = ValueNotifier(value);

      _fadeController.forward(); // запускаем анимацию

      currencyRepository.saveCurrencyList(value);

      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Курс Валют')),
      body: FutureBuilder(
        future: _currencyListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<CurrencyModel>> snapshot) {
          final List<CurrencyModel>? data = snapshot.data;
          if (data == null) return const SizedBox.shrink();

          return FadeTransition(
            opacity: _fadeController.view,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                  child: SearchView(onChanged: _filterCurrencies),
                ),
                Expanded(
                  child: ValueListenableBuilder<List<CurrencyModel>>(
                    valueListenable: _filteredCurrenciesNotifier,
                    builder: (BuildContext context, List<CurrencyModel> data, _) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final CurrencyModel currency = data[index];

                          return Padding(
                            key: ValueKey(currency.id),
                            padding: index == 0 ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(top: 10),
                            child: CurrencyCard(model: currency),
                          );
                        },
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 40),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

> Важно: для анимации в стандартном диапазоне от 0 до 1 можно использовать непосредственно `AnimationController`, так как он по умолчанию работает в этих границах (свойства `lowerBound = 0` и `upperBound = 1`). Для таких случаев достаточно передать `AnimationController.view` вместо создания отдельного объекта `Animation`.
Если требуется нестандартный диапазон значений, следует использовать `Tween<double>(begin: ..., end: ...)`, который является наиболее распространённой реализацией `Animatable`. Альтернативный подход - изменить границы самого контроллера через свойства `lowerBound` и `upperBound`, если это соответствует архитектуре вашей анимации.

![Currency List Page Animation](/videos/currency_list_page_animation.gif)

### Обновление детального экрана валюты (currency_detail_page.dart)

Добавим анимацию появления детальной информации с помощью `AnimatedOpacity`. Это implicit-анимация, которая не требует отдельного контроллера и автоматически обрабатывает изменения:

```dart
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
```

![Currency Detail Page Animation](/videos/currency_detail_page_transition.gif)

> Результат анимации на `CurrencyListPage` и `CurrencyDetailPage` — постепенное появление элементов. Отличие лишь в подходе: `FadeTransition` требует контроллера, а `AnimatedOpacity` — нет.

### Обновление карточки валюты (`currency_card.dart`)

Добавим анимацию при переходе на экран деталей валюты. Для этого используется `PageRouteBuilder` и его `transitionsBuilder`, в котором задаются правила анимационного перехода между экранами:

```dart
class CurrencyCard extends StatelessWidget {
  const CurrencyCard({super.key, required this.model});

  final CurrencyModel model;

  static final _tweenAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero);

  @override
  Widget build(BuildContext context) {
    ...
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return CurrencyDetailPage(title: model.name);
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const Cubic curve = Curves.ease;
          
              final Animatable<Offset> tween = _tweenAnimation.chain(CurveTween(curve: curve));
              final Animation<Offset> offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      },
      ...
    );
  }
}
```

Анимация перехода реализована через `SlideTransition`. Чтобы совместить изменение положения с кривой анимации, применяется метод `chain()`, который объединяет `Tween` и `CurveTween` в единую анимационную последовательность. Это позволяет создать составную анимацию, комбинирующую изменения значений и кривизну интерполяции.

### Обновление экрана списка новостей (news_list_page.dart)

Добавим анимацию масштабирования списка новостей с помощью `ScaleTransition`:

```dart
class _NewsListPageState extends State<NewsListPage> with SingleTickerProviderStateMixin {
  ...

  static final _tween = Tween<double>(begin: 0.25, end: 1);

  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initData();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = _tween.animate(_scaleController);
  }

  void _initData() {
    final newsRepository = context.read<NewsRepository>();

    _newsListFuture = newsRepository.getNewsList().then((List<NewsModel> value) {
      newsRepository.saveNewsList(value);

      _scaleController.forward(); // запускаем анимацию

      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Новости')),
      body: FutureBuilder<List<NewsModel>>(
        future: _newsListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
          final List<NewsModel>? data = snapshot.data;
          if (data == null) return const SizedBox.shrink();

          return ScaleTransition(
            scale: _scaleAnimation,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final NewsModel news = data[index];

                return Padding(
                  key: ValueKey(news.link),
                  padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
                  child: NewsCard(model: news),
                );
              },
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
            ),
          );
        },
      ),
    );
  }
}
```

![News List Page Animation](/videos/news_list_page.gif)

### Обновление экрана профиля (profile_page.dart)

Добавим анимацию передвижения кнопки деавторизации с помощью `AlignTransition`, изменяя выравнивание элемента от одного положения к другому:

```dart
class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  ...

  static final _tween = Tween<Alignment>(begin: Alignment.centerLeft, end: Alignment.centerRight);

  late final AnimationController _alignmentController;
  late Animation<AlignmentGeometry> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    _alignmentController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _alignmentController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _alignmentAnimation = _tween.animate(_alignmentController);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeFonts fonts = context.fonts;

    return Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _themeModeNotifier,
              builder: (BuildContext context, AppThemeMode mode, Widget? child) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 24),
                  leading: Icon(Icons.dark_mode),
                  title: child,
                  subtitle: Text(
                    mode.title,
                    style: fonts.regular12,
                  ),
                  onTap: () async {
                    final AppThemeMode? newMode = await ThemeModeSelectorBottomSheet.show(context, mode);
                    if (newMode == null) return;

                    _themeModeNotifier.value = newMode;
                  },
                );
              },
              child: Text(
                'Тема',
                style: fonts.regular16,
              ),
            ),
            const Spacer(),
            AlignTransition(
              alignment: _alignmentAnimation,
              child: ElevatedButton(
                onPressed: () => context.read<SettingsRepository>().setToken(null),
                child: Text(
                  'Выйти',
                  style: fonts.regular14.copyWith(color: context.colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

![Profile Page Animation](/videos/profile_page_animation.gif)

### Вывод

Анимации позволяют сделать интерфейс живым и отзывчивым. В зависимости от задач, можно выбрать простой способ (`AnimatedFoo`), использовать более гибкие `FooTransition` или полностью управлять процессом через `AnimatedBuilder`. При этом важно помнить, что анимации должны дополнять UX, а не мешать ему. Выбор подхода зависит от степени контроля, требуемой логики и необходимости повторного использования анимации.

## 4. Самостоятельная часть

> Перед выполнением задания рекомендуется выбрать целевой уровень (оценку), что позволит определить глубину проработки и трудоёмкость реализации. Все уровни ориентированы на закрепление и расширение практических навыков работы с анимациями во Flutter.

### Задание на оценку "3"

- Реализовать все анимации, описанные в основной части лабораторной работы.
- Произвести замену анимационных подходов на следующих экранах, сохранив прежнее визуальное поведение:
  - `SplashPage` — заменить `AnimatedRotation` на `RotationTransition`;
  - `LoginPage` — заменить `AnimatedBuilder` на `AnimatedRotation`;
  - `CurrencyListPage` — заменить `FadeTransition` на `AnimatedBuilder`;
  - `CurrencyDetailPage` — заменить `AnimatedOpacity` на `AnimatedBuilder`;
  - `CurrencyCard` — заменить `SlideTransition` на `ScaleTransition`;
  - `NewsListPage` — заменить `ScaleTransition` на `AnimatedScale`;
  - `ProfilePage` — заменить `AlignTransition` на `AnimatedAlign`.

> Основным критерием является корректная работа всех анимаций после замены, без визуальных и логических отклонений от изначального поведения.

### Задание на оценку "4"

Дополнительно к предыдущим требованиям:

- Выбрать и интегрировать две анимации из свободного набора [Lottie Files](https://lottiefiles.com/free-animations/json):
  - первую необходимо разместить на `SplashPage` (будет воспроизводиться автоматически);
  - вторую — на `ProfilePage`. Дополнительно нужно реализовать управление воспроизведением: анимация должна запускаться при первом нажатии на кнопку и останавливаться при повторном.

Для реализации использовать библиотеку [`lottie`](https://pub.dev/packages/lottie), обеспечивающую поддержку JSON-анимаций во Flutter.

> При выборе анимаций рекомендуется учитывать стилистику текущего приложения, избегая визуального диссонанса.

### Задание на оценку "5"

Дополнительно к предыдущим требованиям:

- Реализовать составную (разнесённую) анимацию `RotateFadeScaleAnimation` на произвольном экране. Анимация должна объединять три эффекта:
  - вращение (`rotate`);
  - изменение прозрачности (`fade`);
  - масштабирование (`scale`).

Все три анимации могут запускаться как последовательно, так и параллельно — на усмотрение студента. Главное — каждая из них должна быть реализована и встроена в общий цикл с использованием общего `AnimationController`.

Для реализации использовать подход **staggered animation**, основанный на разделении интервалов внутри одного `AnimationController` и применении нескольких `Tween`. Это позволяет гибко управлять временем начала и окончания каждой части анимации и создавать сложные анимационные сценарии. Подробное описание подхода представлено в [официальной документации](https://docs.flutter.dev/ui/animations/staggered-animations).

> ✅ Уровень "5" предполагает полное понимание принципов управления сложными анимациями, а также умение сочетать их в рамках одного сценария.