**free

ctl-opt dftname(hello);
ctl-opt dftactgrp(*no) main(main);
//---------------------
// main処理
// CALL PGM(XXXLIB/HELLO) PARM(('楽しもう' (*CHAR 30)))
//---------------------
dcl-proc main;
    dcl-pi *n;
        //追加行　パラメーターの定義をしてください
    end-pi;

    dsply   ('HELLOFFRPG!' + #message);
end-proc;