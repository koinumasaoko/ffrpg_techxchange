**free

ctl-opt dftname(hello);
ctl-opt dftactgrp(*no) main(main);
//---------------------
// main処理
// CALL PGM(XXXLIB/HELLO) PARM(('楽しもう' (*CHAR 30)))
//---------------------
dcl-proc main;
    dcl-pi *n;
        #message char(30);
    end-pi;

    dsply   ('HELLOFFRPG!' + #message);
end-proc;