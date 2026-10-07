# Project 1: Support Data Extraction Pipeline (DecodeLabs)

An automated PowerShell-based support data extraction pipeline designed to parse unstructured customer support emails into deterministic, structured JSON output.

## Features & Edge-Case Defenses
- **Contact Phone Ownership Validation:** Filters out third-party contact numbers (e.g., relatives, friends, lawyers) to ensure `contact_phone` strictly belongs to the customer.
- **ID vs. Phone Disambiguation:** Differentiates reference/tracking IDs from valid telephone numbers.
- **Severity Overrides:** Hard-codes `severity_level = 5` for explicit legal threats (`lawyer`, `sue`), safety hazards, or urgent keywords regardless of issue scope.
- **Order Preservation:** Extracts order numbers exactly as formatted without silent auto-correction or illegal merging across multiple orders.
- **Emotional Inflation Filtering:** Ignores angry tone, all-caps, and excess punctuation to assign objective severity levels based strictly on issue impact.

## Repository Contents
- `Extract-SupportData.ps1`: Core PowerShell parsing engine and automated edge-case test suite.
- `output.json`: Generated JSON output containing structured test results.

## Execution
Run the pipeline in PowerShell:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\Extract-SupportData.ps1
