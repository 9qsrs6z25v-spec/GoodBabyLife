# Good Baby Life - 寶寶生活日誌

一個可愛的多平台寶寶生活日誌 App，使用 SwiftUI 打造，支援 iPhone、iPad、Apple Watch 和 Apple TV。

## 功能特色

### 🍼 喝奶紀錄
- 支援母乳、配方奶、混合三種類型
- 記錄奶量 (ml)、喝奶時長、時間
- 備註欄位記錄特別事項

### 🥣 副食品紀錄
- 六種食物分類：米糊、蔬菜泥、水果泥、蛋白質、粥品、其他
- 寶寶反應記錄：😍超愛 / 😊喜歡 / 😐普通 / 😣不愛 / 🙅拒吃
- 食物名稱與份量（湯匙）

### 🏠 首頁儀表板
- 今日統計（喝奶次數、副食品次數、總奶量、上次餵食時間）
- 時間軸顯示所有餵食紀錄
- 每日可愛小建議

### 💡 15 則可愛小建議
- 涵蓋喝奶技巧、副食品入門、過敏注意事項、爸媽自我照顧

## 支援平台

| 平台 | 最低版本 | 介面特色 |
|------|---------|---------|
| 📱 iPhone | iOS 17+ | 完整功能，Tab 導航 |
| 📱 iPad | iPadOS 17+ | 完整功能，寬螢幕最佳化 |
| ⌚ Apple Watch | watchOS 10+ | 快速記錄，精簡儀表板 |
| 📺 Apple TV | tvOS 17+ | 大螢幕儀表板，建議瀏覽 |

## 專案結構

```
GoodBabyLife/
├── Shared/                    # 共用代碼
│   ├── Models/
│   │   ├── MilkRecord.swift   # 喝奶紀錄模型
│   │   ├── FoodRecord.swift   # 副食品紀錄模型
│   │   ├── BabyTip.swift      # 可愛建議
│   │   └── DataStore.swift    # 資料管理（JSON 持久化）
│   ├── Views/
│   │   ├── ContentView.swift      # 主入口（平台路由）
│   │   ├── DashboardView.swift    # 首頁儀表板
│   │   ├── MilkTrackerView.swift  # 喝奶記錄頁
│   │   ├── FoodTrackerView.swift  # 副食品記錄頁
│   │   ├── TipsView.swift         # 建議列表
│   │   └── Components/
│   │       ├── StatCardView.swift
│   │       ├── TimelineItemView.swift
│   │       └── TipCardView.swift
│   └── Theme/
│       └── BabyTheme.swift    # 馬卡龍色系主題
├── iOS/
│   └── GoodBabyLifeApp.swift  # iOS/iPadOS 入口
├── watchOS/
│   ├── GoodBabyLifeWatchApp.swift  # watchOS 入口
│   ├── WatchContentView.swift
│   ├── WatchMilkView.swift
│   └── WatchFoodView.swift
├── tvOS/
│   ├── GoodBabyLifeTVApp.swift     # tvOS 入口
│   ├── TVContentView.swift
│   └── TVTipsView.swift
└── Package.swift
```

## Xcode 設定指南

1. 開啟 Xcode → File → New → Project
2. 選擇 **Multiplatform → App**
3. Product Name: `GoodBabyLife`
4. 將 `Shared/`、`iOS/`、`watchOS/`、`tvOS/` 資料夾拖入專案
5. 設定各 Target 的檔案歸屬：
   - **iOS Target**: `Shared/` + `iOS/`
   - **watchOS Target**: `Shared/` + `watchOS/`
   - **tvOS Target**: `Shared/` + `tvOS/`
6. 各平台最低部署版本：iOS 17、watchOS 10、tvOS 17

## 設計風格

- 粉紅 + 薰衣草 + 薄荷 馬卡龍粉嫩色系
- 可愛動畫效果（彈跳、脈動）
- 圓角卡片設計
- JSON 檔案持久化儲存
