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
    where owner = 'schema' AND table_name = 'tbl'
    ORDER BY COLUMN_ID;
    
    CURSOR cur2 IS
    select column_name
    from all_tab_columns
    where owner = 'schema' AND table_name = 'tbl' AND DATA_TYPE = 'NUMBER' and column_name not like 'ID%'
    ORDER BY COLUMN_ID;
    
begin
    select table_name
    INTO l_tbl_name
    from all_tables
    where owner = 'schema' AND table_name = 'tbl';
    
    
    open cur1;
    
    loop
        fetch cur1 into l_col_name_1;
        exit when cur1%notfound;
        
        l_sql_1 := 'select count(' || l_col_name_1 || ') FROM schema.' || l_tbl_name;
        l_sql_2 := 'select count(CASE WHEN ' || l_col_name_1 || ' IS NULL THEN 1 END) FROM schema.' || l_tbl_name;
        
        execute immediate l_sql_1 into res_cnt;
        execute immediate l_sql_2 into res_null;
        insert into CNT_ROWS  values (l_col_name_1, res_cnt, res_null);
    end loop;
    close cur1;
    

    
    open cur2;
    
    loop 
        fetch cur2 into l_col_name_2;
        exit when cur2%notfound;
        
        l_sql_3 := 'select count( CASE when ' || l_col_name_2 || ' < 0 then 1 end) FROM schema.' || l_tbl_name;
        execute immediate l_sql_3 into res_neg;
        insert into NEG_ROWS  values (l_col_name_2, res_neg);
    end loop;
    close cur2;
end;

drop table CNT_ROWS;
drop table NEG_ROWS;
create table schema.CNT_ROWS (name_table varchar2 (1000), cnt integer, cnt_null integer);
create table schema.NEG_ROWS (name_table varchar2 (1000), neg integer);
on commit delete rows;
TRUNCATE TABLE CNT_ROWS;
TRUNCATE TABLE NEG_ROWS;

SELECT CNT.NAME_TABLE, CNT.CNT, CNT.CNT_NULL, NEG.NEG
FROM schema.CNT_ROWS cnt
FULL JOIN schema.NEG_ROWS  neg on cnt.name_table = neg.name_table

