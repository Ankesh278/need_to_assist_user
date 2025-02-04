import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:need_to_assist/providers/auth_provider.dart';
import 'package:need_to_assist/providers/map_provider.dart';
import 'package:need_to_assist/providers/navigation_provider.dart';
import 'package:need_to_assist/providers/onboarding_provider.dart';
import 'package:need_to_assist/view/screens/booking_screen.dart';
import 'package:need_to_assist/view/screens/detail_screen.dart';
import 'package:need_to_assist/view/screens/home_screen.dart';
import 'package:need_to_assist/view/screens/location_search.dart';
import 'package:need_to_assist/view/screens/login_screen.dart';
import 'package:need_to_assist/view/screens/map_screen.dart';
import 'package:need_to_assist/view/screens/notification_screen.dart';
import 'package:need_to_assist/view/screens/onboarding_screen.dart';
import 'package:need_to_assist/view/screens/otp_screen.dart';
import 'package:need_to_assist/view/screens/payment_screen.dart';
import 'package:need_to_assist/view/screens/profile_screen.dart';
import 'package:need_to_assist/view/screens/registration.dart';
import 'package:need_to_assist/view/screens/search_screen.dart';
import 'package:need_to_assist/view/screens/service_detail.dart';
import 'package:provider/provider.dart';
import 'core/config/firebase_options.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_)=>MapProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()..fetchCategories()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
              navigatorKey: Provider.of<NavigationProvider>(context, listen: false).navigatorKey,


            theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => const OnboardingScreen());

              case '/login':
                return MaterialPageRoute(builder: (_) => const LoginPage());

              case '/home':
                return MaterialPageRoute(builder: (_) =>  HomeScreen());
              case '/service':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => ServiceDetail(
                    cardData: args['cardData'],
                    product: args['product'],
                    category: args['category'],
                  ),
                );

              case '/map':
                return MaterialPageRoute(builder: (_) => const MapSample());

              case '/booking':
                return MaterialPageRoute(builder: (_) => const BookingScreen());

              case '/location_search':
                return MaterialPageRoute(builder: (_) => const LocationSearch());

              case '/notification':
                return MaterialPageRoute(builder: (_) => const NotificationScreen());

              case '/otp':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => OtpScreen(
                    phoneNumber: args['phoneNumber'],
                  ),
                );
              case '/payment':
                return MaterialPageRoute(builder: (_) => const PaymentScreen());

              case '/profile':
                return MaterialPageRoute(builder: (_) => const ProfileScreen());

              case '/registration':
                return MaterialPageRoute(builder: (_) => const Registration());

              case '/search':
                return MaterialPageRoute(builder: (_) => const SearchScreen());

            // Handling DetailScreen with arguments
              case '/detail':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => DetailScreen(
                    cardData: args['cardData'],
                    product: args['product'],
                  ),
                );

              default:
                return MaterialPageRoute(builder: (_) => const OnboardingScreen());
            }
          },
        );
      },
    );
  }
}
