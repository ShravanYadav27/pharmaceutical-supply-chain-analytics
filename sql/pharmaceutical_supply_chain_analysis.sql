CREATE TABLE raw_shipments (
    id INTEGER,
    project_code TEXT,
    pq_number TEXT,
    po_so_number TEXT,
    asn_dn_number TEXT,
    country TEXT,
    managed_by TEXT,
    fulfill_via TEXT,
    vendor_inco_term TEXT,
    shipment_mode TEXT,
    pq_first_sent_to_client_date TEXT,
    po_sent_to_vendor_date TEXT,
    scheduled_delivery_date TEXT,
    delivered_to_client_date TEXT,
    delivery_recorded_date TEXT,
    product_group TEXT,
    sub_classification TEXT,
    vendor TEXT,
    item_description TEXT,
    molecule_test_type TEXT,
    brand TEXT,
    dosage TEXT,
    dosage_form TEXT,
    unit_of_measure_per_pack INTEGER,
    line_item_quantity INTEGER,
    line_item_value NUMERIC,
    pack_price NUMERIC,
    unit_price NUMERIC,
    manufacturing_site TEXT,
    first_line_designation BOOLEAN,
    weight_kilograms TEXT,
    freight_cost_usd TEXT,
    line_item_insurance_usd NUMERIC
);

SELECT * from raw_shipments;

SELECT COUNT(*) AS total_rows
FROM raw_shipments;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids
FROM raw_shipments;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(country) AS missing_country,
    COUNT(*) - COUNT(vendor) AS missing_vendor,
    COUNT(*) - COUNT(shipment_mode) AS missing_shipment_mode,
    COUNT(*) - COUNT(product_group) AS missing_product_group,
    COUNT(*) - COUNT(line_item_quantity) AS missing_quantity,
    COUNT(*) - COUNT(line_item_value) AS missing_value
FROM raw_shipments;


SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(shipment_mode) AS missing_shipment_mode,
    ROUND(
        (COUNT(*) - COUNT(shipment_mode)) * 100.0 / COUNT(*),
        2
    ) AS missing_percentage
FROM raw_shipments;


SELECT
    id,
    country,
    vendor,
    shipment_mode,
    product_group,
    item_description,
    line_item_quantity,
    line_item_value
FROM raw_shipments
WHERE shipment_mode IS NULL;


SELECT
    country,
    COUNT(*) AS missing_shipments
FROM raw_shipments
WHERE shipment_mode IS NULL
GROUP BY country
ORDER BY missing_shipments DESC;


--Are these missing shipment modes mostly connected to one particular vendor?
SELECT
    vendor,
    COUNT(*) AS missing_shipments
FROM raw_shipments
WHERE shipment_mode IS NULL
GROUP BY vendor

--When SCMS from RDC DOES have a shipment mode recorded, which modes does it normally use?
SELECT
    shipment_mode,
    COUNT(*) AS total_shipments
FROM raw_shipments
WHERE vendor = 'SCMS from RDC'
GROUP BY shipment_mode
ORDER BY total_shipments DESC;
ORDER BY missing_shipments DESC;


-- 
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) - COUNT(id) AS null_id,
    COUNT(*) - COUNT(project_code) AS null_project_code,
    COUNT(*) - COUNT(pq_number) AS null_pq_number,
    COUNT(*) - COUNT(po_so_number) AS null_po_so_number,
    COUNT(*) - COUNT(asn_dn_number) AS null_asn_dn_number,
    COUNT(*) - COUNT(country) AS null_country,
    COUNT(*) - COUNT(managed_by) AS null_managed_by,
    COUNT(*) - COUNT(fulfill_via) AS null_fulfill_via,
    COUNT(*) - COUNT(vendor_inco_term) AS null_vendor_inco_term,
    COUNT(*) - COUNT(shipment_mode) AS null_shipment_mode,
    COUNT(*) - COUNT(pq_first_sent_to_client_date) AS null_pq_first_sent_date,
    COUNT(*) - COUNT(po_sent_to_vendor_date) AS null_po_sent_date,
    COUNT(*) - COUNT(scheduled_delivery_date) AS null_scheduled_delivery,
    COUNT(*) - COUNT(delivered_to_client_date) AS null_delivered_date,
    COUNT(*) - COUNT(delivery_recorded_date) AS null_delivery_recorded,
    COUNT(*) - COUNT(product_group) AS null_product_group,
    COUNT(*) - COUNT(sub_classification) AS null_sub_classification,
    COUNT(*) - COUNT(vendor) AS null_vendor,
    COUNT(*) - COUNT(item_description) AS null_item_description,
    COUNT(*) - COUNT(molecule_test_type) AS null_molecule_test_type,
    COUNT(*) - COUNT(brand) AS null_brand,
    COUNT(*) - COUNT(dosage) AS null_dosage,
    COUNT(*) - COUNT(dosage_form) AS null_dosage_form,
    COUNT(*) - COUNT(unit_of_measure_per_pack) AS null_unit_measure,
    COUNT(*) - COUNT(line_item_quantity) AS null_quantity,
    COUNT(*) - COUNT(line_item_value) AS null_item_value,
    COUNT(*) - COUNT(pack_price) AS null_pack_price,
    COUNT(*) - COUNT(unit_price) AS null_unit_price,
    COUNT(*) - COUNT(manufacturing_site) AS null_manufacturing_site,
    COUNT(*) - COUNT(first_line_designation) AS null_first_line,
    COUNT(*) - COUNT(weight_kilograms) AS null_weight,
    COUNT(*) - COUNT(freight_cost_usd) AS null_freight_cost,
    COUNT(*) - COUNT(line_item_insurance_usd) AS null_insurance

FROM raw_shipments;

-- Why can dosage be missing?
SELECT
    product_group,
    sub_classification,
    COUNT(*) AS missing_dosage
FROM raw_shipments
WHERE dosage IS NULL
GROUP BY product_group, sub_classification
ORDER BY missing_dosage DESC;

-- 
SELECT
    id,
    product_group,
    sub_classification,
    item_description,
    molecule_test_type,
    brand,
    dosage,
    dosage_form
FROM raw_shipments
WHERE dosage IS NULL
  AND sub_classification = 'Malaria';

-- 287 is null_insurnace 
SELECT
    shipment_mode,
    COUNT(*) AS missing_insurance
FROM raw_shipments
WHERE line_item_insurance_usd IS NULL
GROUP BY shipment_mode
ORDER BY missing_insurance DESC;

-- check whether these records belong to a certain time period
SELECT
    MIN(scheduled_delivery_date) AS earliest_date,
    MAX(scheduled_delivery_date) AS latest_date,
    COUNT(*) AS missing_insurance
FROM raw_shipments
WHERE line_item_insurance_usd IS NULL;


-- Check blank values
SELECT
    SUM(CASE WHEN TRIM(country) = '' THEN 1 ELSE 0 END) AS blank_country,
    SUM(CASE WHEN TRIM(vendor) = '' THEN 1 ELSE 0 END) AS blank_vendor,
    SUM(CASE WHEN TRIM(shipment_mode) = '' THEN 1 ELSE 0 END) AS blank_shipment_mode,
    SUM(CASE WHEN TRIM(product_group) = '' THEN 1 ELSE 0 END) AS blank_product_group,
    SUM(CASE WHEN TRIM(sub_classification) = '' THEN 1 ELSE 0 END) AS blank_sub_classification,
    SUM(CASE WHEN TRIM(item_description) = '' THEN 1 ELSE 0 END) AS blank_item_description,
    SUM(CASE WHEN TRIM(molecule_test_type) = '' THEN 1 ELSE 0 END) AS blank_molecule,
    SUM(CASE WHEN TRIM(brand) = '' THEN 1 ELSE 0 END) AS blank_brand,
    SUM(CASE WHEN TRIM(dosage) = '' THEN 1 ELSE 0 END) AS blank_dosage,
    SUM(CASE WHEN TRIM(dosage_form) = '' THEN 1 ELSE 0 END) AS blank_dosage_form,
    SUM(CASE WHEN TRIM(manufacturing_site) = '' THEN 1 ELSE 0 END) AS blank_manufacturing_site
FROM raw_shipments;

-- check fake values like N/A, NA, -, Unknown
SELECT
    country,
    vendor,
    shipment_mode,
    product_group,
    dosage
FROM raw_shipments
WHERE UPPER(TRIM(country)) IN ('N/A', 'NA', 'UNKNOWN', '-')
   OR UPPER(TRIM(vendor)) IN ('N/A', 'NA', 'UNKNOWN', '-')
   OR UPPER(TRIM(shipment_mode)) IN ('N/A', 'NA', 'UNKNOWN', '-')
   OR UPPER(TRIM(product_group)) IN ('N/A', 'NA', 'UNKNOWN', '-')
   OR UPPER(TRIM(dosage)) IN ('N/A', 'NA', 'UNKNOWN', '-');

-- inconsistent categories
SELECT DISTINCT shipment_mode
FROM raw_shipments
ORDER BY shipment_mode;

-- Check Product Group consistency
SELECT DISTINCT product_group
FROM raw_shipments
ORDER BY product_group;

-- check sub_classification
SELECT DISTINCT sub_classification
FROM raw_shipments
ORDER BY sub_classification;

-- count how many records belong to each country.
SELECT
    country,
    COUNT(*) AS total_shipments
FROM raw_shipments
GROUP BY country
ORDER BY total_shipments DESC;

-- check Vendors
SELECT
    vendor,
    COUNT(*) AS total_records
FROM raw_shipments
GROUP BY vendor
ORDER BY total_records DESC;


-- 
SELECT
    scheduled_delivery_date,
    delivered_to_client_date,
    delivery_recorded_date
FROM raw_shipments
LIMIT 10;


--Convert text into a real date.
SELECT
    scheduled_delivery_date,
    TO_DATE(scheduled_delivery_date, 'DD-Mon-YY') AS converted_date
FROM raw_shipments
LIMIT 10;

-- Check early and latest dates
SELECT
    MIN(TO_DATE(scheduled_delivery_date, 'DD-Mon-YY')) AS earliest_date,
    MAX(TO_DATE(scheduled_delivery_date, 'DD-Mon-YY')) AS latest_date
FROM raw_shipments;


SELECT
    MIN(TO_DATE(scheduled_delivery_date, 'DD-Mon-YY'))
        AS earliest_scheduled,

    MAX(TO_DATE(scheduled_delivery_date, 'DD-Mon-YY'))
        AS latest_scheduled,

    MIN(TO_DATE(delivered_to_client_date, 'DD-Mon-YY'))
        AS earliest_delivered,

    MAX(TO_DATE(delivered_to_client_date, 'DD-Mon-YY'))
        AS latest_delivered,

    MIN(TO_DATE(delivery_recorded_date, 'DD-Mon-YY'))
        AS earliest_recorded,

    MAX(TO_DATE(delivery_recorded_date, 'DD-Mon-YY'))
        AS latest_recorded

FROM raw_shipments;


-- 
SELECT
    pq_first_sent_to_client_date,
    po_sent_to_vendor_date
FROM raw_shipments
LIMIT 20;

-- Out of our 10,324 rows, how many have Pre-PQ Process, and how many have Date Not Captured?
SELECT
    COUNT(*) AS total_rows,

    SUM(CASE
        WHEN pq_first_sent_to_client_date = 'Pre-PQ Process'
        THEN 1 ELSE 0
    END) AS pre_pq_process,

    SUM(CASE
        WHEN po_sent_to_vendor_date = 'Date Not Captured'
        THEN 1 ELSE 0
    END) AS po_date_not_captured

FROM raw_shipments;

SELECT DISTINCT pq_first_sent_to_client_date
FROM raw_shipments
WHERE pq_first_sent_to_client_date !~ '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
ORDER BY pq_first_sent_to_client_date;

SELECT DISTINCT po_sent_to_vendor_date
FROM raw_shipments
WHERE po_sent_to_vendor_date !~ '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
ORDER BY po_sent_to_vendor_date;

-- Let's count all special values in these two columns
SELECT
    pq_first_sent_to_client_date,
    COUNT(*) AS total_records
FROM raw_shipments
WHERE pq_first_sent_to_client_date !~
      '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
GROUP BY pq_first_sent_to_client_date
ORDER BY total_records DESC;

SELECT
    po_sent_to_vendor_date,
    COUNT(*) AS total_records
FROM raw_shipments
WHERE po_sent_to_vendor_date !~
      '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
GROUP BY po_sent_to_vendor_date
ORDER BY total_records DESC;



-------------

CREATE TABLE clean_shipments AS
SELECT *
FROM raw_shipments;

SELECT COUNT(*) AS total_rows
FROM clean_shipments;


-- NULL → Unknown
UPDATE clean_shipments
SET shipment_mode = 'Unknown'
WHERE shipment_mode IS NULL;


SELECT
    shipment_mode,
    COUNT(*) AS total_records
FROM clean_shipments
GROUP BY shipment_mode
ORDER BY total_records DESC;


-- Clean dosage We found 1,736 NULL dosage values so , NULL → Not Applicable
UPDATE clean_shipments
SET dosage = 'Not Applicable'
WHERE dosage IS NULL;

SELECT
    dosage,
    COUNT(*) AS total_records
FROM clean_shipments
WHERE dosage = 'Not Applicable'
GROUP BY dosage;

-- Missing Insurance Cost - line_item_insurance_usd , NULL = 287 records
SELECT
    COUNT(*) AS total_rows,
    COUNT(line_item_insurance_usd) AS insurance_available,
    COUNT(*) - COUNT(line_item_insurance_usd) AS insurance_missing
FROM clean_shipments;


-- Convert Scheduled Delivery Date from TEXT → DATE
ALTER TABLE clean_shipments
ADD COLUMN scheduled_delivery_date_clean DATE;

UPDATE clean_shipments
SET scheduled_delivery_date_clean =
    TO_DATE(scheduled_delivery_date, 'DD-Mon-YY');

SELECT
    scheduled_delivery_date,
    scheduled_delivery_date_clean
FROM clean_shipments
LIMIT 10;

SELECT COUNT(*) AS missing_clean_dates
FROM clean_shipments
WHERE scheduled_delivery_date_clean IS NULL;



ALTER TABLE clean_shipments
ADD COLUMN delivered_to_client_date_clean DATE;

UPDATE clean_shipments
SET delivered_to_client_date_clean =
    TO_DATE(delivered_to_client_date, 'DD-Mon-YY');

SELECT
    delivered_to_client_date,
    delivered_to_client_date_clean
FROM clean_shipments
LIMIT 10;

SELECT COUNT(*) AS missing_clean_dates
FROM clean_shipments
WHERE delivered_to_client_date_clean IS NULL;




ALTER TABLE clean_shipments
ADD COLUMN delivery_recorded_date_clean DATE;

UPDATE clean_shipments
SET delivery_recorded_date_clean =
    TO_DATE(delivery_recorded_date, 'DD-Mon-YY');

SELECT COUNT(*) AS missing_clean_dates
FROM clean_shipments
WHERE delivery_recorded_date_clean IS NULL;




ALTER TABLE clean_shipments
ADD COLUMN pq_first_sent_to_client_date_clean DATE;

UPDATE clean_shipments
SET pq_first_sent_to_client_date_clean =
    CASE
        WHEN pq_first_sent_to_client_date ~
             '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
        THEN TO_DATE(pq_first_sent_to_client_date, 'MM/DD/YYYY')
        ELSE NULL
    END;

SELECT
    pq_first_sent_to_client_date,
    pq_first_sent_to_client_date_clean
FROM clean_shipments
LIMIT 20;

SELECT COUNT(*) AS missing_clean_pq_dates
FROM clean_shipments



ALTER TABLE clean_shipments
ADD COLUMN po_sent_to_vendor_date_clean DATE;

UPDATE clean_shipments
SET po_sent_to_vendor_date_clean =
    CASE
        WHEN po_sent_to_vendor_date ~
             '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
        THEN TO_DATE(po_sent_to_vendor_date, 'MM/DD/YYYY')
        ELSE NULL
    END;

SELECT COUNT(*) AS missing_clean_po_dates
FROM clean_shipments
WHERE po_sent_to_vendor_date_clean IS NULL;
WHERE pq_first_sent_to_client_date_clean IS NULL;


-- Calculate Delivery Days Difference
ALTER TABLE clean_shipments
ADD COLUMN delivery_days_difference INTEGER;

UPDATE clean_shipments
SET delivery_days_difference =
    delivered_to_client_date_clean - scheduled_delivery_date_clean;

SELECT
    scheduled_delivery_date_clean,
    delivered_to_client_date_clean,
    delivery_days_difference
FROM clean_shipments
LIMIT 20;

SELECT
    MIN(delivery_days_difference) AS most_early_days,
    MAX(delivery_days_difference) AS most_late_days,
    ROUND(AVG(delivery_days_difference), 2) AS average_difference
FROM clean_shipments;

SELECT
    CASE
        WHEN delivery_days_difference < -30 THEN 'More than 30 days early'
        WHEN delivery_days_difference BETWEEN -30 AND -1 THEN '1-30 days early'
        WHEN delivery_days_difference = 0 THEN 'Exact scheduled date'
        WHEN delivery_days_difference BETWEEN 1 AND 30 THEN '1-30 days late'
        WHEN delivery_days_difference > 30 THEN 'More than 30 days late'
    END AS delivery_timing,
    COUNT(*) AS total_records
FROM clean_shipments
GROUP BY 1
ORDER BY 1;

-- Show me the 20 records delivered furthest before their scheduled date.
SELECT
    id,
    country,
    vendor,
    shipment_mode,
    product_group,
    scheduled_delivery_date_clean,
    delivered_to_client_date_clean,
    delivery_days_difference
FROM clean_shipments
WHERE delivery_days_difference < -30
ORDER BY delivery_days_difference ASC
LIMIT 20;

SELECT
    delivery_days_difference,
    COUNT(*) AS total_records
FROM clean_shipments
GROUP BY delivery_days_difference
ORDER BY delivery_days_difference;

-- Create delivery_status
ALTER TABLE clean_shipments
ADD COLUMN delivery_status TEXT;

UPDATE clean_shipments
SET delivery_status =
    CASE
        WHEN delivery_days_difference < 0 THEN 'Early'
        WHEN delivery_days_difference = 0 THEN 'On Time'
        WHEN delivery_days_difference > 0 THEN 'Late'
    END;

SELECT
    delivery_status,
    COUNT(*) AS total_records,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clean_shipments), 2)
        AS percentage
FROM clean_shipments
GROUP BY delivery_status
ORDER BY total_records DESC;


-- When something is late, how late is it?
SELECT
    COUNT(*) AS late_records,
    ROUND(AVG(delivery_days_difference), 2) AS avg_late_days,
    MIN(delivery_days_difference) AS minimum_late_days,
    MAX(delivery_days_difference) AS maximum_late_days
FROM clean_shipments
WHERE delivery_status = 'Late';

-- Which vendors have the highest late-delivery rate?
SELECT
    vendor,
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN delivery_status = 'Late' THEN 1
            ELSE 0
        END
    ) AS late_records,

    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'Late' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_percentage

FROM clean_shipments

GROUP BY vendor

ORDER BY late_percentage DESC;

-- Filter vendors with enough records
SELECT
    vendor,
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN delivery_status = 'Late' THEN 1
            ELSE 0
        END
    ) AS late_records,

    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'Late' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_percentage

FROM clean_shipments

GROUP BY vendor

HAVING COUNT(*) >= 50

ORDER BY late_percentage DESC;

-- Calculate average delay days, but only for late records.
SELECT
    vendor,
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN delivery_status = 'Late' THEN 1
            ELSE 0
        END
    ) AS late_records,

    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'Late' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_percentage,

    ROUND(
        AVG(
            CASE
                WHEN delivery_status = 'Late'
                THEN delivery_days_difference
            END
        ),
        2
    ) AS avg_late_days

FROM clean_shipments

GROUP BY vendor

HAVING COUNT(*) >= 50

ORDER BY late_percentage DESC;

-- Which destination countries have the most delivery delays?
SELECT
    country,
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN delivery_status = 'Late' THEN 1
            ELSE 0
        END
    ) AS late_records,

    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'Late' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_percentage,

    ROUND(
        AVG(
            CASE
                WHEN delivery_status = 'Late'
                THEN delivery_days_difference
            END
        ),
        2
    ) AS avg_late_days

FROM clean_shipments

GROUP BY country

HAVING COUNT(*) >= 50

ORDER BY late_percentage DESC;

-- Does delivery performance differ by Air, Truck, Air Charter, Ocean, or Unknown?
SELECT
    shipment_mode,
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN delivery_status = 'Late' THEN 1
            ELSE 0
        END
    ) AS late_records,

    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'Late' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_percentage,

    ROUND(
        AVG(
            CASE
                WHEN delivery_status = 'Late'
                THEN delivery_days_difference
            END
        ),
        2
    ) AS avg_late_days

FROM clean_shipments

GROUP BY shipment_mode

ORDER BY late_percentage DESC;


-------------- Cost Analysis
SELECT
    freight_cost_usd,
    COUNT(*) AS total_records
FROM clean_shipments
GROUP BY freight_cost_usd
ORDER BY total_records DESC
LIMIT 20;

-- Out of our 10,324 records, how many actually contain a numeric freight cost?
SELECT
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN TRIM(freight_cost_usd) ~ '^[0-9]+(\.[0-9]+)?$'
            THEN 1 ELSE 0
        END
    ) AS numeric_freight_records,

    SUM(
        CASE
            WHEN TRIM(freight_cost_usd) !~ '^[0-9]+(\.[0-9]+)?$'
            THEN 1 ELSE 0
        END
    ) AS non_numeric_freight_records

FROM clean_shipments;

-- What are those 4,126 non-numeric values?
SELECT
    freight_cost_usd,
    COUNT(*) AS total_records
FROM clean_shipments
WHERE TRIM(freight_cost_usd) !~ '^[0-9]+(\.[0-9]+)?$'
GROUP BY freight_cost_usd
ORDER BY total_records DESC;

SELECT
    CASE
        WHEN freight_cost_usd = 'Freight Included in Commodity Cost'
            THEN 'Included in Commodity Cost'

        WHEN freight_cost_usd = 'Invoiced Separately'
            THEN 'Invoiced Separately'

        WHEN freight_cost_usd ILIKE 'See ASN%'
            THEN 'See ASN Reference'

        WHEN freight_cost_usd ILIKE 'See DN%'
            THEN 'See DN Reference'

        ELSE 'Other'
    END AS freight_type,

    COUNT(*) AS total_records

FROM clean_shipments

WHERE TRIM(freight_cost_usd) !~ '^[0-9]+(\.[0-9]+)?$'

GROUP BY freight_type
ORDER BY total_records DESC;


-- Create clean numeric freight cost
ALTER TABLE clean_shipments
ADD COLUMN freight_cost_usd_clean NUMERIC;

UPDATE clean_shipments
SET freight_cost_usd_clean =
    CASE
        WHEN TRIM(freight_cost_usd) ~ '^[0-9]+(\.[0-9]+)?$'
        THEN TRIM(freight_cost_usd)::NUMERIC
        ELSE NULL
    END;

SELECT
    COUNT(*) AS total_records,
    COUNT(freight_cost_usd_clean) AS usable_freight_records,
    COUNT(*) - COUNT(freight_cost_usd_clean) AS unavailable_freight_records,
    ROUND(
        COUNT(freight_cost_usd_clean) * 100.0 / COUNT(*),
        2
    ) AS freight_coverage_percentage
FROM clean_shipments;

--- Freight Cost KPIs
SELECT
    ROUND(SUM(freight_cost_usd_clean), 2) AS total_freight_cost,
    ROUND(AVG(freight_cost_usd_clean), 2) AS avg_freight_cost,
    ROUND(MIN(freight_cost_usd_clean), 2) AS min_freight_cost,
    ROUND(MAX(freight_cost_usd_clean), 2) AS max_freight_cost
FROM clean_shipments
WHERE freight_cost_usd_clean IS NOT NULL;

SELECT
    id,
    country,
    vendor,
    shipment_mode,
    freight_cost_usd_clean
FROM clean_shipments
WHERE freight_cost_usd_clean IS NOT NULL
ORDER BY freight_cost_usd_clean DESC
LIMIT 10;

-- Which transportation mode has the highest average recorded freight cost?
SELECT
    shipment_mode,
    COUNT(freight_cost_usd_clean) AS records_with_cost,
    ROUND(AVG(freight_cost_usd_clean), 2) AS avg_freight_cost
FROM clean_shipments
WHERE freight_cost_usd_clean IS NOT NULL
GROUP BY shipment_mode
ORDER BY avg_freight_cost DESC;

-- Among countries with at least 50 numeric freight-cost records, which have higher average recorded freight costs?
SELECT
    country,
    COUNT(freight_cost_usd_clean) AS records_with_cost,
    ROUND(AVG(freight_cost_usd_clean), 2) AS avg_freight_cost
FROM clean_shipments
WHERE freight_cost_usd_clean IS NOT NULL
GROUP BY country
HAVING COUNT(freight_cost_usd_clean) >= 50
ORDER BY avg_freight_cost DESC;

-- Vendor freight cost
SELECT
    vendor,
    COUNT(freight_cost_usd_clean) AS records_with_cost,
    ROUND(AVG(freight_cost_usd_clean), 2) AS avg_freight_cost
FROM clean_shipments
WHERE freight_cost_usd_clean IS NOT NULL
GROUP BY vendor
HAVING COUNT(freight_cost_usd_clean) >= 50
ORDER BY avg_freight_cost DESC;


-- one strong combined business query - combine vendor reliability + freight cost.
SELECT
    vendor,
    COUNT(*) AS total_records,

    ROUND(
        SUM(CASE WHEN delivery_status = 'Late' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS late_percentage,

    ROUND(
        AVG(
            CASE
                WHEN delivery_status = 'Late'
                THEN delivery_days_difference
            END
        ),
        2
    ) AS avg_late_days,

    ROUND(
        AVG(freight_cost_usd_clean),
        2
    ) AS avg_freight_cost

FROM clean_shipments

GROUP BY vendor

HAVING COUNT(*) >= 50

ORDER BY late_percentage DESC;


-- Which healthcare product groups represent the greatest recorded item value?
SELECT
    product_group,
    COUNT(*) AS total_records,
    ROUND(SUM(line_item_value), 2) AS total_item_value
FROM clean_shipments
GROUP BY product_group
ORDER BY total_item_value DESC;

--- Which product groups face more delivery delays?
SELECT
    product_group,
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN delivery_status = 'Late' THEN 1
            ELSE 0
        END
    ) AS late_records,

    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'Late' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_percentage

FROM clean_shipments
GROUP BY product_group
ORDER BY late_percentage DESC;

-- how much value is associated with late shipments.
SELECT
    product_group,

    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'Late'
                THEN line_item_value
                ELSE 0
            END
        ), 2
    ) AS late_shipment_value

FROM clean_shipments
GROUP BY product_group
ORDER BY late_shipment_value DESC;

----------------------------- Final Checks
SELECT COUNT(*) AS total_rows
FROM clean_shipments;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids
FROM clean_shipments;

SELECT
    COUNT(*) AS invalid_date_records
FROM clean_shipments
WHERE scheduled_delivery_date_clean IS NOT NULL
  AND delivered_to_client_date_clean IS NOT NULL
  AND delivery_days_difference IS NULL;

SELECT
    delivery_status,
    COUNT(*) AS total_records
FROM clean_shipments
GROUP BY delivery_status
ORDER BY total_records DESC;

SELECT
    shipment_mode,
    COUNT(*) AS total_records
FROM clean_shipments
GROUP BY shipment_mode
ORDER BY total_records DESC;

SELECT
    dosage,
    COUNT(*) AS total_records
FROM clean_shipments
WHERE dosage = 'Not Applicable'
GROUP BY dosage;

SELECT
    COUNT(*) AS total_rows,
    COUNT(freight_cost_usd_clean) AS usable_freight_cost,
    COUNT(*) - COUNT(freight_cost_usd_clean) AS unavailable_freight_cost
FROM clean_shipments;

SELECT
    COUNT(*) AS bad_records
FROM clean_shipments
WHERE line_item_quantity < 0
   OR line_item_value < 0;

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) - COUNT(country) AS missing_country,
    COUNT(*) - COUNT(vendor) AS missing_vendor,
    COUNT(*) - COUNT(shipment_mode) AS missing_shipment_mode,
    COUNT(*) - COUNT(product_group) AS missing_product_group,
    COUNT(*) - COUNT(dosage) AS missing_dosage,

    COUNT(*) - COUNT(scheduled_delivery_date_clean) AS missing_scheduled_date,
    COUNT(*) - COUNT(delivered_to_client_date_clean) AS missing_delivered_date,

    COUNT(*) - COUNT(freight_cost_usd_clean) AS missing_numeric_freight

FROM clean_shipments;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'clean_shipments'
ORDER BY ordinal_position;

SELECT
    ordinal_position,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'clean_shipments'
  AND ordinal_position >= 20
ORDER BY ordinal_position;





CREATE OR REPLACE VIEW powerbi_shipments AS
SELECT
    id,
    project_code,
    country,
    managed_by,
    fulfill_via,
    vendor_inco_term,
    shipment_mode,

    product_group,
    sub_classification,
    vendor,
    item_description,
    molecule_test_type,
    brand,
    dosage,
    dosage_form,

    unit_of_measure_per_pack,
    line_item_quantity,
    line_item_value,
    pack_price,
    unit_price,

    manufacturing_site,
    first_line_designation,

    scheduled_delivery_date_clean AS scheduled_delivery_date,
    delivered_to_client_date_clean AS delivered_to_client_date,
    delivery_recorded_date_clean AS delivery_recorded_date,

    delivery_days_difference,
    delivery_status,

    freight_cost_usd_clean AS freight_cost_usd,
    line_item_insurance_usd

FROM clean_shipments;


SELECT *
FROM powerbi_shipments
LIMIT 10;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(*) - COUNT(country) AS missing_country,
    COUNT(*) - COUNT(shipment_mode) AS missing_shipment_mode,
    COUNT(*) - COUNT(delivery_status) AS missing_delivery_status
FROM powerbi_shipments;