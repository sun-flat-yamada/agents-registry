---
name: edgar-sec-filings
description: Retrieves, parses, and analyzes primary-source US SEC EDGAR regulatory filings (Forms 10-K, 10-Q, 8-K, Form 4, DEF 14A) for corporate equity and fundamental research.
---

# SEC EDGAR Financial Filings Analysis Skill

This skill interfaces with the United States Securities and Exchange Commission (SEC) EDGAR system to search, extract, and dissect regulatory corporate filings for listed public companies.

## Supported Filing Types
- **Form 10-K (Annual Report)**: Audited financial statements, Item 1A Risk Factors, Item 7 MD&A (Management's Discussion & Analysis), segment revenue breakdown.
- **Form 10-Q (Quarterly Report)**: Unaudited quarterly figures, sequential quarter-over-quarter revenue/margin comparisons.
- **Form 8-K (Current Events)**: Material corporate announcements, executive turnover, M&A transactions.
- **Form 4 (Insider Transactions)**: Purchases, sales, and option exercises by corporate officers and directors.
- **DEF 14A (Proxy Statement)**: Executive compensation, board composition, and shareholder voting matters.

## Operating Principles
- **Cite Primary Sources**: Always state the exact form, fiscal period, filing date, and item section. Never paraphrase figures without citation.
- **Currency & Metric Integrity**: Explicitly identify reporting currencies, GAAP vs. Non-GAAP adjustments, and year-over-year percentage variances.

## Core Workflows

### 1. Company Identifier & CIK Resolution
Resolve equity ticker symbols (e.g. `AAPL`, `NVDA`, `MSFT`) to their 10-digit Central Index Key (CIK) using SEC company tickers endpoints.

### 2. Filing Extraction
Query the SEC EDGAR company submissions API (`https://data.sec.gov/submissions/CIK{cik.padStart(10, '0')}.json`) to harvest accession numbers and filing documents.

### 3. Deep Analysis & Digest Generation
- Extract MD&A disclosures and highlight newly added risk factors between successive fiscal years.
- Structure financial data into tables or charts for executive research memos.
