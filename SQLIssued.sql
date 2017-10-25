SET VARIABLE PREFERRED_CURRENCY='User Preferred Currency 1';SELECT a saw_0, a1 saw_1, d saw_2, b saw_3, f saw_4, h saw_5, j saw_6, l saw_7, n saw_8, p saw_9, e saw_10, c saw_11, g saw_12, i saw_13, k saw_14, m saw_15, o saw_16, q saw_17, CASE WHEN IFNULL(f,'-1')=IFNULL(g,'-1') THEN 'N' ELSE 'Y' END saw_18, CASE WHEN IFNULL(h,'-1')=IFNULL(i,'-1') THEN 'N' ELSE 'Y' END saw_19, CASE WHEN IFNULL(j,'-1')=IFNULL(k,'-1') THEN 'N' ELSE 'Y' END saw_20, CASE WHEN IFNULL(l,'-1')=IFNULL(m,'-1') THEN 'N' ELSE 'Y' END saw_21, CASE WHEN IFNULL(n,'-1')=IFNULL(o,'-1') THEN 'N' ELSE 'Y' END saw_22, CASE WHEN IFNULL(p,'-1')=IFNULL(q,'-1') THEN 'N' ELSE 'Y' END saw_23 FROM (
SELECT A.A_3 a, A.A_3A a1,
A.A_1 b,B.B_1 c,
A.A_2 d, B.B_2 e,
A.A_11 f,B.B_11 g,
A.A_12 h, B.B_12 i,
A.A_13 j, B.B_13 k,
A.A_14 l, B.B_14 m,
A.A_15 n, B.B_15 o,
A.A_16 p, B.B_16 q
FROM 
(SELECT
   0 A_0,
   "Workforce Management - Worker Assignment Event Real Time"."Worker"."Person Number" A_3,
   "Workforce Management - Worker Assignment Event Real Time"."Worker"."Employee Name" A_3A,
   "Workforce Management - Worker Assignment Event Real Time"."Time"."Date" A_2,
   "Workforce Management - Worker Assignment Event Real Time"."HR Action"."Action Name" A_1,  
   RCOUNT(1) A_4,
   "Workforce Management - Worker Assignment Event Real Time"."Business Unit"."Business Unit Name" A_11,
   "Workforce Management - Worker Assignment Event Real Time"."Department"."Department Name" A_12,
   "Workforce Management - Worker Assignment Event Real Time"."Grade"."Grade Name" A_13,
   "Workforce Management - Worker Assignment Event Real Time"."Job"."Job Name" A_14,
   "Workforce Management - Worker Assignment Event Real Time"."Location"."Worker Location Name" A_15,
   "Workforce Management - Worker Assignment Event Real Time"."Position"."Position Name" A_16
FROM "Workforce Management - Worker Assignment Event Real Time"
WHERE
TOPN(RCOUNT("Worker"."Person Number"),2) <= 2 
GROUP BY "Worker"."Person Number"


) A,

(SELECT
   0 B_0,
   "Workforce Management - Worker Assignment Event Real Time"."Worker"."Person Number" B_3,
   "Workforce Management - Worker Assignment Event Real Time"."Time"."Date" B_2,
   "Workforce Management - Worker Assignment Event Real Time"."HR Action"."Action Name" B_1,
   RCOUNT(1) B_4,
   "Workforce Management - Worker Assignment Event Real Time"."Business Unit"."Business Unit Name" B_11,
   "Workforce Management - Worker Assignment Event Real Time"."Department"."Department Name" B_12,
   "Workforce Management - Worker Assignment Event Real Time"."Grade"."Grade Name" B_13,
   "Workforce Management - Worker Assignment Event Real Time"."Job"."Job Name" B_14,
   "Workforce Management - Worker Assignment Event Real Time"."Location"."Worker Location Name" B_15,
   "Workforce Management - Worker Assignment Event Real Time"."Position"."Position Name" B_16
FROM "Workforce Management - Worker Assignment Event Real Time"
WHERE
TOPN(RCOUNT("Worker"."Person Number"),2) <= 2 
GROUP BY "Worker"."Person Number"

) B
WHERE A.A_4 = (B.B_4+1)
AND A.A_3 = B.B_3
) tj WHERE CASE WHEN IFNULL(f,'-1')=IFNULL(g,'-1') THEN 'N' ELSE 'Y' END = 'Y' ORDER BY saw_0, saw_1, saw_2, saw_3, saw_4, saw_5, saw_6, saw_7, saw_8, saw_9, saw_10, saw_11, saw_12, saw_13, saw_14, saw_15, saw_16, saw_17, saw_18, saw_19, saw_20, saw_21, saw_22, saw_23