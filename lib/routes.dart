import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/profile.dart';
import 'screens/menu.dart';
import 'screens/explore.dart';
import 'screens/rewards.dart';
import 'screens/password_recover.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const WelcomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/menu': (context) => const MenuScreen(),
  '/explore': (context) => const ExploreScreen(),
  '/rewards': (context) => const RewardsScreen(),
  '/password_recover': (context) => const PasswordRecoverScreen(),

};
