---
name: billing-invoice
description: Manages client billing, worklogs, and invoices. Automates calculating billable hours, generating audit-ready PDF/Markdown invoices, and tracking accounts receivable across clients.
---

# Billing & Invoicing Management Skill

This skill scaffolds and orchestrates a complete client billing suite powered by declarative data collections:
1. **`clients`**: Customer roster, billing addresses, currency, and tax IDs.
2. **`worklog`**: Time-tracking ledger capturing project hours, hourly rates, and deliverables.
3. **`profile`**: User/company billing profile (company name, registration number, bank remittance details).
4. **`invoice`**: Invoice ledger linking client records to line items with automatic subtotal, tax rate, and total computations.

## Architecture & Data Flow

```text
[worklog items] ──(aggregate billable hours)──► [invoice line items]
                                                        │
[clients items] ──(client address & tax ID)────► [rendered invoice PDF / MD]
                                                        ▲
[profile items] ──(bill-from company & bank)────────────┘
```

## Core Workflows

### 1. Worklog Ingestion & Billing Rollup
- Query unbilled entries in `data/worklog/items/` for a specific client and date range.
- Aggregate hours, multiply by agreed rates, and compute line items.

### 2. Invoice Generation & Tax Compliance
- Create a new record in `data/invoice/items/INV-YYYY-XXXX.json`.
- Populate line items, apply local tax rates (e.g. Japanese 10% consumption tax with Qualified Invoice T-number, European VAT, or US Sales Tax).
- Generate a printable HTML or Markdown invoice under `artifacts/documents/invoices/`.

### 3. Payment Status & Aging Tracking
- Track status flags (`Draft`, `Sent`, `Paid`, `Overdue`).
- Provide aging summary reports on outstanding receivables.
