# App Store 審核回覆範本

以下內容貼到 **App Store Connect → App Review Information → Notes** 欄位

---

## 回覆審核團隊（複製貼上以下全文）

Dear App Review Team,

Thank you for reviewing Good Baby Life. Below is all the requested information:

**1. Screen Recording**
A screen recording will be attached demonstrating the complete user flow:
- App launch → Dashboard (today's summary with stats cards and timeline)
- Tab: Milk Tracker → Select milk type (breast/formula/mixed) → Adjust amount (ml) → Set duration → Save record
- Tab: Food Tracker → Select food category → Enter food name → Adjust portion → Select baby's reaction emoji → Save record
- Tab: Tips → Browse parenting advice cards
- Return to Dashboard to see updated statistics and timeline

**2. App Purpose**
Good Baby Life is a baby feeding tracker designed for new parents. It solves the problem of keeping accurate records of an infant's daily milk intake and solid food introduction. Parents can:
- Track breast milk, formula, and mixed feeding (amount in ml, duration, time)
- Record solid food trials with baby's reaction (love/like/neutral/dislike/refuse) to help identify food preferences and potential allergies
- View daily statistics (total milk intake, feeding count, last feed time)
- Read 15 curated parenting tips about feeding techniques, food introduction, and allergy awareness

The app provides value by helping parents maintain accurate feeding logs for pediatrician visits and by reducing the mental load of remembering feeding details during the exhausting newborn period.

**3. Instructions for Review**
- This app does NOT require any login, registration, or account creation.
- No demo account is needed — all features are available immediately upon launch.
- Simply launch the app and use the bottom tab bar to navigate between Dashboard, Milk Tracker, Food Tracker, and Tips.
- To test: Go to "Milk" tab → tap a milk type → adjust amount → tap "Save". The record will appear on the Dashboard timeline.
- All data is stored locally on the device using JSON files.

**4. External Services**
This app does NOT use any external services, APIs, data providers, authentication services, payment processors, AI services, or third-party SDKs. All functionality is entirely self-contained and runs offline on the user's device.

**5. Regional Differences**
The app functions consistently across all regions. There are no regional differences in features or content. The interface language is Traditional Chinese (繁體中文) and all content is static (built into the app).

**6. Regulated Industry**
This app does NOT operate in any regulated industry. It is a simple personal note-taking/logging tool for parents. It does not provide medical advice, diagnosis, or treatment recommendations. The parenting tips included are general knowledge and clearly presented as suggestions, not medical guidance.

**Regarding the automated login detection:**
This app does NOT include any login, registration, or account-based features. There is no login screen, no user accounts, and no authentication of any kind. The app is fully functional immediately upon launch with no sign-in required. The automated detection may have been triggered by the form-style UI elements (text fields, buttons) used for recording feeding data, but these are data entry forms, not login forms.

Thank you for your time. Please let me know if any additional information is needed.

Best regards

---

## 操作步驟

### Step 1：回覆審核

1. 前往 [App Store Connect](https://appstoreconnect.apple.com)
2. 點選你的 App → **App Review** （或在通知中點 "Reply"）
3. 在 **Resolution Center** 點「Reply」
4. 把上面的英文回覆全文貼上
5. 附上一段螢幕錄影（見 Step 2）

### Step 2：錄製螢幕影片

在你的 iPhone 上操作：

1. **打開設定** → 控制中心 → 確認「螢幕錄製」已開啟
2. 從右上角往下滑，點 **錄影按鈕**（圓圈圖示）
3. 錄製以下流程（約 60-90 秒即可）：
   - 從主畫面點開 Good Baby Life App
   - 在首頁看一下儀表板
   - 切到 **喝奶** 頁面 → 選配方奶 → 調奶量 → 按儲存
   - 切到 **副食品** 頁面 → 選食物 → 選反應表情 → 按儲存
   - 切到 **建議** 頁面 → 滑動瀏覽
   - 回到 **首頁** 看到更新的統計
4. 停止錄影，把影片附在回覆中

### Step 3：更新 App Review Information

在 App Store Connect → 你的 App → **App Review Information** 區段：

- **Sign-In Required**: 選 **No**
- **Notes**: 貼上上面的完整回覆文字
- **Contact Information**: 填入你的聯絡資訊

### Step 4：重新提交

確認以上都填好後，點 **Submit for Review** 重新送審。

---

## 常見 Q&A

**Q: 需要重新 Archive 上傳嗎？**
A: 不需要！同一個 build 可以重新送審，只需要在 Resolution Center 回覆並更新 Notes。

**Q: 審核大約要多久？**
A: 補充資訊後通常 24-48 小時內會有回覆。

**Q: 影片格式有要求嗎？**
A: iPhone 內建錄製的 .mov 或 .mp4 都可以，不需要剪輯，完整錄製即可。
