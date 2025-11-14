// ==========================================
// File: lib/main.dart
// FIX: route to ReturnAssets (plural) at '/return-assets'
// ==========================================
import 'package:flutter/material.dart';

// ===== Lecturer =====
import 'package:asset_borrowing_system/lecturer/dashboard.dart' as lect;
import 'package:asset_borrowing_system/lecturer/login_screen.dart';
import 'package:asset_borrowing_system/lecturer/asset_list.dart';
import 'package:asset_borrowing_system/lecturer/lend_request.dart';
import 'package:asset_borrowing_system/lecturer/lender_history.dart';
import 'package:asset_borrowing_system/lecturer/profile.dart'
    show LecturerProfile;
import 'package:asset_borrowing_system/lecturer/setting.dart'
    as lecturer_setting;

// ===== Staff =====
import 'package:asset_borrowing_system/staff/dashboard.dart' as staff_dash;
import 'package:asset_borrowing_system/staff/login_screen.dart' as staff_login;
import 'package:asset_borrowing_system/staff/asset_list.dart' as staff_assets;
import 'package:asset_borrowing_system/staff/staff_history.dart'
    as staff_history;
import 'package:asset_borrowing_system/staff/profile.dart' show StaffProfile;
import 'package:asset_borrowing_system/staff/setting.dart' as staff_setting;
import 'package:asset_borrowing_system/staff/asset_details.dart'
    as staff_details; // NOTE: your file name is assetdetailpage.dart
import 'package:asset_borrowing_system/staff/add_asset.dart'
    as staff_add; // NOTE: your file name is addasset.dart
import 'package:asset_borrowing_system/staff/edit_asset.dart' as staff_edit;
import 'package:asset_borrowing_system/staff/return_asset.dart'
    as staff_return; // FIX: import returnasset.dart (class ReturnAssets)

// ===== Student =====
import 'package:asset_borrowing_system/student/login_screen.dart'
    as student_login;
import 'package:asset_borrowing_system/student/register_screen.dart'
    as student_register;
import 'package:asset_borrowing_system/student/asset_list.dart'
    as student_assets;
import 'package:asset_borrowing_system/student/borrower_history.dart'
    as student_history;
import 'package:asset_borrowing_system/student/borrow_request.dart'
    as student_requests;
import 'package:asset_borrowing_system/student/borrow_asset.dart'
    as student_borrow;
import 'package:asset_borrowing_system/student/profile.dart'
    show StudentProfile;
import 'package:asset_borrowing_system/student/setting.dart' as student_setting;
// ✅ ADD THIS IMPORT
import 'package:asset_borrowing_system/student/asset_menu.dart' as student_menu;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assets Borrowing System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0C1851),
        primaryColor: const Color(0xFF4169E1),
        useMaterial3: false,
      ),
      initialRoute: '/student-login',//Change this into /login for lecturer, /staff-login for staff, /student-login for student

      routes: {
        // ===== Lecturer =====
        '/login': (context) => const LecturerLoginScreen(),
        '/home': (context) => const lect.Dashboard(),
        '/assets': (context) => const LecturerAssetList(),
        '/history': (context) => const LenderHistory(),
        '/requests': (context) => const LendRequest(),
        '/lecturer-profile': (context) => const LecturerProfile(),
        '/lecturer-settings': (context) => const lecturer_setting.Setting(),

        // ===== Staff =====
        '/staff-login': (context) => const staff_login.StaffLoginScreen(),
        '/staff-home': (context) => const staff_dash.Dashboard(),
        '/staff-assets': (context) => const staff_assets.Asset_list(),
        '/staff-history': (context) => const staff_history.StaffHistory(),
        '/staff-profile': (context) => const StaffProfile(),
        '/staff-settings': (context) => const staff_setting.Setting(),
        '/asset-details': (context) => const staff_details.AssetDetailPage(),
        '/add-asset': (context) => const staff_add.AddAsset(),

        // FIX: correct return route to ReturnAssets (plural)
        '/return-assets': (context) => const staff_return.ReturnAssets(),

        '/edit-asset': (context) => const staff_edit.EditAsset(),

        // ===== Student =====
        '/student-login': (context) => const student_login.StudentLoginScreen(),
        '/student-register': (context) =>
            const student_register.StudentRegisterScreen(),
        '/student-assets': (context) => const student_assets.StudentAssetList(),
        '/student-history': (context) =>
            const student_history.BorrowerHistory(),
        '/student-requests': (context) =>
            const student_requests.StudentBorrowRequests(),
        '/student-borrow': (context) => const student_borrow.BorrowAssetPage(),
        '/student-profile': (context) => const StudentProfile(),
        '/student-settings': (context) => const student_setting.Setting(),
        // ✅ ADD THIS ROUTE
        '/student-asset-menu': (context) =>
            const student_menu.StudentAssetMenu(),
      },
    );
  }
}
