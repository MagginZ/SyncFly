# SyncFly

离线前庭安抚应用：在飞机起降等阶段通过**视觉流场**提供前庭补偿感，并预留**触觉节奏**与**环境白噪音**能力。数据与核心逻辑可完全本地运行，不依赖网络。

## 方案概述

| 维度 | 说明 |
|------|------|
| **目标** | 减轻晕机/前庭不适：用可预测的动态视觉引导，配合可选触觉与音频 |
| **客户端** | Flutter（iOS / Android / 桌面 / Web 等多平台工程已生成，主场景以移动端为主） |
| **状态** | [Riverpod](https://riverpod.dev) 管理会话与设置 |
| **模型** | [Freezed](https://pub.dev/packages/freezed) 不可变领域模型，需代码生成 |
| **媒体** | [audioplayers](https://pub.dev/packages/audioplayers) 播放 `assets/audio/` 下资源 |

架构上分为 **domain**（阶段、调参、设置）、**application**（会话控制器）、**presentation**（全屏流场与 UI）、**services**（音频、触觉调度）、**platform**（原生通道封装）。

## 目录结构

```
SyncFly/
├── lib/
│   ├── main.dart                 # 入口，ProviderScope
│   ├── app.dart                  # MaterialApp、主题、首页
│   ├── application/             # 应用层：会话控制器、providers
│   ├── core/                    # 主题、工具（如 lerp）
│   ├── domain/                  # 领域模型：起降阶段、会话设置（含 *.freezed.dart）
│   ├── presentation/            # 页面与组件：流场绘制、粒子、引导条等
│   ├── services/                # 音频、触觉（含平台实现）
│   └── platform/                # MethodChannel 等
├── assets/audio/                # 音频资源（pubspec 已声明）
├── android/ / ios/ / macos/ …   # 各平台原生工程
├── test/                        # 单元 / Widget 测试
├── pubspec.yaml
└── README.md
```

修改 `lib/domain` 下带 `@freezed` 的源码后，需重新生成 `*.freezed.dart`（见下文「代码生成」）。

## 环境要求

- **Flutter**：建议使用与项目 `environment.sdk: ^3.11.0` 匹配的 Flutter 版本（`flutter --version` 中 Dart ≥ 3.11）。
- 若 `flutter pub get` 提示 SDK 版本不符，请先执行 `flutter upgrade` 或使用 [FVM](https://fvm.app) 固定 Flutter 版本。

## 运行

```bash
cd /path/to/SyncFly
flutter pub get
```

若刚拉仓库或改过 Freezed 模型：

```bash
dart run build_runner build --delete-conflicting-outputs
```

开发运行（自动选已连接设备或模拟器）：

```bash
flutter run
```

指定设备：

```bash
flutter devices
flutter run -d <设备ID>
```

运行测试：

```bash
flutter test
```

## 打包

**Android APK（通用 release 单包）：**

```bash
flutter build apk
```

产物：`build/app/outputs/flutter-apk/app-release.apk`

**按 CPU 架构分包（体积更小）：**

```bash
flutter build apk --split-per-abi
```

**Google Play 上架用 AAB：**

```bash
flutter build appbundle
```

**iOS（需在 macOS + Xcode）：**

```bash
flutter build ipa
```

发布前请在各平台工程中配置**签名、包名、权限**与商店要求；本 README 不替代各应用商店与原生打包文档。
