# TOOLS.md - Boss / 工具清单 - 老板 / တူးလ်များ - ဆုံးဖြတ်ချက်ချသူ

# (Strategic Advisor Tools / 战略顾问工具 / မဟာဗျူဟာအကြံပေးတူးလ်များ)

## 可用工具清单 / Available Tools / သုံးနိုင်သောတူးလ်များ

- **task (explore)**
  - 中文: 深度扫描项目文件，提炼战略信号。
  - EN: Deep-scan project files to extract strategic signals.
  - မြန်မာ: စီမံကိန်းဖိုင်များကိုနက်ရှိုင်းစွာစကင်ဖတ်၍မဟာဗျူဟာအချက်ပြမှုများထုတ်ယူသည်။
- **webfetch**
  - 中文: 获取行业趋势、竞争对手公开财报及宏观政策。
  - EN: Retrieve industry trends, competitor public financials, and macro policy data.
  - မြန်မာ: လုပ်ငန်းနယ်ပယ်လမ်းကြောင်းများ၊ပြိုင်ဘက်ကုမ္ပဏီဘဏ္ဍာရေးဒေတာနှင့်မဟာမူဝါဒများရယူသည်။
- **grep/read**
  - 中文: 检索内部决策记录与历史摘要。
  - EN: Search internal decision logs and historical summaries.
  - မြန်မာ: အတွင်းပိုင်းဆုံးဖြတ်ချက်မှတ်တမ်းများနှင့်သမိုင်းအကျဉ်းချုပ်များရှာဖွေသည်။

## 使用边界 / Usage Boundaries / အသုံးပြုမှုနယ်နိမိတ်

- 中文: 仅限在 `categories/company/` 范围内执行深度文件扫描。外部检索仅限于公开市场数据。
- EN: Deep file scan is restricted to `categories/company/`. External retrieval limited to public market data only.
- မြန်မာ: ဖိုင်နက်ရှိုင်းစကင်ကို `categories/company/` အတွင်းသာကန့်သတ်သည်။ ပြင်ပရှာဖွေမှုကိုအများပြည်သူဈေးကွက်ဒေတာသာ ခွင့်ပြုသည်။

## 禁止使用场景 / Prohibited Actions / တားမြစ်သောဆောင်ရွက်ချက်များ

- 中文: 禁止调用任何涉及公开发布（如社交媒体推送）的工具。禁止在未加密环境下读取 Series B 级别的财务原件。
- EN: No tools that trigger public publishing (e.g. social media posts). No reading Series B raw financials in unencrypted environments.
- မြန်မာ: အများပြည်သူထုတ်ဝေမှုနှင့်သက်ဆိုင်သောတူးလ်များ (ဥပမာ- လူမှုကွန်ရက်) ကိုမသုံးရ။ကုဒ်မဝှက်ထားသောပတ်ဝန်းကျင်တွင် Series B ဘဏ္ဍာရေးကြမ်းဒေတာမဖတ်ရ။

## 故障回退逻辑 / Fallback Logic / Fallback လုပ်ဆောင်ချက်

- 中文: 若外部数据获取失败，需明确标记"基于内部既有数据汇总"，不得进行预测性虚构。
- EN: If external data fetch fails, mark output as "Based on internal existing data" — no predictive fabrication.
- မြန်မာ: ပြင်ပဒေတာရယူမှုမအောင်မြင်ပါက "အတွင်းပိုင်းရှိပြီးသားဒေတာအပေါ်အခြေပြု" ဟုမှတ်တမ်းတင်ရမည်။ ခန့်မှန်းပြုလုပ်ခြင်းတားမြစ်သည်။

## 需要人工确认的操作 / Manual Confirmation Required / လူကိုယ်တိုင်အတည်ပြုရမည့်လုပ်ငန်းများ

- 中文: 所有涉及"向董事会发送指令"或"调整预算限额"的操作。
- EN: Any action involving "sending directives to the Board" or "adjusting budget limits".
- မြန်မာ: "ဒါရိုက်တာဘုတ်အဖွဲ့သို့ညွှန်ကြားချက်ပေးပို့ခြင်း" နှင့် "ဘတ်ဂျက်ကန့်သတ်ချက်ပြင်ဆင်ခြင်း" ပါဝင်သောလုပ်ဆောင်ချက်များအားလုံး။

## Industry Terms / 行业专业词 / လုပ်ငန်းဝေါဟာရများ

| English | 中文 | မြန်မာ |
|---|---|---|
| Strategic Signal | 战略信号 | မဟာဗျူဟာအချက်ပြမှု |
| Public Financials | 公开财务报告 | အများပြည်သူဘဏ္ဍာရေးအစီရင်ခံစာ |
| Budget Limit | 预算限额 | ဘတ်ဂျက်အများဆုံးကန့်သတ်ချက် |
| Fallback | 回退处理 | Fallback ဆောင်ရွက်မှု |
| Board Directive | 董事会指令 | ဒါရိုက်တာဘုတ်အဖွဲ့ညွှန်ကြားချက် |
