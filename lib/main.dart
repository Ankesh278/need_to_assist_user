import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:need_to_assist/providers/auth_provider.dart';
import 'package:need_to_assist/providers/location_provider.dart';
import 'package:need_to_assist/providers/navigation_provider.dart';
import 'package:need_to_assist/providers/onboarding_provider.dart';
import 'package:need_to_assist/providers/service_provider.dart';
import 'package:need_to_assist/providers/user_provider.dart';
import 'package:need_to_assist/push_notification_api.dart';
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
import 'package:need_to_assist/view/screens/search_screen.dart';
import 'package:need_to_assist/view/screens/service_detail.dart';
import 'package:need_to_assist/viewModel/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'core/config/firebase_options.dart';
import 'models/user_model.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('userBox');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushApi().initNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_)=>ProfileViewModel()),
        ChangeNotifierProvider(create: (_)=> LocationProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()..fetchCategories()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),
        ChangeNotifierProvider(create: (_)=> ServiceProvider())

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
          initialRoute: '/home',
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
                  builder: (_) => ServiceScreen(
                    selectedCategory: args['selectedCategory'],
                  ),
                );

              case '/map':
                 return MaterialPageRoute(
                  builder: (_) => MapSample()
                );
              case '/booking':
                return MaterialPageRoute(builder: (_) => const BookingScreen());

              case '/location_search':
                return MaterialPageRoute(builder: (_) => LocationSearch());

              case '/notification':
                return MaterialPageRoute(builder: (_) =>  NotificationScreen());

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
              case '/search':
                return MaterialPageRoute(builder: (_) =>  SearchScreen());
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
