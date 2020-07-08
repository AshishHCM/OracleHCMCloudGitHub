select  ppnf.list_name colleague_name,
        papf.person_number colleague_number,
        abs_audit.per_absence_entry_id,
        aatft.name absence_type,
        abs_audit.start_datetime,
        abs_audit.end_datetime,
        abs_audit.absence_status_cd,
        abs_audit.approval_status_cd,
        abs_audit.last_update_date action_date,
        abs_audit.audit_action_type_ audit_action_type,
        abs_audit.user_mode,
        abs_audit.source,
        (   SELECT  ppnf.list_name
	        FROM    per_person_names_f ppnf,
	                per_users pu
	        WHERE   ppnf.name_type = 'GLOBAL'
	        AND     trunc(sysdate) between ppnf.effective_start_date and ppnf.effective_end_date
	        AND     ppnf.person_id = pu.person_id
	        AND     pu.username = abs_audit.created_by    
	    ) action_taken_by,
       abs_audit.creation_date,
      (   SELECT  ppnf.list_name
	        FROM    per_person_names_f ppnf,
	                per_users pu
	        WHERE   ppnf.name_type = 'GLOBAL'
	        AND     trunc(sysdate) between ppnf.effective_start_date and ppnf.effective_end_date
	        AND     ppnf.person_id = pu.person_id
	        AND     pu.username = abs_audit.last_updated_by    
	    ) last_action_taken_by,
       abs_audit.last_update_date
from   anc_per_abs_entries_ abs_audit,
       anc_absence_types_f_tl aatft,
       per_all_people_f papf,
       per_person_names_f ppnf
where  papf.person_id = abs_audit.person_id
and    papf.person_id = ppnf.person_id
and    abs_audit.absence_type_id = aatft.absence_type_id
and    aatft.language = 'US'
and    trunc(sysdate) between papf.effective_start_date and papf.effective_end_date
and    trunc(sysdate) between ppnf.effective_start_date and ppnf.effective_end_date
and    trunc(sysdate) between aatft.effective_start_date and aatft.effective_end_date
and    ppnf.name_type = 'GLOBAL'
and    papf.person_number = nvl(:p_person_number,papf.person_number) /* Colleague Number for whom investigation is required*/
