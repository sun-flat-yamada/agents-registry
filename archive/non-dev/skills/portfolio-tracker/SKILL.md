---
name: portfolio-tracker
description: Scaffolds and manages an investment portfolio tracking system using a pair of declarative collections (`stock-quotes` and `portfolio`). Computes position values live via cross-collection lookups and market updates.
---

# Portfolio Tracker Skill

This skill scaffolds a dual-collection investment tracking system based on declarative data primitives:
1. **`stock-quotes`**: Market watchlist of equities, ETFs, and prices fetched from market feeds.
2. **`portfolio`**: User holdings (ticker + share count). Price and total value are computed live via cross-collection references (`portfolio.value = shares * ticker.price`).

## Architecture & Cross-Collection Lookups

```text
data/stock-quotes/items/<ticker>.json  <--- [Reference Lookup] --- data/portfolio/items/<id>.json
- price: $185.50                                                    - ticker: ref(stock-quotes)
- peRatio: 28.4                                                     - shares: 100
- change: +1.2%                                                     - totalValue: derived(shares * price)
```

## Setup Workflow

### 1. Scaffold `stock-quotes` Collection
Initialize `data/skills/stock-quotes/schema.json` with ticker, price, change, and yield columns.

### 2. Scaffold `portfolio` Collection
Initialize `data/skills/portfolio/schema.json` with holdings, purchase date, cost basis, and live derived valuation formulas.

### 3. Record Operations
- Add new ticker positions to `portfolio`.
- Refresh price quotes periodically or on demand.
- Generate allocation breakdown charts (e.g. tech vs. healthcare vs. cash) in chat.
