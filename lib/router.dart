import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/video_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_screen.dart';
import 'pages/create_cloth_page.dart';

CustomTransitionPage _getCustomTransitionPage(LocalKey key, Widget child) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      // position: Tween<Offset>(
      //   begin: const Offset(0, 1),
      //   end: Offset.zero,
      // ).animate(animation),
      position: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ).drive(
        Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ),
      ),
      child: child,
    ),
  );
}

var router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _getCustomTransitionPage(
        state.pageKey,
        const HomeScreen(),
      ),
      routes: [
        GoRoute(
          path: 'video',
          pageBuilder: (context, state) =>
              _getCustomTransitionPage(state.pageKey, const VideoPage()),
        ),
        GoRoute(
          path: 'create',
          // build with slide up animation
          pageBuilder: (context, state) =>
              _getCustomTransitionPage(state.pageKey, const CreateClothPage()),
          // builder: (context, state) => const CreateClothPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _getCustomTransitionPage(
        state.pageKey,
        const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => _getCustomTransitionPage(
        state.pageKey,
        const SignupPage(),
      ),
    ),
  ],
);
