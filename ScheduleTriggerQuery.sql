SELECT 1
FROM   per_all_people_f papf,
       per_all_assignments_m paam,
       per_assignment_supervisors_f pasf,
       per_person_names_f ppnf,
       per_email_addresses pea,
       per_periods_of_service pps
where  papf.person_id = paam.person_id
and    paam.assignment_type IN ('E','C')
and    pps.person_id = papf.person_id
and    pps.actual_termination_date is not null
and    pea.email_type = 'W1'
and    pea.person_id = papf.person_id
and    ppnf.person_id = papf.person_id
and    ppnf.name_type = 'GLOBAL'
and    pasf.person_id = paam.person_id
and    paam.primary_flag = 'Y'
and    trunc(sysdate) between papf.effective_start_date and papf.effective_end_date
and    trunc(sysdate) between paam.effective_start_date and paam.effective_end_date
and    trunc(sysdate) between ppnf.effective_start_date and ppnf.effective_end_date
and    trunc(sysdate) between pasf.effective_start_date and pasf.effective_end_date
and    pasf.manager_type = 'LINE_MANAGER'
and    trunc(pps.last_update_date) between trunc(sysdate - 1) and trunc(sysdate)
order by pps.last_update_date desc