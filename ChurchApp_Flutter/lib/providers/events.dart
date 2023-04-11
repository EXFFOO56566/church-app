import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

enum AppEvents {
  LOGOUT,
  ONCHATCONVERSATIONCLOSED,
  ONMESSAGE,
}
