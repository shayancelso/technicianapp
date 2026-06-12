import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/punch/presentation/screens/punch_in_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/work_order/presentation/screens/work_order_list_screen.dart';
import '../../features/work_order/presentation/screens/work_order_detail_screen.dart';
import '../../features/work_order/presentation/screens/change_status_screen.dart';
import '../../features/team/presentation/screens/add_member_screen.dart';
import '../../features/team/presentation/screens/remove_member_screen.dart';
import '../../features/team/presentation/screens/view_team_screen.dart';
import '../../core/widgets/app_shell.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    // ── Auth routes (NO bottom nav) ──
    GoRoute(
      path: RouteNames.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: RouteNames.punchIn,
      name: 'punchIn',
      builder: (context, state) => const PunchInScreen(),
    ),

    // ── Shell route (persistent bottom nav) ──
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: RouteNames.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: RouteNames.profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: RouteNames.changePassword,
          name: 'changePassword',
          builder: (context, state) => const ChangePasswordScreen(),
        ),
        GoRoute(
          path: '${RouteNames.workOrderList}/:type',
          name: 'workOrderList',
          builder: (context, state) => WorkOrderListScreen(
            woType: state.pathParameters['type'] ?? 'rm',
            isHistory: state.uri.queryParameters['history'] == 'true',
          ),
        ),
        GoRoute(
          path: '${RouteNames.workOrderDetail}/:id',
          name: 'workOrderDetail',
          builder: (context, state) => WorkOrderDetailScreen(
            workOrderId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: '${RouteNames.changeStatus}/:id',
          name: 'changeStatus',
          builder: (context, state) => ChangeStatusScreen(
            workOrderId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: RouteNames.addMember,
          name: 'addMember',
          builder: (context, state) => const AddMemberScreen(),
        ),
        GoRoute(
          path: RouteNames.removeMember,
          name: 'removeMember',
          builder: (context, state) => const RemoveMemberScreen(),
        ),
        GoRoute(
          path: RouteNames.viewTeam,
          name: 'viewTeam',
          builder: (context, state) => const ViewTeamScreen(),
        ),
      ],
    ),
  ],
);
