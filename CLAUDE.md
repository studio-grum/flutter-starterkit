# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 명령어

```bash
# 의존성 설치
flutter pub get

# 코드 생성 (riverpod_generator)
dart run build_runner build --delete-conflicting-outputs

# 코드 생성 감시 모드
dart run build_runner watch --delete-conflicting-outputs

# 정적 분석
flutter analyze

# 테스트 실행
flutter test

# 단일 테스트 실행
flutter test test/path/to/test_file.dart

# 실행
flutter run -d android
flutter run -d ios
```

---

## 아키텍처

### 레이어 구조 (feature-first)

모든 기능은 `lib/features/<feature>/` 아래에 세 레이어로 분리된다.

```
features/<feature>/
├── data/         # 외부 서비스 구현체 (Supabase, RevenueCat 등)
├── domain/       # abstract interface class — 테스트 · 교체 시 이곳만 의존
└── presentation/ # Riverpod Provider/Notifier + Flutter 위젯
```

공유 자원은 `lib/shared/`, 앱 전역 설정은 `lib/core/`에 둔다.

### 상태 관리 (Riverpod)

Provider 계층 규칙:
- **`Provider`**: 순수 의존성 주입 (Repository, SupabaseClient 등)
- **`StreamProvider`**: 실시간 스트림 구독 (`authStateProvider` — Supabase auth 상태)
- **`FutureProvider`**: 단순 비동기 조회 (`offeringsProvider`, `customerInfoProvider`)
- **`AsyncNotifier`**: 사용자 액션이 있는 뮤테이션 (`AuthNotifier`, `PaywallNotifier`)

`AsyncValue.guard()`로 에러를 래핑하는 것이 이 코드베이스의 표준 패턴이다.

```dart
state = const AsyncLoading();
state = await AsyncValue.guard(() => repository.someAction());
```

### 라우팅 (GoRouter)

`lib/router/app_router.dart`의 `routerProvider`가 `authStateProvider`를 `ref.watch`해서 인증 상태 변경 시 자동으로 redirect한다. 라우트 경로 상수는 모두 `AppConstants`(`lib/core/constants/app_constants.dart`)에 정의되어 있다.

화면 간 데이터 전달은 `context.push(route, extra: data)`로 하고, 수신 측은 `state.extra as Type`으로 꺼낸다.

### 외부 서비스 초기화

`main.dart`에서 `Supabase.initialize()` → `Purchases.configure()` 순서로 초기화한 뒤 `ProviderScope`를 감싼다. 두 서비스 모두 `.env`에서 키를 읽는다 (`flutter_dotenv`).

`SupabaseClient` 인스턴스는 `supabaseClientProvider`(`lib/shared/providers/supabase_provider.dart`)로 전역 주입한다.

### 예외 처리

`lib/core/errors/app_exception.dart`에 계층 정의:
- `AppException` — 기본 클래스
- `AppAuthException` — 인증 오류 (`SupabaseAuthRepository`에서 `supa.AuthException`을 변환)
- `PurchaseException` — 결제 오류
- `NetworkException` — 네트워크 오류

`supabase_flutter`의 `AuthException`과 이름이 충돌하므로 `supabase_auth_repository.dart`에서 `hide AuthException` + `as supa` alias를 사용한다.

### 애니메이션 패턴

- **`flutter_animate`**: 위젯에 `.animate().fadeIn().slideY()` 체이닝으로 마이크로 애니메이션 적용
- **`LottieWidget`** (`lib/shared/widgets/lottie_widget.dart`): `.json` 파일용 래퍼, `assets/lottie/`에 배치
- **`RiveWidget`** (`lib/shared/widgets/rive_widget.dart`): `.riv` 파일 + 상태머신 래퍼, `assets/animations/`에 배치

### 미디어

- **동영상**: `VideoPlayerController.networkUrl()` + `ChewieController` 조합
- **오디오**: `just_audio`의 `AudioPlayer`로 스트리밍/로컬 재생; 백그라운드 재생이 필요하면 `audio_service` 연동

### RevenueCat API 주의사항

`purchases_flutter ^10.x`에서 구매 API가 변경되었다.

```dart
// 올바른 방법 (v10+)
await Purchases.purchase(PurchaseParams.package(package));

// 폐기된 방법 — 사용 금지
await Purchases.purchasePackage(package);
```

entitlement ID는 `AppConstants.entitlementPremium`(`'premium'`)으로 중앙 관리한다.
