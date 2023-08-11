
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticService{
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalytics() => FirebaseAnalyticsObserver(analytics: _analytics);
}