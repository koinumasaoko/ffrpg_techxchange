**free

ctl-opt dftname(read);
ctl-opt dftactgrp(*no)  main(main);

//---------------------
// read.rpgle
// CALL PGM(XXXLIB/READ) PARM(('12345' (*CHAR 5)) ('虎ノ門太郎' (*CHAR 50))) 
// 概要：
// TOKTABUPDファイルを更新するサンプルプログラムです。
// 更新条件：パラメーターの得意先番号より大きな得意先番号のレコードの得意先名漢字を更新します。
// 注意：
// 1. TOKTABUPDファイルは、TOKBANGがPrimaryKeyに指定されている到着順のファイルです。
//---------------------

dcl-proc    main;
   //parameters
   dcl-pi *n;
      #PTKBAN char(5);//得意先番号
      #PTOKKJ char(50);//得意先名漢字
   end-pi;

   //ファイル定義
   dcl-f TOKTABUPD disk usage(*update) keyed; 
   //ファイルと同じdatastructureを定義
   dcl-ds customer likerec(TOKTABUPDR:*all);

   // 得意先番号でレコード位置を設定
   setll #PTKBAN TOKTABUPD;
   // READした結果をcustomerに格納
   read TOKTABUPD customer;

   // レコードが存在する限りループ
   dow not %eof(TOKTABUPD);
   
   // 条件に合致するか確認（TKBANG > #PTKBAN）
      if customer.TKBANG > #PTKBAN;
         dsply ('TKBANG:' + customer.TKBANG);
         // 更新前の得意先名漢字を表示
         dsply ('B:' + customer.TKNAKJ);
         // ここでcustomer.TKNAKJに#PTOKKJの値をセット
         customer.TKNAKJ = #PTOKKJ;
         // 更新処理
         update TOKTABUPDR customer;
         // 更新後の得意先名漢字を表示
         dsply ('A:' + customer.TKNAKJ);
      endif;

      // 次のレコードを読み込む
      read TOKTABUPD customer;
   enddo;
end-proc ;

