// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:lottie/lottie.dart';
// import '../l10n/app_localizations.dart';
// import 'login.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   int _currentPage = 0;
//   late PageController _pageController;
//   late Timer _timer;
//   String _selectedLanguage = 'en';
//
//   final Map<String, String> languageMap = {
//     'en': 'English',
//     'hi': 'हिन्दी',
//     'kn': 'ಕನ್ನಡ',
//     'ml': 'മലയാളം',
//     'te': 'తెలుగు',
//     'ta': 'தமிழ்'
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: _currentPage);
//
//     _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
//       if (_currentPage < 3) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _changeLanguage(String langCode) {
//     setState(() {
//       _selectedLanguage = langCode;
//     });
//   }
//
//   void _showLanguageDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Select Language"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: languageMap.entries.map((entry) {
//               return ListTile(
//                 title: Text(entry.value),
//                 onTap: () {
//                   _changeLanguage(entry.key);
//                   Navigator.pop(context);
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       locale: Locale(_selectedLanguage),
//       supportedLocales: languageMap.keys.map((lang) => Locale(lang)).toList(),
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor:Colors.transparent,
//           elevation: 0,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.language, color: Colors.black),
//               onPressed: _showLanguageDialog,
//             ),
//           ],
//         ),
//         body: Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/Background.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 Expanded(
//                   child: PageView.builder(
//                     controller: _pageController,
//                     itemCount: 4,
//                     onPageChanged: (int page) {
//                       setState(() {
//                         _currentPage = page;
//                       });
//                     },
//                     itemBuilder: (BuildContext context, int index) {
//                       var localization = AppLocalizations.of(context)!;
//                       final content = [
//                         {
//                           'animation': 'assets/1.json',
//                           'title': localization.hello,
//                           'paragraph': localization.mymission
//                         },
//                         {
//                           'animation': 'assets/2.json',
//                           'title': localization.makinglegal,
//                           'paragraph': localization.isimplify,
//                         },
//                         {
//                           'animation': 'assets/4.json',
//                           'title': localization.empowering,
//                           'paragraph': localization.iprovide,
//                         },
//                         {
//                           'animation': 'assets/3.json',
//                           'title': localization.streamlining,
//                           'paragraph': localization.iassist,
//                         },
//                       ];
//
//                       return FractionallySizedBox(
//                         widthFactor: 0.85,
//                         child: SingleChildScrollView(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Lottie.asset(
//                                 content[index]['animation']!,
//                                 height: 200,
//                               ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 content[index]['title']!,
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                 child: Text(
//                                   content[index]['paragraph']!,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.black54,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => LoginPage()),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blueAccent,
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 12,
//                                     horizontal: 24,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(24),
//                                   ),
//                                 ),
//                                 child: Text(localization.getstarted),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lottie/lottie.dart';
import '../l10n/app_localizations.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  int _currentPage = 0;
  late PageController _pageController;
  String _selectedLanguage = 'en';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final Map<String, String> languageMap = {
    'en': 'English',
    'hi': 'हिन्दी',
    'kn': 'ಕನ್ನಡ',
    'ml': 'മലയാളം',
    'te': 'తെలుగు',
    'ta': 'தமிழ்'
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _changeLanguage(String langCode) {
    setState(() {
      _selectedLanguage = langCode;
    });
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A5FE8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.language,
                        color: Color(0xFF4A5FE8),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Select Language",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: languageMap.entries.map((entry) {
                      bool isSelected = _selectedLanguage == entry.key;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? const Color(0xFF4A5FE8).withOpacity(0.08) : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF4A5FE8) : const Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          title: Text(
                            entry.value,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? const Color(0xFF4A5FE8) : const Color(0xFF4B5563),
                              fontSize: 16,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Color(0xFF4A5FE8), size: 22)
                              : null,
                          onTap: () {
                            _changeLanguage(entry.key);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(_selectedLanguage),
      supportedLocales: languageMap.keys.map((lang) => Locale(lang)).toList(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip button
                    if (_currentPage < 3)
                      TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            3,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 60),
                    Material(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: _showLanguageDialog,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.language,
                            color: Color(0xFF4A5FE8),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 4,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                    _fadeController.reset();
                    _fadeController.forward();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var localization = AppLocalizations.of(context)!;
                    final content = [
                      {
                        'animation': 'assets/1.json',
                        'title': localization.hello,
                        'paragraph': localization.mymission
                      },
                      {
                        'animation': 'assets/2.json',
                        'title': localization.makinglegal,
                        'paragraph': localization.isimplify,
                      },
                      {
                        'animation': 'assets/4.json',
                        'title': localization.empowering,
                        'paragraph': localization.iprovide,
                      },
                      {
                        'animation': 'assets/3.json',
                        'title': localization.streamlining,
                        'paragraph': localization.iassist,
                      },
                    ];

                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      // Lottie Animation
                                      Container(
                                        height: size.height * 0.3,
                                        padding: const EdgeInsets.all(20),
                                        child: Lottie.asset(
                                          content[index]['animation']!,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      // Title
                                      Text(
                                        content[index]['title']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A1A1A),
                                          height: 1.3,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // Description
                                      Text(
                                        content[index]['paragraph']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF6B7280),
                                          height: 1.6,
                                          letterSpacing: 0.2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 40),
                                      // Get Started Button - Only on last page
                                      if (index == 3)
                                        SizedBox(
                                          width: double.infinity,
                                          height: 56,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => LoginPage(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF4A5FE8),
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  localization.getstarted,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(Icons.arrow_forward, size: 20),
                                              ],
                                            ),
                                          ),
                                        )
                                      else
                                      // Next button for other pages
                                        SizedBox(
                                          width: double.infinity,
                                          height: 56,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _pageController.nextPage(
                                                duration: const Duration(milliseconds: 400),
                                                curve: Curves.easeInOutCubic,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF4A5FE8),
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Next',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(Icons.arrow_forward, size: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Page Indicators
              Padding(
                padding: const EdgeInsets.only(bottom: 32, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 32 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFF4A5FE8)
                            : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}