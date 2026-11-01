# 🎟️ District Live Events & Dining: Dynamic Pricing Analytics & Checkout Attrition Diagnostics

### Nightlife, Live Entertainment & Premium Dining Ecosystem | Gurugram NCR

[![SQL](https://img.shields.io/badge/SQL-SQLite%20%7C%20PostgreSQL-blue)](https://www.sqlite.org/)
[![Python](https://img.shields.io/badge/Python-Pandas%20%7C%20NumPy-yellow)](https://www.python.org/)
[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)](https://powerbi.microsoft.com/)
[![Analytics](https://img.shields.io/badge/Analytics-Product%20Analytics-green)](https://en.wikipedia.org/wiki/Product_analytics)
[![Experimentation](https://img.shields.io/badge/A%2FB%20Testing-Hypothesis%20Testing-orange)](https://en.wikipedia.org/wiki/A/B_testing)

---

## 📌 1. Project Overview

This project presents an end-to-end commercial analytics framework designed to diagnose dynamic pricing inefficiencies and checkout abandonment across **District (by Eternal)**, focusing on the nightlife, live entertainment, and premium dining ecosystem in the Gurugram NCR market.

The analysis uses **10,000+ simulated transactional checkout sessions** across high-density lifestyle corridors, including:

- DLF CyberHub
- Golf Course Road
- Sector 29, Gurugram

On high-frequency entertainment and lifestyle commerce platforms, convenience fees, peak-hour reservation surcharges, and dynamic event-ticketing tiers can directly influence customer conversion and checkout abandonment.

The project investigates how pricing friction impacts booking completion and identifies opportunities to optimize GMV, conversion rates, and platform take-rate.

### 🎯 Primary Business Objectives

- Identify structural Gross Merchandise Value (GMV) leakage during high-demand booking periods.
- Analyze customer Willingness-to-Pay (WTP) thresholds and price elasticity.
- Identify pricing thresholds associated with increased checkout abandonment.
- Evaluate the commercial impact of capped dynamic pricing.
- Recommend operational guardrails to improve conversion without compromising platform revenue.

---

## 🔗 2. Live Interactive Power BI Dashboard

**[View Live Interactive Power BI Dashboard](PASTE_YOUR_POWER_BI_DASHBOARD_URL_HERE)**

*Replace the placeholder above with your published Power BI dashboard URL.*

---

## 🛠️ 3. Technology Stack

| Technology | Purpose |
|---|---|
| SQL (SQLite / PostgreSQL) | Transactional data extraction, checkout funnel segmentation, and cohort analysis |
| Python (Pandas, NumPy) | Data cleaning, transformation, and analytical processing |
| SciPy | Statistical hypothesis testing and experimentation |
| Power BI Desktop | Executive dashboard development and KPI visualization |
| DAX | Funnel attrition, conversion, and take-rate calculations |
| A/B Testing | Evaluation of capped-surcharge pricing strategies |
| Generative AI | Analytical validation, SQL edge-case checking, and documentation support |

---

## 📊 4. Dataset & Checkout Attrition Analysis

The project analyzes 10,000+ simulated checkout sessions segmented into three dynamic pricing cohorts.

The objective is to understand how increasing convenience fees and peak-demand surcharges influence customer booking decisions.

### Dynamic Pricing Cohorts

| Pricing Cohort | Surcharge Range | Checkout Attrition Rate | Business Interpretation |
|---|---:|---:|---|
| Low Baseline | ₹0–₹30 | 9.92% | High willingness-to-pay and relatively frictionless conversion |
| Medium Surge | ₹31–₹70 | 28.62% | Increasing pricing friction and competitive evaluation |
| Critical Peak | Above ₹70 | 59.92% | Significant checkout abandonment and conversion deterioration |

### Key Finding

Checkout abandonment increases sharply when dynamic surcharges exceed ₹70.

This indicates a potential psychological pricing threshold where customers become more sensitive to additional booking costs.

### Overall Platform Funnel Attrition

**33.47%**

Overall checkout abandonment across the 10,000 monitored simulated sessions.

---

## 📐 5. Funnel Attrition Methodology

Rather than relying on aggregate website visits, the analysis focuses on actual checkout attempts and their final purchase outcomes.

The funnel attrition rate is calculated as:

\[
\text{Attrition Rate} =
\frac{\text{Abandoned Checkout Sessions}}
{\text{Total Checkout Attempts}} \times 100
\]

Where:

- Total Checkout Attempts = All sessions reaching checkout.
- Abandoned Checkout Sessions = Sessions that did not complete payment.
- Successful Bookings = Sessions with confirmed transactions.

This approach helps identify the pricing cohorts responsible for the highest conversion leakage.

---

## 🧪 6. A/B Testing & Controlled Experimentation

A controlled A/B testing framework was designed to evaluate whether a capped-surcharge and transparent-pricing strategy could improve checkout conversion.

### Experiment Design

**Control Group (A)**

- Standard unconstrained dynamic surge pricing.
- Fees increase based on demand and booking traffic.
- No additional surcharge ceiling.

**Treatment Group (B)**

- Dynamic surcharge capped at ₹50.
- Transparent pricing breakdown displayed before checkout.
- Reduced exposure to unexpected booking fees.

### Experiment Results

| Metric | Control (A) | Treatment (B) |
|---|---:|---:|
| Pricing Strategy | Unconstrained Surge | Capped Surge |
| Sample Size | 5,000 | 5,000 |
| Conversion Rate | 35.0% | 49.2% |

### Statistical Analysis

| Statistical Metric | Result |
|---|---:|
| Control Conversion Rate | 35.0% |
| Treatment Conversion Rate | 49.2% |
| Absolute Conversion Lift | +14.2 percentage points |
| Relative Conversion Lift | +40.6% |
| Z-Statistic | 14.38 |
| Statistical Significance | p < 0.001 |
| 95% Confidence Interval | [12.28%, 16.12%] |

### Hypothesis Testing

**Null Hypothesis (H₀):** There is no statistically significant difference in conversion rates between the two pricing strategies.

**Alternative Hypothesis (H₁):** The capped-surcharge and transparent-pricing strategy improves checkout conversion.

**Inference:**

The observed conversion improvement of 14.2 percentage points is statistically significant (p < 0.001).

Therefore, the null hypothesis is rejected.

The simulated experiment indicates that reducing pricing friction can substantially improve checkout completion.

---

## 🛠️ 7. SQL Data Pipeline & Backend Extraction

SQL was used to transform raw checkout telemetry into actionable pricing cohorts and transactional funnel metrics.

### SQL: Dynamic Pricing Cohort Analysis

```sql
WITH parsed_bookings AS (
    SELECT
        session_id,
        user_id,
        event_or_restaurant_id,
        CAST(surge_fee_inr AS REAL) AS surge_fee,
        is_checkout_completed
    FROM raw_district_checkout_telemetry
),

surge_cohorts AS (
    SELECT
        session_id,
        is_checkout_completed,
        CASE
            WHEN surge_fee BETWEEN 0 AND 30
                THEN '01. Low Baseline Surge (0-30 INR)'

            WHEN surge_fee > 30 AND surge_fee <= 70
                THEN '02. Medium Surge (31-70 INR)'

            WHEN surge_fee > 70
                THEN '03. Critical Peak Surge (>70 INR)'

            ELSE 'Unclassified'
        END AS surge_tier
    FROM parsed_bookings
)

SELECT
    surge_tier,

    COUNT(session_id) AS total_checkout_attempts,

    SUM(
        CASE
            WHEN is_checkout_completed = 0 THEN 1
            ELSE 0
        END
    ) AS dropped_sessions,

    SUM(
        CASE
            WHEN is_checkout_completed = 1 THEN 1
            ELSE 0
        END
    ) AS successful_bookings,

    ROUND(
        SUM(
            CASE
                WHEN is_checkout_completed = 0 THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(COUNT(session_id), 0),
        2
    ) AS funnel_attrition_rate

FROM surge_cohorts

GROUP BY surge_tier

ORDER BY funnel_attrition_rate DESC;
```

### SQL Analysis Covers

- Checkout session segmentation.
- Dynamic pricing cohort classification.
- Successful booking identification.
- Abandoned session calculation.
- Cohort-wise checkout attrition.
- Pricing sensitivity analysis.

---

## 🔍 8. Critical Commercial Insights

### 1. The ₹70 Psychological Pricing Cliff

Checkout abandonment increases to 59.92% when surcharges exceed ₹70.

This suggests that customers become significantly more sensitive to additional booking costs during high-demand periods.

### 2. Medium-Tier Pricing Friction

Attrition rises from 9.92% to 28.62% in the medium surcharge cohort.

This represents an important leakage zone where customers may compare alternative platforms, direct bookings, or walk-in options.

### 3. Platform Revenue Leakage

Excessive convenience fees can negatively affect completed transactions.

The incremental fee revenue from higher surcharges may be outweighed by lost commission opportunities when customers abandon checkout.

### 4. Conversion Optimization Opportunity

The simulated A/B experiment demonstrates a 40.6% relative conversion improvement under the capped-surcharge strategy.

This highlights the commercial potential of transparent and predictable pricing.

---

## 🚀 9. Strategic Recommendations for District

| Recommendation | Proposed Action | Expected Business Benefit |
|---|---|---|
| Dynamic Surcharge Ceiling | Cap standard booking surcharges at ₹50 | Reduce pricing friction |
| Transparent Pricing | Display all-inclusive prices before checkout | Reduce last-minute abandonment |
| District Priority Pass | Introduce loyalty-based surcharge waivers | Improve repeat bookings and retention |
| Smart Waitlist Allocation | Redirect abandoned high-demand bookings to automated waitlists | Recover potential demand |
| Pricing Experimentation | Continuously test pricing tiers and fee structures | Improve conversion and revenue efficiency |

### Recommended Pricing Strategy

**Implement a ₹50 Dynamic Surcharge Cap**

Based on the simulated experiment, a capped-surcharge strategy could improve booking conversion while maintaining a more predictable customer experience.

**Introduce Upfront Transparent Pricing**

Display base ticket prices, convenience fees, taxes, and applicable surcharges directly on event and dining listing pages.

**Strengthen Customer Loyalty**

Explore District Priority Pass or Zomato Gold-linked benefits to encourage repeat bookings through targeted fee discounts.

---

## 📈 10. Projected Commercial Impact

| Business Area | Expected Strategic Outcome |
|---|---|
| GMV Recovery | Potential recovery of a portion of abandoned high-surcharge bookings |
| Conversion Stability | Improved checkout conversion during Friday–Sunday peak periods |
| Merchant Relationships | Fewer unfulfilled dining reservations caused by pricing friction |
| Customer Retention | Improved customer experience and repeat booking potential |
| Unit Economics | Better balance between convenience fee revenue and completed booking commissions |

*Note: These are strategic projections based on simulated analytical findings, not verified production outcomes.*

---

## 📂 11. Project Deliverables

| Deliverable | Description |
|---|---|
| SQL Scripts | `district_checkout_attrition_diagnostics.sql` |
| Python Notebook | `z_test_hypothesis_validation.ipynb` |
| Power BI Dashboard | Interactive executive dashboard (`.pbix`) |
| Technical Documentation | Methodology, cohort definitions, and experiment specifications |

---

## 📌 12. Key Takeaways

This project demonstrates how product analytics, SQL-based transactional analysis, and statistical experimentation can be combined to solve real-world commercial problems in the live entertainment and premium dining ecosystem.

Key outcomes from the simulated analysis include:

- Identified a potential pricing friction threshold above ₹70.
- Quantified checkout abandonment across three dynamic pricing cohorts.
- Designed a controlled A/B testing framework across 10,000 simulated sessions.
- Observed a statistically significant +14.2 percentage-point conversion lift.
- Developed actionable pricing and customer retention recommendations.

**The ultimate objective is to help District balance customer willingness-to-pay, booking conversion, and sustainable platform revenue through data-driven pricing decisions.**

---

### 👨‍💻 Author

**Ajeet Yadav**

Aspiring Data Analyst | Business Analytics | Product Analytics

**Core Skills:** SQL | Python | Power BI | DAX | A/B Testing | Statistical Analysis | Business Intelligence
