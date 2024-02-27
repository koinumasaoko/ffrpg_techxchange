**free

ctl-opt dftactgrp(*no) main(main);
//---------------------
// SQL.sqlrpgle
// CALL PGM(XXXLIB/SQL) PARM((C (*CHAR 1)) ('12345' (*CHAR 5))     
// ('hogehoge' (*CHAR 50)) (987654321 (*DEC 9 0))) 
//---------------------

//global scope variable 
dcl-s dsplay_message  char(52); 

dcl-proc main;
    //parameters
    dcl-pi *N;
        #PKBN   char(1);
        #PTKBAN char(5);
        #PTOKKJ char(50);
        #PTKURT packed(9:0);
    end-pi;    

    select;
    when #PKBN = 'C';
        dsply   'Insert Start';
        dsply   insertSql(#PTKBAN : #PTOKKJ : #PTKURT);
    when #PKBN = 'R';
        dsply   'Select Start';
        dsply   selectSql(#PTKBAN);
    when #PKBN = 'U';
        dsply   'Update Start';
        dsply   updateSql(#PTKBAN : #PTOKKJ : #PTKURT);
    when #PKBN = 'D';
        dsply   'Delete Start';
        dsply   deleteSql(#PTKBAN);
    other;
        dsply 'Please enter [C R U D]';
    endsl;
end-proc;    


dcl-proc insertSql;

    dcl-pi *n varchar(52);
        #TKBNG  char(5) value;
        #TOKKJ char(50) value;
        #TKURT packed(9:0) value;
    end-pi;

    //insert
    exec sql insert into KOINUSC.TOKTAB (TKBANG,TKNAKJ,TKGURT)
        values(:#TKBNG, :#TOKKJ, :#TKURT);
    dsplay_message = 'INSERT:SQLSTATE = ' + SQLSTATE + ':TKBANG:'+ #TKBNG;
    return dsplay_message;

end-proc;

dcl-proc selectSql;

    dcl-pi *n varchar(52);
        #TKBNG  char(5) value;
    end-pi;
        
    //select to insert
    exec sql insert into KOINUSC.TOKTAB2 (TKBANG,TKNAKJ,TKGURT)
        select TKBANG,TKNAKJ ,TKGURT
        from KOINUSC.TOKTAB
        where TKBANG = :#TKBNG;

    dsplay_message = 'SELECT:SQLSTATE = ' + SQLSTATE + ':TKBANG:'+ #TKBNG;
    return dsplay_message;

end-proc;

dcl-proc updateSql;

    dcl-pi *n varchar(52);
        #TKBNG  char(5) value;
        #TOKKJ char(50) value;
        #TKURT packed(9:0) value;
    end-pi;

    //update
    exec sql update KOINUSC.TOKTAB
        set TKNAKJ  = :#TOKKJ, TKGURT = :#TKURT
        where TKBANG = :#TKBNG;

    dsplay_message = 'UPDATE:SQLSTATE = ' + SQLSTATE + ':TKBANG:'+ #TKBNG;
    return dsplay_message;

end-proc;


dcl-proc deleteSql;

    dcl-pi *n varchar(52);
        #TKBNG  char(5) value;
    end-pi;
        
    //delete
    exec sql delete KOINUSC.TOKTAB
        where TKBANG = :#TKBNG;    

    dsplay_message = 'DELETE:SQLSTATE = ' + SQLSTATE + ':TKBANG:'+ #TKBNG;
    return dsplay_message;

end-proc;