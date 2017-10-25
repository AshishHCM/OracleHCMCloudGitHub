select   "PER_PERSONS"."PERSON_ID" as "PERSON_ID",
         "HR_ALL_ORGANIZATION_UNITS_F_VL"."NAME" as "BUSINESS_GROUP_NAME"
from    "PER_PERSONS" "PER_PERSONS",
        "HR_ALL_ORGANIZATION_UNITS_F_VL" "HR_ALL_ORGANIZATION_UNITS_F_VL",
        "HR_ORG_UNIT_CLASSIFICATIONS_F" "HR_ORG_UNIT_CLASSIFICATIONS_F"
where  "HR_ALL_ORGANIZATION_UNITS_F_VL"."NAME" = :p_bg_name
and    "HR_ORG_UNIT_CLASSIFICATIONS_F"."ORGANIZATION_ID" = "HR_ALL_ORGANIZATION_UNITS_F_VL"."ORGANIZATION_ID"
and    "HR_ORG_UNIT_CLASSIFICATIONS_F"."CLASSIFICATION_CODE" = 'ENTERPRISE'
and    TRUNC(sysdate) BETWEEN "HR_ORG_UNIT_CLASSIFICATIONS_F"."EFFECTIVE_START_DATE" AND "HR_ORG_UNIT_CLASSIFICATIONS_F"."EFFECTIVE_END_DATE"
and    TRUNC(sysdate) BETWEEN "HR_ALL_ORGANIZATION_UNITS_F_VL"."EFFECTIVE_START_DATE" AND "HR_ALL_ORGANIZATION_UNITS_F_VL"."EFFECTIVE_END_DATE"
and    "HR_ORG_UNIT_CLASSIFICATIONS_F"."STATUS" = 'A'
and    "PER_PERSONS"."PERSON_ID" = nvl(:p_person_id, "PER_PERSONS"."PERSON_ID")
and    "PER_PERSONS"."BUSINESS_GROUP_ID" = "HR_ALL_ORGANIZATION_UNITS_F_VL"."ORGANIZATION_ID"
and     trunc(SYSDATE) BETWEEN "HR_ALL_ORGANIZATION_UNITS_F_VL"."EFFECTIVE_START_DATE" AND "HR_ALL_ORGANIZATION_UNITS_F_VL"."EFFECTIVE_END_DATE"
and    
(   exists 
           (select 1 from "PER_ACTION_OCCURRENCES" "PER_ACTION_OCCURRENCES"
            where "PER_ACTION_OCCURRENCES"."PARENT_ENTITY_KEY_ID" = "PER_PERSONS"."PERSON_ID"
            and trunc("PER_ACTION_OCCURRENCES"."ACTION_DATE") between DECODE(:p_last_run_days,0,TO_DATE('01-01-0001','DD-MM-YYYY'), 
            (trunc(SYSDATE)-:p_last_run_days)) and DECODE(:p_last_run_days,0,TO_DATE('31-12-4712','DD-MM-YYYY'),trunc(SYSDATE) )
            )
    or exists 
           ( select  1 from "PER_PERSON_NAMES_F_V" "PER_PERSON_NAMES_F_V"
             where "PER_PERSON_NAMES_F_V"."PERSON_ID" = "PER_PERSONS"."PERSON_ID"
             and "PER_PERSON_NAMES_F_V"."BUSINESS_GROUP_ID" = "PER_PERSONS"."BUSINESS_GROUP_ID"
             and  trunc("PER_PERSON_NAMES_F_V"."LAST_UPDATE_DATE") BETWEEN DECODE(:p_last_run_days,0,TO_DATE('01-01-0001','DD-MM-YYYY'),
            (trunc(SYSDATE)-:p_last_run_days)) and DECODE(:p_last_run_days,0,TO_DATE('31-12-4712','DD-MM-YYYY'),trunc(SYSDATE) )
            )  
    or exists 
          ( select  1 FROM "PER_ALL_PEOPLE_F_V"
            where "PER_ALL_PEOPLE_F_V"."PERSON_ID" = "PER_PERSONS"."PERSON_ID"
            and "PER_ALL_PEOPLE_F_V"."BUSINESS_GROUP_ID" = "PER_PERSONS"."BUSINESS_GROUP_ID"
            and trunc("PER_ALL_PEOPLE_F_V"."LAST_UPDATE_DATE") between DECODE(:p_last_run_days,0,TO_DATE('01-01-0001','DD-MM-YYYY'),
            (trunc(SYSDATE)-:p_last_run_days)) and DECODE(:p_last_run_days,0,TO_DATE('31-12-4712','DD-MM-YYYY'),trunc(SYSDATE) )
          )  
)
and exists 
         ( select 1 FROM "PER_PERSON_TYPE_USAGES_F" 
           where "PER_PERSON_TYPE_USAGES_F"."PERSON_ID" = "PER_PERSONS"."PERSON_ID"
           and DECODE (:p_include_term_recs,'N',SYSTEM_PERSON_TYPE,1) != DECODE(:p_include_term_recs,'N','EX_EMP',2)
           and DECODE (:p_include_term_recs,'Y',trunc(SYSDATE), trunc(SYSDATE)) BETWEEN DECODE (:p_include_term_recs,'Y',trunc(SYSDATE),trunc(EFFECTIVE_START_DATE)) AND DECODE (:p_include_term_recs,'Y',trunc(SYSDATE),trunc(EFFECTIVE_END_DATE)) 
          )