declare
    l_tbl_name varchar2 (1000);
    l_col_name_1 varchar2 (1000);
    l_sql_1 varchar2 (10000);
    l_sql_2 varchar2 (10000);
    res_cnt integer;
    res_null integer;
    
    l_col_name_2 varchar2 (1000);
    l_sql_3 varchar2 (10000);
    res_neg integer;
  
    CURSOR cur1 IS
    select COLUMN_NAME
    from all_tab_columns
    where owner = 'BUDM_VRB' AND table_name = 'VRB_DET_DEVICE'
    ORDER BY COLUMN_ID;
    
    CURSOR cur2 IS
    select column_name
    from all_tab_columns
    where owner = 'BUDM_VRB' AND table_name = 'VRB_DET_DEVICE' AND DATA_TYPE = 'NUMBER' and column_name not like 'ID%'
    ORDER BY COLUMN_ID;
    
begin
    select table_name
    INTO l_tbl_name
    from all_tables
    where owner = 'BUDM_VRB' AND table_name = 'VRB_DET_DEVICE';
    
    
    open cur1;
    
    loop
        fetch cur1 into l_col_name_1;
        exit when cur1%notfound;
        
        l_sql_1 := 'select count(' || l_col_name_1 || ') FROM BUDM_VRB.' || l_tbl_name;
        l_sql_2 := 'select count(CASE WHEN ' || l_col_name_1 || ' IS NULL THEN 1 END) FROM BUDM_VRB.' || l_tbl_name;
        
        execute immediate l_sql_1 into res_cnt;
        execute immediate l_sql_2 into res_null;
        insert into CNT_ROWS_VRB  values (l_col_name_1, res_cnt, res_null);
    end loop;
    close cur1;
    

    
    open cur2;
    
    loop 
        fetch cur2 into l_col_name_2;
        exit when cur2%notfound;
        
        l_sql_3 := 'select count( CASE when ' || l_col_name_2 || ' < 0 then 1 end) FROM BUDM_VRB.' || l_tbl_name;
        execute immediate l_sql_3 into res_neg;
        insert into NEG_ROWS_VRB  values (l_col_name_2, res_neg);
    end loop;
    close cur2;
end;

drop table CNT_ROWS_VRB;
drop table NEG_ROWS_VRB;
create table INTECH.CNT_ROWS_VRB (name_table varchar2 (1000), cnt integer, cnt_null integer);
create table INTECH.NEG_ROWS_VRB (name_table varchar2 (1000), neg integer);
on commit delete rows;
TRUNCATE TABLE CNT_ROWS_VRB;
TRUNCATE TABLE NEG_ROWS_VRB;

SELECT CNT.NAME_TABLE, CNT.CNT, CNT.CNT_NULL, NEG.NEG
FROM intech.CNT_ROWS_VRB cnt
FULL JOIN intech.NEG_ROWS_VRB  neg on cnt.name_table = neg.name_table
select *
from NEG_ROWS_VRB

