import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const EBookStoreApp());
}

class EBookStoreApp extends StatelessWidget {
  const EBookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'E-BookStore',
        debugShowCheckedModeBanner: false,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 360, name: MOBILE),
            const Breakpoint(start: 361, end: 600, name: TABLET),
            const Breakpoint(start: 601, end: 840, name: DESKTOP),
          ],
        ),
        theme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFFB8973A),
            surface: const Color(0xFF1A1A1A),
          ),
          scaffoldBackgroundColor: const Color(0xFF0F0F0F),
          useMaterial3: true,
        ),
        home: child,
      ),
      child: const WelcomeScreen(),
    );
  }
}
