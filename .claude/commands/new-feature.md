# New Feature Scaffold

주어진 feature 이름으로 `data / domain / presentation` 세 레이어 파일을 한 번에 생성합니다.

## 사용법

```
/new-feature <feature_name>
```

**예시**

```
/new-feature profile
/new-feature notification
/new-feature settings
```

`feature_name`은 소문자 snake_case로 입력합니다 (예: `user_profile`, `push_notification`).

---

## 실행 지침

아래 지침을 **정확히** 따라 `$ARGUMENTS` 를 feature 이름으로 사용하여 파일을 생성하세요.

`feature_name` = `$ARGUMENTS` (snake_case, 예: `profile`)
`FeatureName` = PascalCase 변환 (예: `Profile`)

---

### 생성할 파일 목록

#### 1. `lib/features/<feature_name>/domain/<feature_name>_repository.dart`

```dart
abstract interface class <FeatureName>Repository {
  // TODO: 이 feature에 필요한 메서드를 정의하세요
  // 예시:
  // Future<List<Entity>> getAll();
  // Future<Entity> getById(String id);
  // Future<void> create(Entity entity);
  // Future<void> update(Entity entity);
  // Future<void> delete(String id);
}
```

#### 2. `lib/features/<feature_name>/data/<feature_name>_repository_impl.dart`

```dart
import '../domain/<feature_name>_repository.dart';

class <FeatureName>RepositoryImpl implements <FeatureName>Repository {
  const <FeatureName>RepositoryImpl();

  // TODO: domain 인터페이스의 메서드를 구현하세요
}
```

#### 3. `lib/features/<feature_name>/presentation/<feature_name>_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/<feature_name>_repository_impl.dart';
import '../domain/<feature_name>_repository.dart';

final <featureName>RepositoryProvider = Provider<<FeatureName>Repository>(
  (_) => const <FeatureName>RepositoryImpl(),
);

// 상태가 단순 조회라면 FutureProvider, 뮤테이션이 있다면 AsyncNotifier를 사용하세요.
//
// [FutureProvider 예시]
// final <featureName>ListProvider = FutureProvider((ref) {
//   return ref.watch(<featureName>RepositoryProvider).getAll();
// });
//
// [AsyncNotifier 예시]
// class <FeatureName>Notifier extends AsyncNotifier<void> {
//   @override
//   Future<void> build() async {}
//
//   Future<void> someAction() async {
//     state = const AsyncLoading();
//     state = await AsyncValue.guard(
//       () => ref.read(<featureName>RepositoryProvider).someAction(),
//     );
//   }
// }
//
// final <featureName>NotifierProvider =
//     AsyncNotifierProvider<<FeatureName>Notifier, void>(<FeatureName>Notifier.new);
```

#### 4. `lib/features/<feature_name>/presentation/<feature_name>_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_constants.dart';

class <FeatureName>Screen extends ConsumerWidget {
  const <FeatureName>Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('<FeatureName>'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: const Center(
          child: Text('<FeatureName> Screen'),
        ),
      ).animate().fadeIn(duration: AppConstants.defaultAnimationDuration),
    );
  }
}
```

---

### 파일 생성 후 안내 메시지

파일 생성이 완료되면 다음을 출력하세요:

```
✅ '<feature_name>' feature 스캐폴딩 완료

생성된 파일:
  lib/features/<feature_name>/domain/<feature_name>_repository.dart
  lib/features/<feature_name>/data/<feature_name>_repository_impl.dart
  lib/features/<feature_name>/presentation/<feature_name>_provider.dart
  lib/features/<feature_name>/presentation/<feature_name>_screen.dart

다음 단계:
  1. domain/<feature_name>_repository.dart 에 필요한 메서드 정의
  2. data/<feature_name>_repository_impl.dart 에 구현 작성
  3. presentation/<feature_name>_provider.dart 에 Provider/Notifier 완성
  4. router/app_router.dart 에 GoRoute 추가  (/new-route 커맨드 사용 가능)
  5. core/constants/app_constants.dart 에 라우트 경로 상수 추가
```
