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
      p_tokuisaki_number char(5);//得意先番号
      p_tokuisaki_name_kanji char(50);//得意先名漢字
   end-pi;

   //ファイル定義
   dcl-f TOKTABUPD disk usage(*update) keyed; 
   //ファイルと同じdatastructureを定義
   dcl-ds ds_customer likerec(TOKTABUPDR:*all);

   // 得意先番号でレコード位置を設定
   setll p_tokuisaki_number TOKTABUPD;
   // READした結果をds_customerに格納
   read TOKTABUPD ds_customer;

   // レコードが存在する限りループ
   dow not %eof(TOKTABUPD);
   
   // 条件に合致するか確認（TKBANG > p_tokuisaki_number）
      if ds_customer.TKBANG > p_tokuisaki_number;
         dsply ('TKBANG:' + ds_customer.TKBANG);
         // 更新前の得意先名漢字を表示
         dsply ('B:' + ds_customer.TKNAKJ);
         // ここでds_customer.TKNAKJにp_tokuisaki_name_kanjiの値をセット
         ds_customer.TKNAKJ = p_tokuisaki_name_kanji;
         // 更新処理
         update TOKTABUPDR ds_customer;
         // 更新後の得意先名漢字を表示
         dsply ('A:' + ds_customer.TKNAKJ);
      endif;

      // 次のレコードを読み込む
      read TOKTABUPD ds_customer;
   enddo;
end-proc ;

