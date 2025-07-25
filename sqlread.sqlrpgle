**free

//---------------------
// sqlread.rpgle
// CALL PGM(XXXLIB/SQLREAD) PARM(('12345' (*CHAR 5)) ('虎ノ門太郎' (*CHAR 50))) 
// 概要：
// 指定された得意先番号（p_tokuisaki_number）より大きい得意先の得意先名漢字（TKNAKJ）を、
// 指定された値（p_tokuisaki_name_kanji）に一括更新します。
//
// 注意：
// ・TOKTABUPDファイルは、TKBANGが主キーの更新可能ファイルです。
// ・更新対象が存在しない場合は警告（SQLSTATE='02'）となります。
//---------------------

ctl-opt dftactgrp(*no) main(main);

dcl-proc main;
  dcl-pi *n;
    p_tokuisaki_number char(5);//得意先番号
    p_tokuisaki_name_kanji char(50);//得意先名漢字
  end-pi;

  exec sql
    UPDATE TOKTABUPD
       SET TKNAKJ = :p_tokuisaki_name_kanji
     WHERE TKBANG > :p_tokuisaki_number;

  //SQLSTATEの先頭2桁（クラスコード）を抽出  
  SQLSTATE = %subst(SQLSTATE:1:2); 
  
  // SQLSTATEに応じた結果表示
  select;
    when SQLSTATE = '00';
      dsply '更新完了です！';
    when SQLSTATE = '02';
      dsply '対象データがありません。';
    other;
      dsply ('更新失敗です！ SQLSTATE=' + SQLSTATE);
    endsl;

end-proc;