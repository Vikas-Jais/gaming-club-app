import 'package:flutter/material.dart';
import 'admin_guard.dart';

// Screens
import 'screens/game_select.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/leaderboard.dart';
import 'screens/tournaments.dart';   // ✅ fixed file name
import 'screens/clans.dart';
import 'screens/live_stats.dart';
import 'screens/tournaments_bgmi.dart';
import 'screens/tournaments_valorant.dart';
import 'screens/valorant_search.dart';
import 'screens/valorant_connect.dart';
import 'screens/valorant_rank.dart';
import 'screens/valorant_history.dart';
import 'screens/valorant_live.dart';
import 'screens/valorant_agents.dart';
import 'screens/valorant_dashboard.dart';
import 'screens/valorant_leaderboard.dart'; // if you have it
import 'screens/valorant_matches.dart';



// Admin Screens
import 'screens/admin_panel.dart';
import 'screens/admin_users.dart';
import 'screens/admin_tournaments.dart';
import 'screens/admin_news.dart';
import 'screens/admin_settings.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginScreen(),
    '/home': (context) => const HomeScreen(),
    '/profile': (context) => const ProfileScreen(),
    '/leaderboard': (context) => const LeaderboardScreen(),
    '/tournaments': (context) => const TournamentScreen(), // ✅ class name
    '/clans': (context) => const ClansScreen(),
    '/live': (context) => const LiveStatsScreen(),
    '/game-select': (context) => const GameSelectScreen(),
    '/tournaments-bgmi': (context) => const BGMITournamentsScreen(),
    '/tournaments-valorant': (context) => const ValorantTournamentsScreen(),
    '/valorant-search': (context) => const ValorantSearchScreen(),
    '/valorant-connect': (context) => const ValorantConnectScreen(),
    '/valorant-rank': (context) => const ValorantRankScreen(),
    '/valorant-history': (context) => const ValorantHistoryScreen(),
    '/valorant-live': (context) => const ValorantLiveScreen(),
    '/valorant-agents': (context) => const ValorantAgentsScreen(),
    '/valorant-dashboard': (context) => const ValorantDashboardScreen(),
    '/valorant-leaderboard': (context) => const ValorantLeaderboardScreen(), // optional
    '/valorant-matches': (context) => const ValorantMatchesScreen(),





    // ✅ Admin routes protected by guard
    '/admin': (context) => const AdminGuard(child: AdminPanelScreen()),

    '/admin-users': (context) =>
        const AdminGuard(child: AdminUsersScreen()),

    '/admin-tournaments': (context) =>
        const AdminGuard(child: AdminTournamentsScreen()),

    '/admin-news': (context) =>
        const AdminGuard(child: AdminNewsScreen()),

    '/admin-settings': (context) =>
        const AdminGuard(child: AdminSettingsScreen()),
  };
}

