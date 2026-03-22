import 'package:flutter/material.dart';
import '../widgets/about_app_bar.dart';
import '../widgets/app_logo_header.dart';
import '../widgets/mission_section.dart';
import '../widgets/key_features_section.dart';
import '../widgets/conservation_partner_section.dart';
import '../widgets/contact_us_section.dart';
import '../widgets/about_footer.dart';

/// The main entry point for the "About Us" page.
/// Orchestrates various sections to provide a comprehensive overview of WildX.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Light greenish-grey background to match the nature theme
      backgroundColor: Color(0xFFF0F7F4),
      appBar: AboutAppBar(),
      body: SingleChildScrollView(
        // Ensures the screen is scrollable on smaller devices or when content overflows
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppLogoHeader(),
            SizedBox(height: 14), // Consistent spacing between sections
            MissionSection(),
            SizedBox(height: 14),
            KeyFeaturesSection(),
            SizedBox(height: 14),
            ConservationPartnerSection(),
            SizedBox(height: 14),
            ContactUsSection(),
            SizedBox(height: 20),
            AboutFooter(),
            SizedBox(height: 24), // Bottom padding for a clean finish
          ],
        ),
      ),
    );
  }
}