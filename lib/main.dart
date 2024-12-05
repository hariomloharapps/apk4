import 'package:flutter/material.dart';
import 'package:gyrogame/screens/SubscriptionExpiredScreen.dart';
import 'package:gyrogame/screens/companion_profile_screen.dart';
import 'package:gyrogame/test/profile.dart';
import 'package:gyrogame/test/test.dart';
import 'package:gyrogame/util.dart';
import 'Onboarding/CompanionSetupScreen.dart';
import 'Onboarding/PersonalityTypeScreen.dart';
import 'Onboarding/RelationshipTypeScreen.dart';
import 'Onboarding/Setup/AccountScreen.dart';
import 'Onboarding/gender_selection_screen.dart';
import 'Onboarding/mainscreen.dart';
import 'Onboarding/name_input_screen.dart';
import 'Onboarding/verification/AdultRelationshipTypeScreen.dart';
import 'Onboarding/verification/AdultVerificationScreen.dart';
import 'Onboarding/verification/VerificationScreen.dart';
import 'Onboarding/verification/VerifyPhotoScreen.dart';
import 'database/database_helper.dart';
import 'screens/chat_screen.dart';
import 'theme.dart';
import 'package:gyrogame/config/global_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final globalState = GlobalState();
  await globalState.initialize();

  print('Main - Initial UserID: ${globalState.userId}');
  print('Main - Initial PersonalityID: ${globalState.personalityId}');

  final hasUserId = await globalState.hasUserId();
  print('Main - Has UserID stored: $hasUserId');

  if (globalState.userId == null) {
    print('Warning: UserID is null after initialization');
  }

  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  final GlobalState globalState = GlobalState();

  // Helper method to check if subscription is valid
  bool isSubscriptionValid() {
    if (!globalState.isSubscribed) return false;

    final endDate = globalState.subscriptionEndDate;
    if (endDate == null) return false;

    return endDate.isAfter(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          // First check if initial setup is completed
          if (globalState.initialSetupCompleted) {
            // If setup is done, check for userId
            if (globalState.userId != null) {
              print(globalState.userId);
              // Check subscription status before showing chat screen
              if (isSubscriptionValid()) {
                return ChatScreen();
              } else {
                return SubscriptionExpiredScreen();
              }
            } else {
              // User completed setup but needs verification
              return VerificationScreen();
            }
          }
          // If initial setup is not completed, show onboarding
          return OnboardingScreen();
        },
      ),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/gender': (context) => const GenderTraitsScreen(),
        '/name': (context) => const NameInputScreen(),
        '/rela': (context) => const RelationshipTypeScreen(),
        '/PersonalityTypeScreen': (context) => const PersonalityTypeScreen(),
        '/verify-photo': (context) => const VerifyPhotoScreen(),
        '/adult-verification': (context) => const AdultVerificationScreen(),
        '/chat': (context) {
          // Also check subscription status when accessing chat via named route
          if (isSubscriptionValid()) {
            return ChatScreen();
          } else {
            return SubscriptionExpiredScreen();
          }
        },
        '/AdultRelationshipType': (context) => AdultPersonalityTypeScreen(),
        '/setup-account': (context) => AccountSetupScreen(),
        '/verification': (context) => VerificationScreen(),
        '/expire_subscription': (context) => SubscriptionExpiredScreen(),
      },
    );
  }
}