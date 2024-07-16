**free

ctl-opt dftname(chain);
ctl-opt dftactgrp(*no)  main(main);
//---------------------
// chain.rpgle
// CALL PGM(XXXLIB/CHAIN) PARM(('12345' (*CHAR 5)) ('虎ノ門太郎' (*CHAR 50))) 
//---------------------

dcl-proc    main;
    //parameters
    dcl-pi *n;
        #PTKBAN char(5);//得意先番号
        #PTOKKJ char(50);//得意先名漢字
    end-pi;

    //レコード様式をTOKTAB→TOKMSRへRENAME
    dcl-f TOKTAB disk usage(*update) keyed rename(TOKTAB:TOKMSR); 

    dcl-ds  customer likerec(TOKMSR:*all);

    dcl-s dsply_message	varchar(52);

    chain #PTKBAN TOKTAB customer;
    if %found(TOKTAB);
        dsply   ('B:'+ customer.TKNAKJ);//更新前の得意先名漢字
        customer.TKNAKJ = #PTOKKJ;
        update  TOKMSR customer;
        dsply   ('A:'+ customer.TKNAKJ);//更新後の得意先名漢字
    else;
        dsply_message = 'Not found';
        dsply   dsply_message;
    endif;

end-proc;