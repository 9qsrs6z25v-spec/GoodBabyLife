/* ============================================
   Good Baby Life - App Logic
   ============================================ */

// ---- Data Store ----
const STORAGE_KEYS = {
  MILK: 'goodbaby_milk',
  FOOD: 'goodbaby_food',
};

function loadRecords(key) {
  try {
    return JSON.parse(localStorage.getItem(key)) || [];
  } catch {
    return [];
  }
}

function saveRecords(key, records) {
  localStorage.setItem(key, JSON.stringify(records));
}

function getTodayStr() {
  return new Date().toISOString().slice(0, 10);
}

function getTodayRecords(records) {
  const today = getTodayStr();
  return records.filter(r => r.date === today);
}

// ---- Initialize ----
document.addEventListener('DOMContentLoaded', () => {
  setCurrentDate();
  setDefaultTimes();
  renderDashboard();
  renderMilkHistory();
  renderFoodHistory();
  renderTips();
  setDailyTip();
});

function setCurrentDate() {
  const now = new Date();
  const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
  document.getElementById('currentDate').textContent = now.toLocaleDateString('zh-TW', options);
}

function setDefaultTimes() {
  const now = new Date();
  const timeStr = now.toTimeString().slice(0, 5);
  document.getElementById('milkTime').value = timeStr;
  document.getElementById('foodTime').value = timeStr;
}

// ---- Tab Navigation ----
function switchTab(tabName) {
  document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  document.getElementById('tab-' + tabName).classList.add('active');
  document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');

  if (tabName === 'dashboard') renderDashboard();
  if (tabName === 'milk') { renderMilkHistory(); setDefaultTimes(); }
  if (tabName === 'food') { renderFoodHistory(); setDefaultTimes(); }
}

// ---- Milk Records ----
function addMilkRecord(e) {
  e.preventDefault();
  const type = document.querySelector('input[name="milkType"]:checked').value;
  const amount = parseInt(document.getElementById('milkAmount').value) || 0;
  const time = document.getElementById('milkTime').value;
  const duration = parseInt(document.getElementById('milkDuration').value) || 0;
  const note = document.getElementById('milkNote').value.trim();

  const typeLabels = { breast: '母乳', formula: '配方奶', mixed: '混合' };
  const typeEmojis = { breast: '🤱', formula: '🍼', mixed: '🥛' };

  const record = {
    id: Date.now(),
    date: getTodayStr(),
    time,
    type,
    typeLabel: typeLabels[type],
    typeEmoji: typeEmojis[type],
    amount,
    duration,
    note,
    category: 'milk',
  };

  const records = loadRecords(STORAGE_KEYS.MILK);
  records.unshift(record);
  saveRecords(STORAGE_KEYS.MILK, records);

  showToast('🍼 喝奶紀錄已儲存！');
  document.getElementById('milkNote').value = '';
  setDefaultTimes();
  renderMilkHistory();
  renderDashboard();
  return false;
}

function renderMilkHistory() {
  const records = loadRecords(STORAGE_KEYS.MILK);
  const todayRecords = getTodayRecords(records);
  const container = document.getElementById('milkHistory');

  if (todayRecords.length === 0) {
    container.innerHTML = `
      <div class="empty-state">
        <span class="empty-icon">🍼</span>
        <p>今天還沒有喝奶紀錄喔！</p>
      </div>`;
    return;
  }

  container.innerHTML = todayRecords.map(r => `
    <div class="history-item milk-item">
      <span class="history-icon">${r.typeEmoji}</span>
      <div class="history-info">
        <div class="history-title">${r.typeLabel} ${r.amount}ml</div>
        <div class="history-detail">${r.duration}分鐘${r.note ? ' · ' + r.note : ''}</div>
      </div>
      <span class="history-time">${r.time}</span>
      <button class="history-delete" onclick="deleteRecord('${STORAGE_KEYS.MILK}', ${r.id})" title="刪除">✕</button>
    </div>
  `).join('');
}

// ---- Food Records ----
function addFoodRecord(e) {
  e.preventDefault();
  const type = document.querySelector('input[name="foodType"]:checked').value;
  const name = document.getElementById('foodName').value.trim();
  const amount = parseInt(document.getElementById('foodAmount').value) || 0;
  const time = document.getElementById('foodTime').value;
  const reaction = document.querySelector('input[name="reaction"]:checked').value;
  const note = document.getElementById('foodNote').value.trim();

  const typeLabels = {
    rice_cereal: '米糊', veggie: '蔬菜泥', fruit: '水果泥',
    protein: '蛋白質', porridge: '粥品', other: '其他',
  };
  const typeEmojis = {
    rice_cereal: '🍚', veggie: '🥦', fruit: '🍎',
    protein: '🍗', porridge: '🥘', other: '🍽️',
  };
  const reactionLabels = {
    love: '😍 超愛', like: '😊 喜歡', ok: '😐 普通',
    dislike: '😣 不愛', refuse: '🙅 拒吃',
  };

  const record = {
    id: Date.now(),
    date: getTodayStr(),
    time,
    type,
    typeLabel: typeLabels[type],
    typeEmoji: typeEmojis[type],
    name: name || typeLabels[type],
    amount,
    reaction,
    reactionLabel: reactionLabels[reaction],
    note,
    category: 'food',
  };

  const records = loadRecords(STORAGE_KEYS.FOOD);
  records.unshift(record);
  saveRecords(STORAGE_KEYS.FOOD, records);

  showToast('🥣 副食品紀錄已儲存！');
  document.getElementById('foodName').value = '';
  document.getElementById('foodNote').value = '';
  setDefaultTimes();
  renderFoodHistory();
  renderDashboard();
  return false;
}

function renderFoodHistory() {
  const records = loadRecords(STORAGE_KEYS.FOOD);
  const todayRecords = getTodayRecords(records);
  const container = document.getElementById('foodHistory');

  if (todayRecords.length === 0) {
    container.innerHTML = `
      <div class="empty-state">
        <span class="empty-icon">🥣</span>
        <p>今天還沒有副食品紀錄喔！</p>
      </div>`;
    return;
  }

  container.innerHTML = todayRecords.map(r => `
    <div class="history-item food-item">
      <span class="history-icon">${r.typeEmoji}</span>
      <div class="history-info">
        <div class="history-title">${r.name} ${r.amount}湯匙</div>
        <div class="history-detail">${r.reactionLabel}${r.note ? ' · ' + r.note : ''}</div>
      </div>
      <span class="history-time">${r.time}</span>
      <button class="history-delete" onclick="deleteRecord('${STORAGE_KEYS.FOOD}', ${r.id})" title="刪除">✕</button>
    </div>
  `).join('');
}

// ---- Delete Record ----
let pendingDelete = null;

function deleteRecord(key, id) {
  pendingDelete = { key, id };
  document.getElementById('deleteModal').classList.add('show');
  document.getElementById('confirmDeleteBtn').onclick = confirmDelete;
}

function confirmDelete() {
  if (!pendingDelete) return;
  const records = loadRecords(pendingDelete.key);
  const updated = records.filter(r => r.id !== pendingDelete.id);
  saveRecords(pendingDelete.key, updated);
  closeDeleteModal();
  showToast('🗑️ 紀錄已刪除');
  renderMilkHistory();
  renderFoodHistory();
  renderDashboard();
}

function closeDeleteModal() {
  document.getElementById('deleteModal').classList.remove('show');
  pendingDelete = null;
}

// ---- Dashboard ----
function renderDashboard() {
  const milkRecords = getTodayRecords(loadRecords(STORAGE_KEYS.MILK));
  const foodRecords = getTodayRecords(loadRecords(STORAGE_KEYS.FOOD));
  const allRecords = [...milkRecords, ...foodRecords].sort((a, b) => {
    if (a.time < b.time) return 1;
    if (a.time > b.time) return -1;
    return b.id - a.id;
  });

  // Stats
  document.getElementById('todayMilkCount').textContent = milkRecords.length;
  document.getElementById('todayFoodCount').textContent = foodRecords.length;

  const totalMilk = milkRecords.reduce((sum, r) => sum + r.amount, 0);
  document.getElementById('todayMilkTotal').textContent = totalMilk + ' ml';

  const lastRecord = allRecords[0];
  document.getElementById('lastFeedTime').textContent = lastRecord ? lastRecord.time : '--:--';

  // Welcome message
  const msgs = getWelcomeMessage(milkRecords.length, foodRecords.length);
  document.getElementById('welcomeMsg').textContent = msgs;

  // Timeline
  const timelineEl = document.getElementById('timeline');
  if (allRecords.length === 0) {
    timelineEl.innerHTML = `
      <div class="empty-state">
        <span class="empty-icon">📝</span>
        <p>還沒有紀錄喔，快來記錄寶寶的第一餐吧！</p>
      </div>`;
    return;
  }

  timelineEl.innerHTML = allRecords.map(r => {
    if (r.category === 'milk') {
      return `
        <div class="timeline-item">
          <div class="timeline-icon milk">${r.typeEmoji}</div>
          <div class="timeline-info">
            <div class="timeline-title">${r.typeLabel} ${r.amount}ml</div>
            <div class="timeline-detail">${r.duration}分鐘${r.note ? ' · ' + r.note : ''}</div>
          </div>
          <span class="timeline-time">${r.time}</span>
        </div>`;
    } else {
      return `
        <div class="timeline-item">
          <div class="timeline-icon food">${r.typeEmoji}</div>
          <div class="timeline-info">
            <div class="timeline-title">${r.name} ${r.amount}湯匙</div>
            <div class="timeline-detail">${r.reactionLabel}${r.note ? ' · ' + r.note : ''}</div>
          </div>
          <span class="timeline-time">${r.time}</span>
        </div>`;
    }
  }).join('');
}

function getWelcomeMessage(milkCount, foodCount) {
  const total = milkCount + foodCount;
  if (total === 0) return '記錄寶寶美好的一天吧！';
  if (total <= 2) return '寶寶今天開始吃東西囉，繼續加油！';
  if (total <= 5) return '寶寶今天吃得不錯呢，真棒！';
  if (total <= 8) return '寶寶今天好認真吃飯，超乖的！';
  return '哇，寶寶今天食慾好好，是個小吃貨！';
}

// ---- Amount Adjustment ----
function adjustAmount(inputId, delta) {
  const input = document.getElementById(inputId);
  const min = parseInt(input.min) || 0;
  const max = parseInt(input.max) || 999;
  let val = parseInt(input.value) || 0;
  val = Math.max(min, Math.min(max, val + delta));
  input.value = val;
}

// ---- Toast ----
function showToast(message) {
  const toast = document.getElementById('toast');
  document.getElementById('toastMsg').textContent = message;
  toast.classList.add('show');
  setTimeout(() => toast.classList.remove('show'), 2500);
}

// ---- Tips ----
const TIPS = [
  {
    emoji: '🍼',
    title: '喝奶小知識',
    text: '新生兒每天大約需要喝 8-12 次奶，每次約 60-120ml。隨著寶寶長大，每次奶量會增加，但次數會減少喔！',
    category: 'milk',
  },
  {
    emoji: '🥣',
    title: '副食品開始時機',
    text: '一般建議寶寶在 4-6 個月大時開始嘗試副食品。觀察寶寶是否能穩定坐著、對食物表現出興趣，就可以慢慢開始囉！',
    category: 'food',
  },
  {
    emoji: '🌡️',
    title: '奶的溫度很重要',
    text: '配方奶的最佳溫度約 37-40°C，接近體溫最舒適。可以滴幾滴在手腕內側測試，感覺溫溫的就剛好！',
    category: 'milk',
  },
  {
    emoji: '🥕',
    title: '副食品循序漸進',
    text: '每次只嘗試一種新食物，觀察 3-5 天確認沒有過敏反應再換下一種。從米糊開始，再到蔬菜泥、水果泥！',
    category: 'food',
  },
  {
    emoji: '💤',
    title: '餵奶後拍嗝',
    text: '餵完奶後記得幫寶寶拍嗝喔！將寶寶直立靠在肩膀上，輕輕拍背部，可以減少脹氣和溢奶的情況。',
    category: 'milk',
  },
  {
    emoji: '🎨',
    title: '讓吃飯變有趣',
    text: '用色彩繽紛的食物吸引寶寶注意力！南瓜是橘色、菠菜是綠色、地瓜是黃色，讓每一餐都像在畫畫一樣有趣。',
    category: 'food',
  },
  {
    emoji: '😴',
    title: '睡前不要餵太飽',
    text: '睡前適量餵奶就好，太飽反而容易溢奶或不舒服。讓寶寶在舒適的狀態下入睡，睡眠品質會更好喔！',
    category: 'sleep',
  },
  {
    emoji: '💧',
    title: '開始喝水的時機',
    text: '6 個月以下的寶寶通常不需要額外喝水，母乳和配方奶已經含有足夠水分。開始吃副食品後可以少量給水。',
    category: 'general',
  },
  {
    emoji: '🦷',
    title: '長牙期的飲食',
    text: '寶寶長牙時可能會不太想吃東西，這是正常的！可以給冰涼的水果泥或咬咬樂來舒緩牙齦不適。',
    category: 'food',
  },
  {
    emoji: '📝',
    title: '記錄過敏反應',
    text: '嘗試新食物時，注意觀察寶寶是否有紅疹、腹瀉、嘔吐等過敏症狀。詳細記錄可以幫助醫生判斷過敏原喔！',
    category: 'food',
  },
  {
    emoji: '🤱',
    title: '母乳保存小技巧',
    text: '擠出的母乳在室溫下可保存 4 小時，冷藏可保存 4 天，冷凍可保存 6 個月。記得標註日期，先進先出！',
    category: 'milk',
  },
  {
    emoji: '🌟',
    title: '每個寶寶都不同',
    text: '不用和別的寶寶比較，每個孩子都有自己的成長節奏。有些寶寶愛吃，有些比較挑食，都是正常的喔！放輕鬆享受親子時光吧！',
    category: 'general',
  },
  {
    emoji: '🥄',
    title: '湯匙餵食技巧',
    text: '用小湯匙的前端輕輕放在寶寶下唇上，等寶寶自己張嘴再送入。不要硬塞喔，讓寶寶學習主動進食！',
    category: 'food',
  },
  {
    emoji: '⏰',
    title: '規律的餵食時間',
    text: '盡量建立規律的餵食時間表，寶寶的生理時鐘會慢慢調整，也更容易預測什麼時候會餓。但也不用太死板，看寶寶的需求調整！',
    category: 'general',
  },
  {
    emoji: '🧡',
    title: '爸媽也要照顧自己',
    text: '帶寶寶雖然辛苦，但記得也要好好休息、吃飯。只有爸媽身體健康、心情好，才能給寶寶最好的照顧喔！你們做得很棒！',
    category: 'general',
  },
];

function renderTips() {
  const container = document.getElementById('tipsContainer');
  container.innerHTML = TIPS.map(tip => `
    <div class="tip-card">
      <span class="tip-emoji">${tip.emoji}</span>
      <div class="tip-content">
        <div class="tip-title">${tip.title}</div>
        <p class="tip-text">${tip.text}</p>
        <span class="tip-category ${tip.category}">${getCategoryLabel(tip.category)}</span>
      </div>
    </div>
  `).join('');
}

function getCategoryLabel(category) {
  const labels = {
    milk: '🍼 喝奶',
    food: '🥣 副食品',
    sleep: '😴 睡眠',
    general: '💫 一般',
  };
  return labels[category] || category;
}

function setDailyTip() {
  const dayIndex = new Date().getDate() % TIPS.length;
  const tip = TIPS[dayIndex];
  document.getElementById('dailyTip').textContent = `${tip.emoji} ${tip.title}：${tip.text}`;
}
