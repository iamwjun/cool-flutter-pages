lib/
 ├── main.dart
 │
 ├── core/                // 核心能力（全局）
 │    ├── router/         // 路由系统
 │    ├── network/        // 请求封装（类似 axios）
 │    ├── theme/          // 主题
 │    └── constants/      // 常量
 │
 ├── features/            // 按业务拆分（类似前端模块）
 │    ├── home/
 │    │    ├── pages/
 │    │    │    └── home_page.dart
 │    │    ├── widgets/
 │    │    ├── models/
 │    │    └── services/
 │    │
 │    └── detail/
 │         ├── pages/
 │         ├── widgets/
 │         └── services/
 │
 ├── shared/              // 全局复用组件
 │    ├── widgets/
 │    └── utils/
 │
 └── l10n/                // 国际化（可选）
