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
        p_tokuisaki_number char(5);//得意先番号
        p_tokuisaki_name_kanji char(50);//得意先名漢字
    end-pi;

    //レコード様式をTOKTAB→TOKMSRへRENAME
    dcl-f TOKTAB disk usage(*update) keyed rename(TOKTAB:TOKMSR); 

    dcl-ds  ds_customer likerec(TOKMSR:*all);

    //追加行　独立フィールドを定義してください　フィールド名は「dsply_message」で、varchar(52)で定義をしてください。
    
    //追加行 p_tokuisaki_numberをキーにしてchainをしてください
    if %found(TOKTAB);
        dsply   ('B:'+ ds_customer.TKNAKJ);//更新前の得意先名漢字
        ds_customer.TKNAKJ = p_tokuisaki_name_kanji;
        update  TOKMSR ds_customer;
        // 追加行　変更後の得意先名漢字dsply命令で出力してください
    else;
        dsply_message = 'Not found';
        dsply   dsply_message;
    endif;

end-proc;