SELECT TABLE1.PERSON_NUMBER PERSONNUMBER,
       TABLE1.USERNAME,
       TABLE1.PLANNAME PlanName,
       TABLE1.END_BAL || ' ' || DECODE(TABLE1.PLANUOM,'D', 'Days','H','Hours',TABLE1.PLANUOM) PlanBalance
FROM
(
select    apae.person_id,
          papf.person_number, 
          apae.plan_id,
          (select aapft.name
           from anc_absence_plans_f_tl aapft
           where TRUNC(SYSDATE) BETWEEN aapft.effective_start_date and aapft.effective_end_date
           and language = 'US'
           and aapft.absence_plan_id = apae.plan_id) planname,
           (select aapf.plan_uom
            from anc_absence_plans_f aapf
            where aapf.absence_plan_id = apae.plan_id
            and   TRUNC(SYSDATE) between aapf.effective_start_date and aapf.effective_end_date
            ) planuom,
           apae.accrual_period,
           apae.end_bal,
           pu.username
from anc_per_accrual_entries apae,
        per_all_people_f papf,
        per_users pu
where apae.person_id = papf.person_id
and TRUNC(SYSDATE) BETWEEN papf.effective_start_date and papf.effective_end_date
and TRUNC(apae.accrual_period) = TRUNC(LAST_DAY(:pdate))
and pu.person_id = papf.person_id
and pu.user_guid = fnd_global.user_guid
) TABLE1