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
        p_kubun   char(1);
        p_tokuisaki_number char(5);
        p_tokuisaki_name_kanji char(50);
        p_tokuisaki_uriage packed(9:0);
    end-pi;    

    select;
    when p_kubun = 'C';
        dsply   'Insert Start';
        dsply   insertSql(p_tokuisaki_number : p_tokuisaki_name_kanji : p_tokuisaki_uriage);
    when p_kubun = 'R';
        dsply   'Select Start';
        dsply   selectSql(p_tokuisaki_number);
    when p_kubun = 'U';
        dsply   'Update Start';
        dsply   updateSql(p_tokuisaki_number : p_tokuisaki_name_kanji : p_tokuisaki_uriage);
    when p_kubun = 'D';
        dsply   'Delete Start';
        dsply   deleteSql(p_tokuisaki_number);
    other;
        dsply 'Please enter [C R U D]';
    endsl;
end-proc;    


dcl-proc insertSql;

    dcl-pi *n varchar(52);
        pi_tokuisaki_number  char(5) value;
        #pi_tokuisaki_name_kanji char(50) value;
        pi_tokuisaki_uriage packed(9:0) value;
    end-pi;

    //insert
    exec sql insert into STUXXSC.TOKTAB (TKBANG,TKNAKJ,TKGURT)
        values(:pi_tokuisaki_number, :#pi_tokuisaki_name_kanji, :pi_tokuisaki_uriage);
    dsplay_message = 'INSERT:SQLSTATE = ' + SQLSTATE + ':TKBANG:'+ pi_tokuisaki_number;
    return dsplay_message;

end-proc;

dcl-proc selectSql;

    dcl-pi *n varchar(52);
        pi_tokuisaki_number  char(5) value;
    end-pi;
        
    //select to insert
    exec sql insert into STUXXSC.TOKTAB2 (TKBANG,TKNAKJ,TKGURT)
        select TKBANG,TKNAKJ ,TKGURT
        from STUXXSC.TOKTAB
        where TKBANG = :pi_tokuisaki_number;

    dsplay_message = 'SELECT:SQLSTATE = ' + SQLSTATE + ':TKBANG:'+ pi_tokuisaki_number;
    return dsplay_message;

end-proc;

dcl-proc updateSql;

    dcl-pi *n varchar(52);
        pi_tokuisaki_number  char(5) value;
        #pi_tokuisaki_name_kanji char(50) value;
        pi_tokuisaki_uriage packed(9:0) value;
    end-pi;

    //update
    exec sql update STUXXSC.TOKTAB
        set TKNAKJ  = :#pi_tokuisaki_name_kanji, TKGURT = :pi_tokuisaki_uriage
        where TKBANG = :pi_tokuisaki_number;

    dsplay_message = 'UPDATE:SQLSTATE = ' + SQLSTATE + ':TKBANG:'+ pi_tokuisaki_number;
    return dsplay_message;

end-proc;


dcl-proc deleteSql;

    dcl-pi *n varchar(52);
        pi_tokuisaki_number  char(5) value;
    end-pi;
        
    //delete
    exec sql delete STUXXSC.TOKTAB
        where TKBANG = :pi_tokuisaki_number;    

    dsplay_message = 'DELETE:SQLSTATE = ' + SQLSTATE + ':TKBANG:'+ pi_tokuisaki_number;
    return dsplay_message;

end-proc;