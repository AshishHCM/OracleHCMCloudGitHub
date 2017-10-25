SELECT papf.person_number EmployeeNumber,
       INITCAP(ppnf.title)         EmployeeTitle,
       ppnf.display_name  EmployeeName,
       pea.email_address EmployeeEmail,
       to_char(pps.actual_termination_date,'MM-DD-YYYY') TerminationDate,
       (select papf1.person_number
        from   per_all_people_f papf1
        where  papf1.person_id = pasf.manager_id
        and    trunc(sysdate) between papf1.effective_start_date and papf1.effective_end_date) AssignmentManagerPersonNumber,
       (select ppnf1.display_name
        from   per_person_names_f ppnf1
        where  ppnf1.person_id = pasf.manager_id
        and    ppnf1.name_type = 'GLOBAL'
        and    trunc(sysdate) between ppnf1.effective_start_date and ppnf1.effective_end_date) ManagerName,
      (select pea1.email_address
        from   per_email_addresses pea1
        where  pea1.person_id = pasf.manager_id
        and    pea1.email_type = 'W1') ManagerEmail,
       to_char(trunc(pps.last_update_date),'MM-DD-YYYY') ppslud,
       to_char(trunc(sysdate-1),'MM-DD-YYYY') yesterdaydate,
       to_char(trunc(sysdate),'MM-DD-YYYY') currentdate,
       papf.person_id papfpersonid,
       pasf.person_id pasfpersonid,
       pasf.manager_id pasfmgrid
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