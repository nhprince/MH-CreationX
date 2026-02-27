-- MH CreationX payment backfill
-- Run on a backup first.

-- Step 1: Fix rows where advance was received but paid_amount was never updated
UPDATE projects
SET paid_amount = advance_amount
WHERE advance_amount > 0
  AND paid_amount = 0;

-- Step 2: Fix rows marked Paid but paid_amount is less than price
UPDATE projects
SET paid_amount = price
WHERE payment_status = 'Paid'
  AND paid_amount < price;

-- Step 3: Fix rows marked Paid that still have advance_amount > 0 (zero it out)
UPDATE projects
SET advance_amount = 0
WHERE payment_status = 'Paid'
  AND advance_amount > 0;

-- Step 4: Recompute payment_status for ALL rows based on paid_amount vs price
UPDATE projects
SET payment_status = CASE
  WHEN paid_amount >= price AND price > 0 THEN 'Paid'
  WHEN paid_amount = 0                    THEN 'Unpaid'
  ELSE                                         'Partial'
END;

-- Step 5 (verification query): should return 0 rows if all data is clean
SELECT COUNT(*) AS violations
FROM projects
WHERE
  (payment_status = 'Paid' AND (paid_amount < price OR advance_amount > 0))
  OR (payment_status = 'Unpaid' AND paid_amount > 0)
  OR (payment_status = 'Partial' AND (paid_amount = 0 OR paid_amount >= price));
