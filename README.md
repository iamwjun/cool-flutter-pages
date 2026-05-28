# cool_pages

一个用于沉淀 Flutter 页面效果和交互实验的示例项目。

## 常用 Flutter 命令

### 环境检查

```sh
flutter doctor
flutter --version
```

### 依赖管理

```sh
flutter pub get
flutter pub upgrade
flutter pub outdated
```

### 本地运行

```sh
flutter run
flutter run -d chrome
flutter devices
```

### 代码质量

```sh
dart format lib test
flutter analyze
flutter test
flutter test --coverage
```

### 构建发布包

```sh
flutter build apk
flutter build appbundle
flutter build ios
flutter build web
flutter build macos
flutter build windows
flutter build linux
```

### 清理与修复

```sh
flutter clean
flutter pub get
flutter pub cache repair
```

## 项目结构

```text
lib/main.dart                 # 应用入口
lib/core/theme/               # 主题配置
lib/features/                 # 页面与功能模块
test/                         # Widget 测试
android/ ios/ macos/ linux/ windows/ web/  # 平台工程
```

## 开发建议

- 修改依赖后运行 `flutter pub get`。
- 提交前运行 `dart format lib test`、`flutter analyze` 和 `flutter test`。
- 平台目录通常只在需要原生能力或平台配置时修改。
