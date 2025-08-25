import 'package:flutter/material.dart';
import '../presentation/chat_conversation_screen/chat_conversation_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/chat_list_screen/chat_list_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/contact_selection_screen/contact_selection_screen.dart';
import '../presentation/group_chat_creation_screen/group_chat_creation_screen.dart';
import '../presentation/privacy_settings_screen/privacy_settings_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String chatConversation = '/chat-conversation-screen';
  static const String splash = '/splash-screen';
  static const String login = '/login-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String chatList = '/chat-list-screen';
  static const String registration = '/registration-screen';
  static const String contactSelection = '/contact-selection-screen';
  static const String groupChatCreation = '/group-chat-creation-screen';
  static const String privacySettings = '/privacy-settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    chatConversation: (context) => const ChatConversationScreen(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    chatList: (context) => const ChatListScreen(),
    registration: (context) => const RegistrationScreen(),
    contactSelection: (context) => const ContactSelectionScreen(),
    groupChatCreation: (context) => const GroupChatCreationScreen(),
    privacySettings: (context) => const PrivacySettingsScreen(),
    // TODO: Add your other routes here
  };
}
