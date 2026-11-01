-- =================================================================================
-- PROJECT: District Entertainment & Dining: Checkout Funnel Diagnostics
-- ECOSYSTEM: Live Events, Nightlife Ticketing & Dining Reservations (District by Eternal)
-- GEOGRAPHY / MARKET: Gurugram Entertainment Corridors (CyberHub, Sector 29, Golf Course Rd)
-- ROLE FOCUS: Product Analytics, Dynamic Pricing Guardrails & Drop-off Diagnostics
-- AUTHOR: Ajeet Yadav
-- =================================================================================

SELECT 
    -- 1. Commercial Tier Segmentation: Dynamic Convenience Fee & Peak Surcharge Bands
    CASE 
        WHEN CAST(c4 AS REAL) <= 30.0 THEN '0-30 INR (Low Baseline Surcharge)'
        WHEN CAST(c4 AS REAL) > 30.0 AND CAST(c4 AS REAL) <= 70.0 THEN '31-70 INR (Volatile Medium Surcharge)'
        ELSE 'Above 70 INR (Critical Peak Surcharge)'
    END AS surcharge_tier,
    
    -- 2. Checkout Journey Telemetry: Total Initiated Sessions vs Abandoned Carts
    COUNT(c1) AS total_checkout_attempts,
    SUM(CAST(c6 AS INTEGER)) AS total_dropped_bookings,
    
    -- 3. Commercial Health Metric: Checkout Funnel Attrition Rate (%)
    ROUND(
        (CAST(SUM(CAST(c6 AS INTEGER)) AS REAL) / COUNT(c1)) * 100.0, 
        2
    ) AS funnel_attrition_rate

FROM 
    gurugram_churn_data

-- 4. Aggregate by Strategic Surcharge Cohorts for Executive Reporting
GROUP BY 
    1

-- 5. Prioritize by Revenue Leakage Severity to Isolate Willingness-to-Pay (WTP) Cliffs
ORDER BY 
    funnel_attrition_rate DESC;
