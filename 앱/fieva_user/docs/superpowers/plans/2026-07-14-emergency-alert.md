# Emergency Alert Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** When fire state changes to active, the user app triggers a phone-alarm-style alert, shows an emergency notification, and attempts to bring the app to the foreground.

**Architecture:** Flutter detects fire state transitions and calls a small `EmergencyAlertService`. Android native code owns alarm sound, repeated vibration, full-screen notification, and app foreground intent.

**Tech Stack:** Flutter MethodChannel, Kotlin `MainActivity`, Android notification/alarm/vibration APIs.

## Global Constraints

- Keep Firebase Functions unchanged.
- Avoid new Flutter dependencies for this small platform-specific behavior.
- Stop the native alarm when fire state becomes inactive.
- Android may block automatic foreground launch depending on notification/full-screen settings.

---

### Task 1: Flutter Emergency Alert Bridge

**Files:**
- Create: `lib/services/emergency_alert_service.dart`
- Create: `test/emergency_alert_service_test.dart`

**Interfaces:**
- Produces: `EmergencyAlertService.startFireAlert()` and `EmergencyAlertService.stopFireAlert()`.

- [ ] Add a MethodChannel wrapper with idempotent Dart calls.
- [ ] Test that start/stop invoke `startEmergencyAlert` and `stopEmergencyAlert`.

### Task 2: Fire State Wiring

**Files:**
- Modify: `lib/screens/map_screen.dart`

**Interfaces:**
- Consumes: `EmergencyAlertService.startFireAlert()` and `EmergencyAlertService.stopFireAlert()`.

- [ ] Start alert when `_applyFireSources()` transitions from no fire to fire.
- [ ] Stop alert when fire becomes inactive.
- [ ] Also start alert for foreground FCM fire message.

### Task 3: Android Native Alert

**Files:**
- Modify: `android/app/src/main/kotlin/com/fieva/fieva_app/MainActivity.kt`
- Modify: `android/app/src/main/AndroidManifest.xml`

**Interfaces:**
- Consumes MethodChannel `fieva/emergency_alert`.

- [ ] Add `USE_FULL_SCREEN_INTENT` permission.
- [ ] Add MethodChannel methods `startEmergencyAlert` and `stopEmergencyAlert`.
- [ ] Play looping alarm tone, repeat strong vibration, post high-priority full-screen notification, and attempt to foreground MainActivity.

### Task 4: Verification

- [ ] Run `flutter test`.
- [ ] Run `flutter build apk --debug`.
- [ ] Copy APK to `G:\내 드라이브\fieva_debug\fieva_user_debug_2026-07-14.apk`.
- [ ] Install to tablet if an authorized ADB device is connected.
