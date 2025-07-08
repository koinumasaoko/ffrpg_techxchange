**free
ctl-opt dftactgrp(*no) main(main);

//---------------------
// sqldiag.rpgle
// CALL PGM(XXXLIB/SQLDIAG) PARM(('12345' (*CHAR 5)) ('虎ノ門太郎' (*CHAR 50))) 
//
// 概要：
// このプログラムは、指定された得意先番号（#PTKBAN）より大きい得意先の
// 得意先名漢字（TKNAKJ）を指定された値（#PTOKKJ）に一括更新します。
// 更新後、GET DIAGNOSTICS を使って実行結果の詳細情報を取得・表示します。
//
// 目的：
// SQLSTATE や SQLCODE だけでは分からない、更新件数やメッセージ内容を
// GET DIAGNOSTICS を使って取得する方法を学びます。
//
// 注意：
// ・SQL文の直後に GET DIAGNOSTICS を記述する必要があります。
// ・SQLCAの明示は不要ですが、詳細情報を取得するには変数の準備が必要です。
//---------------------

dcl-proc main;

    // パラメータ定義
    dcl-pi *n;
        #PTKBAN char(5);// 得意先番号（更新対象の下限）
        #PTOKKJ char(50);// 新しい得意先名漢字
    end-pi;

    // 変数定義（GET DIAGNOSTICS 用）
    dcl-s upd_count int(10);
    dcl-s MessageId char(10);
    dcl-s MessageText varchar(40);
    dcl-s ReturnedSQLCode int(10); 
    dcl-s ReturnedSQLState char(5);
    dcl-s SQLStatePrefix char(2);

    //UPDATE文を実行
    exec sql
        UPDATE TOKTABUPD
        SET TKNAKJ = :#PTOKKJ
        WHERE TKBANG > :#PTKBAN;
    
        // GET DIAGNOSTICS文で実行結果の詳細を取得
        exec sql
            GET DIAGNOSTICS
            :upd_count = ROW_COUNT;
        
        exec sql
            GET DIAGNOSTICS CONDITION 1
            :ReturnedSqlCode = DB2_RETURNED_SQLCODE,
            :ReturnedSQLState = RETURNED_SQLSTATE,
            :MessageText = MESSAGE_TEXT,
            :MessageId = DB2_MESSAGE_ID; 
    
    // ReturnedSQLStateの上2二桁が00（正常）か確認
    SQLStatePrefix = %subst(ReturnedSQLState:1:2); 
    if SQLStatePrefix = '00';
        // 結果を表示
        dsply ('更新件数：' + %char(upd_count));
    else;
        // エラー時のメッセージ
        dsply '更新失敗しました';
    endif;

    // 実行結果の詳細を表示
    dsply ('SQLSTATE：' + ReturnedSQLState);
    dsply ('SQLCODE：' + %char(ReturnedSQLCode));
    dsply ('MSGID：' + MessageId);
    dsply ('MSGTEXT：' + MessageText);

end-proc;