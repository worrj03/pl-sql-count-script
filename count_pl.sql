-- считает количество строк и NULL по каждому атрибуту
declare
    l_tbl_name varchar2 (1000);
    l_col_name varchar2 (1000);
    l_sql_1 varchar2 (10000);
    l_sql_2 varchar2 (10000);
    res_cnt integer;
    res_null integer;
    
    CURSOR cur IS
    select COLUMN_NAME
    from all_tab_columns
    where owner = 'BUDM_VRB' AND table_name = 'VRB_DET_DEVICE'
    ORDER BY COLUMN_ID;
begin
    select table_name
    INTO l_tbl_name
    from all_tables
    where owner = 'BUDM_VRB' AND table_name = 'VRB_DET_DEVICE';
    
    open cur;
    
    loop
        fetch cur into l_col_name;
        exit when cur%notfound;
        
        l_sql_1 := 'select count(' || l_col_name || ') FROM BUDM_VRB.' || l_tbl_name;
        l_sql_2 := 'select count(CASE WHEN ' || l_col_name || ' IS NULL THEN 1 END) FROM BUDM_VRB.' || l_tbl_name;
        execute immediate l_sql_1 into res_cnt;
        execute immediate l_sql_2 into res_null;
        insert into test  values (l_col_name, res_cnt, res_null);
    end loop;
    close cur;

        
end;

drop table test;
create global temporary table test (name_table varchar2 (1000), cnt integer, cnt_null integer);
SELECT *
FROM test