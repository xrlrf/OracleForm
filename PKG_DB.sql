/*...5....10....15....20....25....30....35....40....45....50....55....60....65....70
+==================================================================================+
|             Copyright (C) 2004 NS Solutions Corporation,                         |
|                         All Rights Reserved.                                     |
+==================================================================================+
* ==================================================================================
*
*   NAME  pkg_db
*   COMMONS｣ｺDBｸ・ﾂﾓﾃｵﾄPACKAGE
*
*   DESCRIPTION
*
*   HISTORY
*        1.00  2005/07/13  kan li(P@W)
* =================================================================================*/
PACKAGE BODY pkg_db IS
    -- --------------------------------------------------------------------------------
    -- Program Name      : in_table
    -- Description       : ｵﾇﾂｼｴｦﾀ・
    -- Arguments         : st1 out varchar2
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE in_table(st1 OUT VARCHAR2) IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_DB.in_table:';
        --cursor ｶｨﾒ・--- DB : ﾊﾜﾗ｢
        CURSOR c_1 IS
            SELECT *
              FROM ordar o
             WHERE o.ordno = :b1.ordno;
        wc_ordar c_1%ROWTYPE;
        --cursor ｶｨﾒ・--- DB : ｵ邯ﾆﾎCOIL 
        CURSOR c_2 IS
            SELECT *
              FROM etcol e
             WHERE e.etlcno = :b1.etlcno;
        wc_etcol c_2%ROWTYPE;
        -- cursor ｶｨﾒ・--- DB : SHL ﾉ嵂愑・・
        CURSOR c_3 IS
            SELECT *
              FROM shsch s
             WHERE s.prcscd = :b1.procd -- add by xgb XXX 
               AND s.shlpgno = :b1.shlpgno;
        wc_shsch c_3%ROWTYPE;
        CURSOR c_4 IS
            SELECT o.stlgrd
              FROM ordar o,
                   shsch s
             WHERE s.prcscd = :b1.procd -- add by xgb XXX 
               AND s.shlpgno = :b1.shlpgno
               AND o.ordno = s.exorno1;
        -- cursor ｶｨﾒ・--- DB : ｹ､ｳﾌﾇ魍ｨ 
        CURSOR c_5 IS
            SELECT *
              FROM mprcs m
             WHERE m.prcscd = :b1.procd;
        wc_mprcs c_5%ROWTYPE;
        -- added by zhangtao 2005/10/11 for design change. begin
        -- cursor ｶｨﾒ・--- DB : SHL ﾍｨﾋｳDB 
        CURSOR c_6 IS
            SELECT *
              FROM shnum s
             WHERE s.shlpgno = :b1.shlpgno
               AND s.prcscd = :b1.procd;
        wc_shnum c_6%ROWTYPE;
        -- added by zhangtao 2005/10/11 for design change. end
    
        wc_stlgd c_4%ROWTYPE;
        w_packno VARCHAR2(7);
        w_isplno VARCHAR2(8);
        w_smalno VARCHAR2(8);
        w_cd     VARCHAR2(1);
        w_workdt DATE;
        w_worksf VARCHAR2(1);
        w_caseno VARCHAR2(6);
        w_widch  VARCHAR2(1);
        w_widex  VARCHAR2(1);
        w_thkex  VARCHAR2(1);
        w_slfg   CHAR(1);
        w_exfg   CHAR(1);
        w_rtonh  NUMBER(4, 1);
        --w_thick  NUMBER;
        --w_width  NUMBER;
        --w_length NUMBER;
        w_status VARCHAR2(1);
        st2      CHAR(1);
        st3      CHAR(1);
        st4      CHAR(1);
    BEGIN
        -- logｼﾍﾂｼ
        msg.ed_log('I', 1, :system.current_form, pg_id || 'start');
        -- ﾗｴﾌｬｳｼｻｯ 
        st1 := NULL;
        st2 := NULL;
        st3 := NULL;
        st4 := NULL;
        -- ﾊｾﾝｲﾙﾗ・
        IF st1 IS NULL THEN
            -- ｴｪcursor 
            OPEN c_1;
            OPEN c_2;
            OPEN c_3;
            OPEN c_4;
            OPEN c_5;
            FETCH c_1
                INTO wc_ordar;
            FETCH c_2
                INTO wc_etcol;
            FETCH c_3
                INTO wc_shsch;
            FETCH c_4
                INTO wc_stlgd;
            FETCH c_5
                INTO wc_mprcs;
            -- 此时的lotcd已经不为空了，根据lotcd输入的值来进行判断
            IF :b2.lotcd = '1' THEN
                --ﾖﾆﾆｷｷｬｺﾅﾈ｡ｵﾃｴｦﾀ・
                msg.ed_log('I', 2, :system.current_form, 'ed_packno parameter :b1.procd:' || :b1.procd);                                                             
                dbcommon.ed_packno(:b1.procd, w_packno, w_cd, st2);
                msg.ed_log('I', 2, :system.current_form, 'ed_packno get w_packno:' || w_packno);
                msg.ed_log('I', 2, :system.current_form, 'ed_packno get w_cd:' || w_cd);
                msg.ed_log('I', 1, :system.current_form, 'ed_packno get status:' || st2);
                :b1.lotno   := w_packno || w_cd;
                :b1.n_lotno := w_packno;
                --Lotﾇﾖﾊﾇ2ｵﾄﾇ鯀・               
            ELSIF :b2.lotcd = '2' THEN
                --ﾒｪﾔﾙｼ・ｬｺﾅﾈ｡ｵﾃｴｦﾀ・
                msg.ed_log('I', 2, :system.current_form, 'ed_isplno parameter :b1.procd:' || :b1.procd);                                                                             
                dbcommon.ed_isplno(:b1.procd, w_isplno, st2);
                msg.ed_log('I', 2, :system.current_form, 'ed_isplno get w_isplno:' || w_isplno);  
                msg.ed_log('I', 1, :system.current_form, 'ed_isplno get status:' || st2);                              
                :b1.lotno := w_isplno;
                --Lotﾇﾖﾊﾇ3ｵﾄﾇ鯀・               
            ELSIF :b2.lotcd = '3' THEN
                --ｶﾋﾊｷｬｺﾅﾈ｡ｵﾃｴｦﾀ・
                msg.ed_log('I', 2, :system.current_form, 'ed_smalno parameter :b1.procd:' || :b1.procd);                                                                                             
                dbcommon.ed_smalno(:b1.procd, w_smalno, st2);
                msg.ed_log('I', 2, :system.current_form, 'ed_smalno get w_smalno:' || w_smalno);  
                msg.ed_log('I', 1, :system.current_form, 'ed_smalno get status:' || st2);                              
                :b1.lotno := w_smalno;
            END IF;
            -- ﾗｵﾈﾕｴﾎｵﾄﾈ｡ｵﾃ 
            dbcommon.ed_workdt(w_workdt, w_worksf);
            msg.ed_log('I', 2, :system.current_form, 'ed_smalno get w_workdt:' || w_workdt);  
            msg.ed_log('I', 2, :system.current_form, 'ed_smalno get w_worksf:' || w_worksf);                                          
            --ﾖﾆﾆｷｱ犲ﾅｱ桄ｾｱ狆ｭ
            
            --Modified by Liupeizhi 20130704  begin -------------------------------
            --No.212  ｲｨｼﾓｹ､ﾃｳﾒﾗｲﾄﾐ靨ｪﾔﾚﾕﾋﾆｱﾉﾏｳｦCaseno
            /*IF substr(:b1.ordno, 1, 1) = 'Y' THEN*/
            IF	substr(:b1.ordno, 1, 1) IN ('Y','B')
                   OR substr(:b1.ordno, 1, 2) BETWEEN 'JA' AND 'JZ' THEN	
            --Modified by Liupeizhi 20130704  end   -------------------------------
                IF (:b2.lotcd = '1')
                   AND (:b2.grade = '1' OR :b2.grade = '2' OR :b2.grade = 'A') THEN
                    --lotcd ﾎｪ'1'ｲ｢ﾇﾒ grade ﾎｪ'1,2,A'
                    msg.ed_log('I', 2, :system.current_form, 'ed_caseno parameter :b1.ordno:' || :b1.ordno);                                                                                                                 
                    dbcommon.ed_caseno(:b1.ordno, w_caseno, st3);
                    msg.ed_log('I', 2, :system.current_form, 'ed_caseno get w_caseno:' || w_caseno);  
                    msg.ed_log('I', 1, :system.current_form, 'ed_caseno get status:' || st3);                              
                    IF st3 != '0' THEN
                        st1 := '1';
                        CLOSE c_1;
                        CLOSE c_2;
                        CLOSE c_3;
                        CLOSE c_4;
                        CLOSE c_5;
                        RETURN;
                    END IF;
                ELSE
                    w_caseno := NULL;
                END IF;
            END IF;
            -- ｱ・ｾﾉ靹ﾃ : widch(S/L) --- ｵｱordno = '99999999'ﾊｱ 
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.prewid:' || wc_etcol.prewid);  
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.exorno1:'|| wc_etcol.exorno1);  
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.widex1:' || wc_etcol.widex1);  
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.widch1:' || wc_etcol.widch1);  
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.thkex1:' || wc_etcol.thkex1);  
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.prethk:' || wc_etcol.prethk);  
            msg.ed_log('I', 2, :system.current_form, 'get wc_ordar.orthk:'  || wc_ordar.orthk); 
            msg.ed_log('I', 2, :system.current_form, 'get wc_ordar.orlen:'  || wc_ordar.orlen);  
            msg.ed_log('I', 2, :system.current_form, 'get wc_ordar.orwid:'  || wc_ordar.orwid);  
            IF :b1.ordno = '99999999' THEN
                IF wc_etcol.prewid = :b2.prewid THEN
                    w_slfg  := 'S';
                    w_widch := 'S';
                ELSIF wc_etcol.prewid = :b2.prelen THEN
                    w_slfg  := 'L';
                    w_widch := 'L';
                END IF;
            END IF;
            --ｱ・ｾﾉ靹ﾃ : ｳ､ｱﾟ｣ｬｿ敎ﾟ｣ｬｺﾈ
            IF :b1.ordno = wc_etcol.exorno1 THEN
                w_widch := wc_etcol.widch1;
                w_widex := wc_etcol.widex1;
                w_thkex := wc_etcol.thkex1;
            END IF;
            IF (w_widex IS NOT NULL AND w_thkex IS NOT NULL) THEN
                w_exfg := 'D';
            ELSIF w_widex IS NOT NULL THEN
                w_exfg := 'W';
            ELSIF w_thkex IS NOT NULL THEN
                w_exfg := 'T';
            ELSE
                w_exfg := NULL;
            END IF;
             -- logｼﾍﾂｼ
            msg.ed_log('I', 1, :system.current_form, 'w_exfg:='|| w_exfg );
            msg.ed_log('I', 2, :system.current_form, 'debug here1');                                                                                                                 
            /* commented by mot at 20060109
            SELECT decode(:b1.ordno,
                          '99999999',
                          wc_etcol.prethk,
                          decode(w_exfg,
                                 'D',
                                 wc_etcol.prethk,
                                 'W',
                                 wc_ordar.orthk,
                                 'T',
                                 wc_etcol.prethk,
                                 wc_ordar.orthk))
              INTO w_thick
              FROM dual;
        
            msg.ed_log('I', 2, :system.current_form, 'debug here2');                                                                                                                 

            SELECT decode(:b1.ordno,
                          '99999999',
                          :b2.prewid,
                          decode(w_exfg,
                                 'D',
                                 decode(w_widch,
                                        'S',
                                        wc_etcol.prewid,
                                        'L',
                                        wc_ordar.orwid),
                                 'W',
                                 decode(w_widch,
                                        'S',
                                        wc_etcol.prewid,
                                        'L',
                                        wc_ordar.orwid),
                                 'T',
                                 wc_ordar.orwid,
                                 wc_ordar.orwid))
              INTO w_width
              FROM dual;

            msg.ed_log('I', 2, :system.current_form, 'debug here3');                                                                                                                 
        
            SELECT decode(:b1.ordno,
                          '99999999',
                          :b2.prelen,
                          decode(w_exfg,
                                 'D',
                                 decode(w_widch,
                                        'S',
                                        wc_ordar.orlen,
                                        'L',
                                        wc_etcol.prewid),
                                 'W',
                                 decode(w_widch,
                                        'S',
                                        wc_ordar.orlen,
                                        'L',
                                        wc_etcol.prewid),
                                 'T',
                                 wc_ordar.orlen,
                                 wc_ordar.orlen))
              INTO w_length
              FROM dual;
              
            msg.ed_log('I', 2, :system.current_form, 'ed_sthr parameter w_thick:' || w_thick);                                                                                                                 
            msg.ed_log('I', 2, :system.current_form, 'ed_sthr parameter w_width:' || w_width);                                                                                                                 
            msg.ed_log('I', 2, :system.current_form, 'ed_sthr parameter w_length:' || w_length);
            */                                                                                                                 
            --ﾀ曺ﾛT/Hｼﾆﾋ・
            --common.ed_sthr(w_thick, w_width, w_length, w_rtonh, w_status);
            common.ed_sthr(wc_etcol.prethk, wc_etcol.prewid, null, w_rtonh, w_status);
            IF w_status != 0 THEN
                w_rtonh := NULL;
            END IF;
            msg.ed_log('I', 2, :system.current_form, 'ed_sthr get w_rtonh:' || w_rtonh);  
            msg.ed_log('I', 1, :system.current_form, 'ed_sthr get status:' || w_status);                              

            --ｲ衒・ﾙﾗ・--- DB :SHL ﾉ嵂摠ｵｼｨ 
            INSERT INTO rtshl
                (prcscd,
                 workdt,
                 worksf,
                 wokumi,
                 shlpgno,
                 prdcd,
                 packno,
                 pdivno,
                 credt,
                 brcd,
                 nocd,
                 rtstat,
                 prdty,
                 proccd,
                 cscd,
                 nsccd,
                 prddt,
                 tmbpno,
                 hflag,  -- add by zyt 20100331 No.145
                 etlcno,
                 exorno,
                 thkex,
                 widex,
                 widch,
                 splcd,
                 --tstcd,
                 grade,
                 cstcd,
                 stlgrd,
                 orthk,
                 orwid,
                 orlen,
                 numppkg,
                 pkgty,
                 ordwg,
                 widcd,
                 dlvdt,
                 coatwg,
                 coatwgfg,	-- add by zyt 20090814 No.114
                 mtrthk,
                 mtrwid,
                 prethk,
                 shwid,
                 shlen,
                 mtrwg,
                 prdwg,
                 prdnum,
                 anlcd,
                 stldsc,
                 temper,
                 sfcfcd,
                 ispstd,
                 usecd,
                 oilty,
                 chcd,
                 ancocd,
                 reflow,
                 mgcd,
                 mglng,
                 mgsht,
                 rpmemocd,
                 rpmemo,
                 isprscd,
                 hdrscd,
                 hdrscd2,
                 hlddt,
                 prdtm,
                 ispcter,
                 caseno,
                 skid,
                 rtonh,
                 jtonh,
                 prdjwg,
                 scrlty,
                 fromcd) -- Added by zyt 20130903 For WinSteel
            VALUES
                (:b1.procd,
                 w_workdt,
                 w_worksf,
                 wc_mprcs.ikumi,
                 :b1.shlpgno,
                 :b2.lotcd,
                 :b1.lotno,
                 :b1.pdivno,
                 SYSDATE,
                 'B',
                 'N',
                 '1',
                 wc_etcol.prdty,
                 wc_etcol.proccd,
                 wc_etcol.cscd,
                 wc_etcol.nsccd,
                 wc_etcol.prddt,
                 wc_etcol.tmbpno,
                 wc_etcol.hflag,  -- add by zyt 20100331 No.145
                 :b1.etlcno,
                 :b1.ordno,
                 decode(:b1.ordno, wc_etcol.exorno1, wc_etcol.thkex1, NULL),
                 decode(:b1.ordno, wc_etcol.exorno1, wc_etcol.widex1, NULL),
                 decode(:b1.ordno,
                        '99999999',
                        decode(w_slfg, 'S', 'S', 'L', 'L'),
                        wc_etcol.exorno1,
                        wc_etcol.widch1),
                 wc_ordar.splcd,
                 --wc_etcol.tstmtr,
                 :b2.grade,
                 wc_ordar.cstcd,
                 decode(:b1.ordno, '99999999', wc_stlgd.stlgrd, wc_ordar.stlgrd),
                 decode(:b1.ordno,
                        '99999999',
                        wc_etcol.prethk,
                        decode(w_exfg,
                               'D',
                               wc_etcol.prethk,
                               'W',
                               wc_ordar.orthk,
                               'T',
                               wc_etcol.prethk,
                               wc_ordar.orthk)),
                 decode(:b1.ordno,
                        '99999999',
                        :b2.prewid,
                        decode(w_exfg,
                               'D',
                               decode(w_widch,
                                      'S',
                                      wc_etcol.prewid,
                                      'L',
                                      wc_ordar.orwid),
                               'W',
                               decode(w_widch,
                                      'S',
                                      wc_etcol.prewid,
                                      'L',
                                      wc_ordar.orwid),
                               'T',
                               wc_ordar.orwid,
                               wc_ordar.orwid)),
                 decode(:b1.ordno,
                        '99999999',
                        :b2.prelen,
                        decode(w_exfg,
                               'D',
                               decode(w_widch,
                                      'S',
                                      wc_ordar.orlen,
                                      'L',
                                      wc_etcol.prewid),
                               'W',
                               decode(w_widch,
                                      'S',
                                      wc_ordar.orlen,
                                      'L',
                                      wc_etcol.prewid),
                               'T',
                               wc_ordar.orlen,
                               wc_ordar.orlen)),
                 wc_ordar.numppkg,
                 wc_ordar.pkgty,
                 wc_ordar.ordwg,
                 NULL,
                 wc_ordar.dlvdt,
                 decode(:b1.ordno, '99999999', wc_etcol.coatwg, wc_ordar.coatwg),
                 decode(:b1.ordno, '99999999', wc_etcol.coatwgfg, wc_ordar.coatwgfg),	-- add by zyt 20090814 No.114
                 wc_etcol.prethk,
                 wc_etcol.prewid,
                 NULL,
                 decode(:b1.ordno,
                        '99999999',
                        decode(w_slfg, 'S', :b2.prewid, 'L', :b2.prelen),
                        decode(w_exfg,
                               'D',
                               wc_etcol.prewid,
                               'W',
                               wc_etcol.prewid,
                               'T',
                               wc_ordar.shwid,
                               wc_ordar.shwid)),
                 decode(:b1.ordno,
                        '99999999',
                        decode(w_slfg, 'S', :b2.prelen, 'L', :b2.prewid),
                        decode(w_exfg,
                               'D',
                               wc_ordar.shlen,
                               'W',
                               wc_ordar.shlen,
                               'T',
                               wc_ordar.shlen,
                               wc_ordar.shlen)),
                 decode(:b1.pdivno, 1, wc_etcol.prewg, 0),
                 :b3.n_lotwg,
                 :b2.prdnum,
                 wc_etcol.anlcd,
                 wc_etcol.stldsc,
                 wc_etcol.temper,
                 wc_etcol.sfcfcd,
                 wc_etcol.ispstd,
                 wc_ordar.usecd,
                 wc_etcol.oilty,
                 wc_etcol.chcd,
                 wc_etcol.ancocd,
                 wc_etcol.reflow,
                 wc_ordar.mgcd,
                 wc_ordar.mglng,
                 wc_ordar.mgsht,
                 :b2.rpmemocd,
                 :b2.rpmemo,
                 NULL,
                 :b2.hdrscd,
                 :b2.hdrscd2,
                 decode(:b2.hdrscd, NULL, NULL, SYSDATE),
                 :b2.prdtm,
                 :b1.ispcter,
                 w_caseno,
                 :b1.skid,
                 w_rtonh,
                 (nvl(:b3.n_lotwg,0) / :b2.prdtm / 1000 * 60), -- change by xgb 20051102
                 :b2.prdwg,
                 --2016/11/15 ｲｨｼﾞﾕｶﾔﾓｦ MDK MOD START 
                 --decode(substr(wc_ordar.ordno,1,1),'J',wc_ordar.scrlty,null),
                 decode(substr(wc_ordar.ordno,1,1),'J',wc_ordar.scrlty,'B',wc_ordar.scrlty,null),
                 --2016/11/15 ｲｨｼﾞﾕｶﾔﾓｦ MDK MOD END 
                 wc_etcol.fromcd); -- Added by zyt 20130903 For WinSteel
                 msg.ed_log('I', 2, :system.current_form, 'insert into rtshl(b1.shlpgno:)'||:b1.shlpgno);                                                          
                 
            -- ｸ・ﾂｲﾙﾗ・--- DB : SHL ﾉ嵂愑・・
            UPDATE shsch s
               SET s.workfg = '1',
                   s.etlcno = decode(s.etlcno,null,:b1.n_etlcno,s.etlcno),-- add by xgb 20051102
                   s.enddt  = SYSDATE,
                   s.sumwg  = nvl(wc_shsch.sumwg, 0) + nvl(:b3.n_lotwg,0),
                   s.pdivno = :b1.pdivno,
                   s.packno = :b1.lotno,
                   s.uptpg1 = 'HGF02',
                   s.uptdt1 = SYSDATE,
                   s.uptpg2 = wc_shsch.uptpg1,
                   s.uptdt2 = wc_shsch.uptdt1,
                   s.uptpg3 = wc_shsch.uptpg2,
                   s.uptdt3 = wc_shsch.uptdt2
             WHERE s.prcscd = :b1.procd -- add by xgb XXX 
               AND s.shlpgno = :b1.shlpgno;
            msg.ed_log('I', 2, :system.current_form, 'UPDATE shsch(b1.shlpgno:)'||:b1.shlpgno||' UPDATE shsch:'|| SQL%ROWCOUNT);                                                          
            --ｸ・ﾂｲﾙﾗ・--- DB : ｵ邯ﾆﾎCOIL 
            IF nvl(wc_shsch.pdivno, 0) = 0 THEN
                UPDATE etcol e
                   SET e.shlend = '1',
                       e.shldt  = SYSDATE,
                       e.shltdt = w_workdt,
                       e.shltsf = w_worksf,
                       e.uptpg1 = 'HGF02',
                       e.uptdt1 = SYSDATE,
                       e.uptpg2 = wc_etcol.uptpg1,
                       e.uptdt2 = wc_etcol.uptdt1,
                       e.uptpg3 = wc_etcol.uptpg2,
                       e.uptdt3 = wc_etcol.uptdt2
                 WHERE e.etlcno = :b1.etlcno;
            msg.ed_log('I', 2, :system.current_form, 'UPDATE etcol(b1.etlcno:)'||:b1.etlcno||' UPDATE  etcol:'|| SQL%ROWCOUNT);                                                                           
            END IF;
            IF (:b2.lotcd = '1')
               AND (:b2.grade = '1' OR :b2.grade = '2' OR :b2.grade = 'A') THEN
                -- ｸ・ﾂｲﾙﾗ・--- DB : ﾊﾜﾗ｢
                UPDATE ordar 
                   SET exnum = nvl(exnum, 0) + 1,
                       uptpg1 = 'FGF03',
	                     uptdt1 = SYSDATE,
	                     uptpg2 = uptpg1,
	                     uptdt2 = uptdt1,
	                     uptpg3 = uptpg2,
	                     uptdt3 = uptdt2 
                 WHERE ordno = :b1.ordno;
                msg.ed_log('I', 2, :system.current_form, 'UPDATE ordar  ordno:'||:b1.ordno ||'exnum:'||wc_ordar.exnum||' UPDATE  ordar:'|| SQL%ROWCOUNT);                                                                                            
            END IF;
            -- ｲ衒・ﾙﾗ・              
            IF :b2.lotcd = '1' THEN
                --ｲ衒・ﾙﾗ・-- DB : ﾂ暠ﾚﾌ晗ﾆﾆｷ 
                INSERT INTO packg
                    (packno,
                     packcd,
                     credt,
                     endfg,
                     enddt,
                     workdt,
                     worksf,
                     prdfg,
                     entdt,
                     inhld,
                     shpsut,
                     prdty,
                     proccd,
                     prvdtst,
                     cscd,
                     nsccd,
                     prddt,
                     tmbpno,
                     hflag,  -- add by zyt 20100331 No.145
                     etlcno,
                     isplno,
                     pdivno,
                     ordno,
                     thkex,
                     widex,
                     widch,
                     orsize,
                     grade,
                     prdthk,
                     prdwid,
                     prdlen,
                     shwid,
                     shlen,
                     etthk,
                     etwid,
                     prdnum,
                     prdwg,
                     contweit,
                     prdjwg,
                     stlgrd,
                     trwg,
                     pkgty,
                     coatwg,
		                 coatwgfg,	-- add by zyt 20090814 No.114
                     anlcd,
                     stldsc,
                     temper,
                     sfcfcd,
                     ispstd,
                     usecd,
                     oilty,
                     rpmemocd,
                     rpmemo,
                     chcd,
                     ancocd,
                     reflow,
                     mgcd,
                     mglng,
                     mgsht,
                     prdyd,
                     hdrscd,
                     hdrscd2,
                     hlddt,
                     resdt,
                     rerscd,
                     shlpgno,
                     ispcter,
                     dlvlno,
                     prdcln,
                     isplno1,
                     ispnum1,
                     isplno2,
                     ispnum2,
                     isplno3,
                     ispnum3,
                     caseno,
                     wgmin,
                     wgmax,
                     skid,
                     sleeve,
                     uptpg1,
                     uptdt1,
                     uptpg2,
                     uptdt2,
                     uptpg3,
                     uptdt3,
                     fromcd, -- Added by zyt 20130903 For WinSteel
            				 namifg,  -- added by xipj 2011/07/25 No.168
                     -- added by zhangtao 2005/10/11 . begin
                     qltcd,
                     scrlty)
                     -- added by zhangtao 2005/10/11 . end
                VALUES
                    (:b1.n_lotno,
                     w_cd,
                     SYSDATE,
                     decode(:b2.grade, '9', '5', 'S', '5', NULL),
                     decode(:b2.grade, '9', SYSDATE, 'S', SYSDATE, NULL),
                     w_workdt,
                     w_worksf,
                     NULL,
                     NULL,
                     decode(:b2.hdrscd, NULL, NULL, '1'),
                     NULL,
                     wc_etcol.prdty,
                     wc_etcol.proccd,
                     wc_etcol.prvdtst,
                     wc_etcol.cscd,
                     wc_etcol.nsccd,
                     wc_etcol.prddt,
                     wc_etcol.tmbpno,
                     wc_etcol.hflag,  -- add by zyt 20100331 No.145
                     :b1.etlcno,
                     NULL,
                     :b1.pdivno,
                     :b1.ordno,
                     decode(:b1.ordno, wc_etcol.exorno1, wc_etcol.thkex1, NULL),
                     decode(:b1.ordno, wc_etcol.exorno1, wc_etcol.widex1, NULL),
                     decode(:b1.ordno,
                            '99999999',
                            decode(w_slfg, 'S', 'S', 'L', 'L'),
                            wc_etcol.exorno1,
                            wc_etcol.widch1),
                     decode(:b1.ordno, '99999999', NULL, wc_ordar.orsize),
                     :b2.grade,
                     decode(:b1.ordno,
                            '99999999',
                            wc_etcol.prethk,
                            decode(w_exfg,
                                   'D',
                                   wc_etcol.prethk,
                                   'W',
                                   wc_ordar.orthk,
                                   'T',
                                   wc_etcol.prethk,
                                   wc_ordar.orthk)),
                     decode(:b1.ordno,
                            '99999999',
                            :b2.prewid,
                            decode(w_exfg,
                                   'D',
                                   decode(w_widch,
                                          'S',
                                          wc_etcol.prewid,
                                          'L',
                                          wc_ordar.orwid),
                                   'W',
                                   decode(w_widch,
                                          'S',
                                          wc_etcol.prewid,
                                          'L',
                                          wc_ordar.orwid),
                                   'T',
                                   wc_ordar.orwid,
                                   wc_ordar.orwid)),
                     decode(:b1.ordno,
                            '99999999',
                            :b2.prelen,
                            decode(w_exfg,
                                   'D',
                                   decode(w_widch,
                                          'S',
                                          wc_ordar.orlen,
                                          'L',
                                          wc_etcol.prewid),
                                   'W',
                                   decode(w_widch,
                                          'S',
                                          wc_ordar.orlen,
                                          'L',
                                          wc_etcol.prewid),
                                   'T',
                                   wc_ordar.orlen,
                                   wc_ordar.orlen)),
                     decode(:b1.ordno,
                            '99999999',
                            decode(w_slfg, 'S', :b2.prewid, 'L', :b2.prelen),
                            decode(w_exfg,
                                   'D',
                                   wc_etcol.prewid,
                                   'W',
                                   wc_etcol.prewid,
                                   'T',
                                   wc_ordar.shwid,
                                   wc_ordar.shwid)),
                     decode(:b1.ordno,
                            '99999999',
                            decode(w_slfg, 'S', :b2.prelen, 'L', :b2.prewid),
                            decode(w_exfg,
                                   'D',
                                   wc_ordar.shlen,
                                   'W',
                                   wc_ordar.shlen,
                                   'T',
                                   wc_ordar.shlen,
                                   wc_ordar.shlen)),
                     wc_etcol.prethk,
                     wc_etcol.prewid,
                     :b2.prdnum,
                     :b3.n_lotwg,
                     wc_ordar.contweit,
                     :b2.prdwg,
                     decode(:b1.ordno,
                            '99999999',
                            wc_stlgd.stlgrd,
                            wc_ordar.stlgrd),
                     wc_ordar.trwg,
                     wc_ordar.pkgty,
                     decode(:b1.ordno,
                            '99999999',
                            wc_etcol.coatwg,
                            wc_ordar.coatwg),
                 		 decode(:b1.ordno,
                 		 				'99999999',
                 		 				wc_etcol.coatwgfg,
                 		 				wc_ordar.coatwgfg),	-- add by zyt 20090814 No.114
                     wc_etcol.anlcd,
                     wc_etcol.stldsc,
                     wc_etcol.temper,
                     wc_etcol.sfcfcd,
                     wc_etcol.ispstd,
                     wc_ordar.usecd,
                     wc_etcol.oilty,
                     :b2.rpmemocd,
                     :b2.rpmemo,
                     wc_etcol.chcd,
                     wc_etcol.ancocd,
                     wc_etcol.reflow,
                     wc_ordar.mgcd,
                     wc_ordar.mglng,
                     wc_ordar.mgsht,
                     NULL,
                     :b2.hdrscd,
                     :b2.hdrscd2,
                     decode(:b2.hdrscd, NULL, NULL, SYSDATE),
                     NULL,
                     NULL,
                     substr(substr('000', 1, 3 - length(:b1.shlpgno)) ||
                            :b1.shlpgno,
                            1,
                            3),
                     :b1.ispcter,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     w_caseno,
                     wc_ordar.wgmin,
                     wc_ordar.wgmax,
                     :b1.skid,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     wc_etcol.fromcd, -- Added by zyt 20130903 For WinSteel
                     --2016/11/03 ｲｨｼﾞﾕｶﾔﾓｦ MDK ADD START 
                     --decode(substr(wc_shsch.exorno1, 1, 1), 'J', '1', null),  -- added by xipj 2011/07/25 No.168
                     decode(substr(wc_shsch.exorno1, 1, 1), 'J', '1', 'B', '1', null), 
                     --2016/11/03 ｲｨｼﾞﾕｶﾔﾓｦ MDK ADD END 
                     -- added by zhangtao 2005/10/11 . begin
                     wc_ordar.qltcd,
                     --2016/11/15 ｲｨｼﾞﾕｶﾔﾓｦ MDK MOD START
                     --decode(substr(wc_ordar.ordno,1,1),'J',wc_ordar.scrlty,null));
                     decode(substr(wc_ordar.ordno,1,1),'J',wc_ordar.scrlty,'B',wc_ordar.scrlty,null));
                     --2016/11/15 ｲｨｼﾞﾕｶﾔﾓｦ MDK MOD END
                     -- added by zhangtao 2005/10/11 . end

                 msg.ed_log('I', 2, :system.current_form, 'insert into packg(PACKNO:)'||:b1.n_lotno);                                                                               
            ELSIF :b2.lotcd = '2' THEN
                --ｲ衒・ﾙﾗ・--- DB : ﾒｪﾔﾙｼ・OT 
                INSERT INTO isplt
                    (isplno,
                     credt,
                     endfg,
                     enddt,
                     rjtmtr,
                     rjtdt,
                     inhld,
                     prdty,
                     proccd,
                     cscd,
                     nsccd,
                     prddt,
                     tmbpno,
                     hflag,  -- add by zyt 20100331 No.145
                     etlcno,
                     pdivno,
                     exorno,
                     thkex,
                     widex,
                     widch,
                     stlgrd,
                     grade,
                     orsize,
                     prdthk,
                     prdwid,
                     prdlen,
                     shwid,
                     shlen,
                     prenum,
                     prewg,
                     isprscd,
                     coatwg,
		                 coatwgfg,	-- add by zyt 20090814 No.114
                     anlcd,
                     stldsc,
                     temper,
                     sfcfcd,
                     ispstd,
                     oilty,
                     chcd,
                     ancocd,
                     reflow,
                     mgcd,
                     mglng,
                     mgsht,
                     hdrscd,
                     hdrscd2,
                     hlddt,
                     resdt,
                     workdt,
                     worksf,
                     etcthk,
                     etcwid,
                     ispcter,
                     shlpgno,
                     uptpg1,
                     uptdt1,
                     uptpg2,
                     uptdt2,
                     uptpg3,
                     uptdt3,
                     fromcd, -- Added by zyt 20130903 For WinSteel
            				 namifg,  -- added by xipj 2011/07/25 No.168    
                     scrlty)
                VALUES
                    (:b1.lotno,
                     SYSDATE,
                     decode(:b2.grade, '9', '5', 'S', '5', NULL),
                     decode(:b2.grade, '9', SYSDATE, 'S', SYSDATE, NULL),
                     NULL,
                     NULL,
                     decode(:b2.hdrscd, NULL, NULL, '1'),
                     wc_etcol.prdty,
                     wc_etcol.proccd,
                     wc_etcol.cscd,
                     wc_etcol.nsccd,
                     wc_etcol.prddt,
                     wc_etcol.tmbpno,
                     wc_etcol.hflag,  -- add by zyt 20100331 No.145
                     :b1.etlcno,
                     :b1.pdivno,
                     :b1.ordno,
                     decode(:b1.ordno, wc_etcol.exorno1, wc_etcol.thkex1, NULL),
                     decode(:b1.ordno, wc_etcol.exorno1, wc_etcol.widex1, NULL),
                     decode(:b1.ordno,
                            '99999999',
                            decode(w_slfg, 'S', 'S', 'L', 'L'),
                            wc_etcol.exorno1,
                            wc_etcol.widch1),
                     decode(:b1.ordno,
                            '99999999',
                            wc_stlgd.stlgrd,
                            wc_ordar.stlgrd),
                     :b2.grade,
                     decode(:b1.ordno, '99999999', NULL, wc_ordar.orsize),
                     decode(:b1.ordno,
                            '99999999',
                            wc_etcol.prethk,
                            decode(w_exfg,
                                   'D',
                                   wc_etcol.prethk,
                                   'W',
                                   wc_ordar.orthk,
                                   'T',
                                   wc_etcol.prethk,
                                   wc_ordar.orthk)),
                     decode(:b1.ordno,
                            '99999999',
                            :b2.prewid,
                            decode(w_exfg,
                                   'D',
                                   decode(w_widch,
                                          'S',
                                          wc_etcol.prewid,
                                          'L',
                                          wc_ordar.orwid),
                                   'W',
                                   decode(w_widch,
                                          'S',
                                          wc_etcol.prewid,
                                          'L',
                                          wc_ordar.orwid),
                                   'T',
                                   wc_ordar.orwid,
                                   wc_ordar.orwid)),
                     decode(:b1.ordno,
                            '99999999',
                            :b2.prelen,
                            decode(w_exfg,
                                   'D',
                                   decode(w_widch,
                                          'S',
                                          wc_ordar.orlen,
                                          'L',
                                          wc_etcol.prewid),
                                   'W',
                                   decode(w_widch,
                                          'S',
                                          wc_ordar.orlen,
                                          'L',
                                          wc_etcol.prewid),
                                   'T',
                                   wc_ordar.orlen,
                                   wc_ordar.orlen)),
                     decode(:b1.ordno,
                            '99999999',
                            decode(w_slfg, 'S', :b2.prewid, 'L', :b2.prelen),
                            decode(w_exfg,
                                   'D',
                                   wc_etcol.prewid,
                                   'W',
                                   wc_etcol.prewid,
                                   'T',
                                   wc_ordar.shwid,
                                   wc_ordar.shwid)),
                     decode(:b1.ordno,
                            '99999999',
                            decode(w_slfg, 'S', :b2.prelen, 'L', :b2.prewid),
                            decode(w_exfg,
                                   'D',
                                   wc_ordar.shlen,
                                   'W',
                                   wc_ordar.shlen,
                                   'T',
                                   wc_ordar.shlen,
                                   wc_ordar.shlen)),
                     :b2.prdnum,
                     :b3.n_lotwg,
                     :b2.hdrscd,
                     decode(:b1.ordno,
                            '99999999',
                            wc_etcol.coatwg,
                            wc_ordar.coatwg),
                 		 decode(:b1.ordno,
                 		 				'99999999',
                 		 				wc_etcol.coatwgfg,
                 		 				wc_ordar.coatwgfg),	-- add by zyt 20090814 No.114
                     wc_etcol.anlcd,
                     wc_etcol.stldsc,
                     wc_etcol.temper,
                     wc_etcol.sfcfcd,
                     wc_etcol.ispstd,
                     wc_etcol.oilty,
                     wc_etcol.chcd,
                     wc_etcol.ancocd,
                     wc_etcol.reflow,
                     wc_ordar.mgcd,
                     wc_ordar.mglng,
                     wc_ordar.mgsht,
                     :b2.hdrscd,
                     :b2.hdrscd2,
                     decode(:b2.hdrscd, NULL, NULL, SYSDATE),
                     NULL,
                     w_workdt,
                     w_worksf,
                     NULL,
                     NULL,
                     :b1.ispcter,
                     substr(substr('000', 1, 3 - length(:b1.shlpgno)) ||
                            :b1.shlpgno,
                            1,
                            3),
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     wc_etcol.fromcd, -- Added by zyt 20130903 For WinSteel
                     --2016/11/03 ｲｨｼﾞﾕｶﾔﾓｦ MDK ADD START 
            				 --decode(substr(wc_shsch.exorno1, 1, 1), 'J', '1', null),  -- added by xipj 2011/07/25 No.168
            				 decode(substr(wc_shsch.exorno1, 1, 1), 'J', '1', 'B', '1', null),
                     --2016/11/03 ｲｨｼﾞﾕｶﾔﾓｦ MDK ADD END 
                     --2016/11/15 ｲｨｼﾞﾕｶﾔﾓｦ MDK MOD START
                     --decode(substr(wc_ordar.ordno,1,1),'J',wc_ordar.scrlty,null));
                     decode(substr(wc_ordar.ordno,1,1),'J',wc_ordar.scrlty,'B',wc_ordar.scrlty,null));
                     --2016/11/15 ｲｨｼﾞﾕｶﾔﾓｦ MDK MOD END
                 msg.ed_log('I', 2, :system.current_form, 'insert into ISPLT(ISPLNO:)'||:b1.lotno);                                                                                                    
            ELSIF :b2.lotcd = '3' THEN
                --ｲ衒・ﾙﾗ・--- DB : ｶﾋﾊLOT 
                INSERT INTO smalt
                    (smalno,
                     credt,
                     endfg,
                     enddt,
                     inhld,
                     prdty,
                     proccd,
                     cscd,
                     nsccd,
                     tmbpno,
                     hflag,  -- add by zyt 20100331 No.145
                     prddt,
                     etlcno,
                     pdivno,
                     exorno,
                     thkex,
                     widex,
                     widch,
                     stlgrd,
                     grade,
                     orsize,
                     prdthk,
                     prdwid,
                     prdlen,
                     shwid,
                     shlen,
                     prenum,
                     prewg,
                     coatwg,
		                 coatwgfg,	-- add by zyt 20090814 No.114
                     anlcd,
                     stldsc,
                     temper,
                     sfcfcd,
                     ispstd,
                     oilty,
                     chcd,
                     ancocd,
                     reflow,
                     mgcd,
                     mglng,
                     mgsht,
                     hdrscd,
                     hdrscd2,
                     hlddt,
                     resdt,
                     workdt,
                     worksf,
                     etcthk,
                     etcwid,
                     ispcter,
                     shlpgno,
                     uptpg1,
                     uptdt1,
                     uptpg2,
                     uptdt2,
                     uptpg3,
                     uptdt3,
                     fromcd, -- Added by zyt 20130903 For WinSteel
            				 namifg,  -- added by xipj 2011/07/25 No.168
            				 scrlty)
                VALUES
                    (:b1.lotno,
                     SYSDATE,
                     decode(:b2.grade, '9', '5', 'S', '5', NULL),
                     decode(:b2.grade, '9', SYSDATE, 'S', SYSDATE, NULL),
                     decode(:b2.hdrscd, NULL, NULL, '1'),
                     wc_etcol.prdty,
                     wc_etcol.proccd,
                     wc_etcol.cscd,
                     wc_etcol.nsccd,
                     wc_etcol.tmbpno,
                     wc_etcol.hflag,  -- add by zyt 20100331 No.145
                     wc_etcol.prddt,
                     :b1.etlcno,
                     :b1.pdivno,
                     :b1.ordno,
                     decode(:b1.ordno, wc_etcol.exorno1, wc_etcol.thkex1, NULL),
                     decode(:b1.ordno, wc_etcol.exorno1, wc_etcol.widex1, NULL),
                     decode(:b1.ordno,
                            '99999999',
                            decode(w_slfg, 'S', 'S', 'L', 'L'),
                            wc_etcol.exorno1,
                            wc_etcol.widch1),
                     decode(:b1.ordno,
                            '99999999',
                            wc_stlgd.stlgrd,
                            wc_ordar.stlgrd),
                     :b2.grade,
                     decode(:b1.ordno, '99999999', NULL, wc_ordar.orsize),
                     decode(:b1.ordno,
                            '99999999',
                            wc_etcol.prethk,
                            decode(w_exfg,
                                   'D',
                                   wc_etcol.prethk,
                                   'W',
                                   wc_ordar.orthk,
                                   'T',
                                   wc_etcol.prethk,
                                   wc_ordar.orthk)),
                     decode(:b1.ordno,
                            '99999999',
                            :b2.prewid,
                            decode(w_exfg,
                                   'D',
                                   decode(w_widch,
                                          'S',
                                          wc_etcol.prewid,
                                          'L',
                                          wc_ordar.orwid),
                                   'W',
                                   decode(w_widch,
                                          'S',
                                          wc_etcol.prewid,
                                          'L',
                                          wc_ordar.orwid),
                                   'T',
                                   wc_ordar.orwid,
                                   wc_ordar.orwid)),
                     decode(:b1.ordno,
                            '99999999',
                            :b2.prelen,
                            decode(w_exfg,
                                   'D',
                                   decode(w_widch,
                                          'S',
                                          wc_ordar.orlen,
                                          'L',
                                          wc_etcol.prewid),
                                   'W',
                                   decode(w_widch,
                                          'S',
                                          wc_ordar.orlen,
                                          'L',
                                          wc_etcol.prewid),
                                   'T',
                                   wc_ordar.orlen,
                                   wc_ordar.orlen)),
                     decode(:b1.ordno,
                            '99999999',
                            decode(w_slfg, 'S', :b2.prewid, 'L', :b2.prelen),
                            decode(w_exfg,
                                   'D',
                                   wc_etcol.prewid,
                                   'W',
                                   wc_etcol.prewid,
                                   'T',
                                   wc_ordar.shwid,
                                   wc_ordar.shwid)),
                     decode(:b1.ordno,
                            '99999999',
                            decode(w_slfg, 'S', :b2.prelen, 'L', :b2.prewid),
                            decode(w_exfg,
                                   'D',
                                   wc_ordar.shlen,
                                   'W',
                                   wc_ordar.shlen,
                                   'T',
                                   wc_ordar.shlen,
                                   wc_ordar.shlen)),
                     :b2.prdnum,
                     :b3.n_lotwg,
                     decode(:b1.ordno,
                            '99999999',
                            wc_etcol.coatwg,
                            wc_ordar.coatwg),
                 		 decode(:b1.ordno,
                 		 				'99999999',
                 		 				wc_etcol.coatwgfg,
                 		 				wc_ordar.coatwgfg),	-- add by zyt 20090814 No.114
                     wc_etcol.anlcd,
                     wc_etcol.stldsc,
                     wc_etcol.temper,
                     wc_etcol.sfcfcd,
                     wc_etcol.ispstd,
                     wc_etcol.oilty,
                     wc_etcol.chcd,
                     wc_etcol.ancocd,
                     wc_etcol.reflow,
                     wc_ordar.mgcd,
                     wc_ordar.mglng,
                     wc_ordar.mgsht,
                     :b2.hdrscd,
                     :b2.hdrscd2,
                     decode(:b2.hdrscd, NULL, NULL, SYSDATE),
                     NULL,
                     w_workdt,
                     w_worksf,
                     NULL,
                     NULL,
                     :b1.ispcter,
                     substr(substr('000', 1, 3 - length(:b1.shlpgno)) ||
                            :b1.shlpgno,
                            1,
                            3),
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     wc_etcol.fromcd, -- Added by zyt 20130903 For WinSteel
                     --2016/11/03 ｲｨｼﾞﾕｶﾔﾓｦ MDK ADD START 
            				 --decode(substr(wc_shsch.exorno1, 1, 1), 'J', '1', null),  -- added by xipj 2011/07/25 No.168
            				 decode(substr(wc_shsch.exorno1, 1, 1), 'J', '1', 'B', '1', null),
                     --2016/11/03 ｲｨｼﾞﾕｶﾔﾓｦ MDK ADD END 
                     --2016/11/15 ｲｨｼﾞﾕｶﾔﾓｦ MDK MOD START 
            				 --decode(substr(wc_ordar.ordno,1,1),'J',wc_ordar.scrlty,null));
            				 decode(substr(wc_ordar.ordno,1,1),'J',wc_ordar.scrlty,'B',wc_ordar.scrlty,null));
            				 --2016/11/15 ｲｨｼﾞﾕｶﾔﾓｦ MDK MOD END 
                 msg.ed_log('I', 2, :system.current_form, 'insert into smalt(SMALNO:)'||:b1.lotno);                                                                                                                         
            END IF;
            -- ｲ衒・ﾙﾗ・--- DB : WKLOTIF 
            --2005/07/13  kanli begin
            dbcommon.ed_wklotif(:parameter.p_termno,
                                :parameter.p_prntdt,
                                :b2.lotcd,
                                :b1.lotno,
                                substr(substr('000', 1, 3 - length(:b1.shlpgno)) ||
                                       :b1.shlpgno,
                                       1,
                                       3));
            --2005/07/13  kanli end
            --cursor ｹﾘｱﾕ 
            CLOSE c_1;
            CLOSE c_2;
            CLOSE c_3;
            CLOSE c_4;
            CLOSE c_5;
            
            -- added by zhangtao 2005/10/11 for design change. begin
            OPEN c_6;
            msg.ed_log('I', 2, :system.current_form, 'delete from shnum(shlpgno:'||:b1.shlpgno||',prcscd:'||:b1.procd||')');
            FETCH c_6 
                INTO wc_shnum;
            -- SHLﾍｨﾋｳDBﾀ・贇ﾚｻｭﾃ豬ﾄﾊｾﾝﾊｱ｣ｬｽｫﾆ菲ｾｳ
            IF c_6%FOUND THEN
            	  -- ADD BY XUGUOBIAO 20051019 BEGIN --------------
              	-- dbｸ・ﾂﾊｽﾑ・0-1
            	  UPDATE mprcs
            	     SET workno3 = workno2,
            	         workno2 = workno1,
            	         workno1 = :b1.shlpgno
            	   WHERE prcscd = :b1.procd;      
            	  -- ADD BY XUGUOBIAO 20051019 END --------------
            	  DELETE shnum WHERE
            	      shlpgno = :b1.shlpgno AND prcscd = :b1.procd;
            END IF;
            CLOSE c_6;
            -- added by zhangtao 2005/10/11 for design change. end
            
        END IF;
        IF st1 IS NULL THEN
            st1 := '0';
        END IF;
        -- logｼﾍﾂｼ
        msg.ed_log('I', 1, :system.current_form, pg_id || 'success');
    EXCEPTION
        WHEN OTHERS THEN
            --ｹﾘｱﾕCURSOR
            IF c_1%ISOPEN THEN
                CLOSE c_1;
            END IF;
            IF c_2%ISOPEN THEN
                CLOSE c_2;
            END IF;
            IF c_3%ISOPEN THEN
                CLOSE c_3;
            END IF;
            IF c_4%ISOPEN THEN
                CLOSE c_4;
            END IF;
            IF c_5%ISOPEN THEN
                CLOSE c_5;
            END IF;
            -- added by zhangtao 2005/10/11 for design change. begin
            IF c_6%ISOPEN THEN
                CLOSE c_6;
            END IF;
            -- added by zhangtao 2005/10/11 for design change. end
        
            IF SQLCODE = -100501 THEN
                NULL;
            ELSE
                -- logｼﾍﾂｼ 
                msg.ed_log('E',
                           1,
                           :system.current_form,
                           pg_id || 'failed,error:' || substr(SQLERRM, 1, 80));
                RAISE;
            END IF;
    END in_table;

    -- --------------------------------------------------------------------------------
    -- Program Name      : sl_incoil
    -- Description       : COILﾃｸｱ桄ｾ
    -- Arguments         :
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE sl_incoil IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_DB.sl_incoil:';
        -- cursor ｶｨﾒ・--- DB : SHL ﾉ嵂愑・・
        CURSOR c_1 IS
            SELECT *
              FROM shsch s
             WHERE s.prcscd = :b1.procd -- add by xgb XXX 
               AND s.shlpgno = :b1.shlpgno;
        wc_shsch c_1%ROWTYPE;
        --cursor ｶｨﾒ・--- DB : ｹ､ｳﾌﾇ魍ｨ 
        CURSOR c_2 IS
            SELECT *
              FROM mprcs m
             WHERE m.prcscd = :b1.procd;
        wc_mprcs c_2%ROWTYPE;
        --cursor ｶｨﾒ・--- DB : ﾊﾜﾗ｢
        CURSOR c_3 IS
            SELECT o.skid
              FROM ordar o
             WHERE o.ordno = :b1.ordno;
        wc_ordar c_3%ROWTYPE;
        --cursor ｶｨﾒ・--- DB : ｵ邯ﾆﾎCOIL 
        CURSOR c_4 IS
            SELECT e.etlcno,
                   e.prewg
              FROM etcol e,
                   shsch s
             WHERE s.prcscd = :b1.procd -- add by xgb XXX 
               AND s.shlpgno = :b1.shlpgno
               AND e.shlpgno = :b1.shlpgno
               AND s.tmbpno = e.tmbpno;
        wc_etcol c_4%ROWTYPE;
    BEGIN
    	  :b1.procd_1 := :b1.procd;
   	    :b1.shlpgno_1 := :b1.shlpgno;
        OPEN c_1;
        OPEN c_2;
        FETCH c_1
            INTO wc_shsch;
        FETCH c_2
            INTO wc_mprcs;
        --SHL ﾉ嵂愑・玽BｵﾄｲﾄﾁﾏﾊｶｱlagﾊﾇEｵﾄﾇ鯀・           
        IF wc_shsch.coilcd = 'E' THEN
            :b1.etlcno := wc_shsch.etlcno;
            :b1.prewg  := wc_shsch.prewg;
            --SHL ﾉ嵂愑・玽BｵﾄｲﾄﾁﾏﾊｶｱlagﾊﾇTｵﾄﾇ鯀・           
        ELSIF wc_shsch.coilcd = 'T' THEN
            OPEN c_4;
            FETCH c_4
                INTO wc_etcol;
            :b1.etlcno := wc_etcol.etlcno;
            :b1.prewg  := wc_etcol.prewg;
            CLOSE c_4;
        END IF;
        IF :b1.ordcdno = '9' THEN
            :b1.ordno := '99999999';
        ELSE
            :b1.ordno := wc_shsch.exorno1;
        END IF;
        --B1. ｲﾉﾈ｡ﾗﾓｷｬﾓﾃSHL ﾉ嵂愑・玽Bｵﾄﾖﾆﾆｷｲﾉﾈ｡ﾗﾓｷｬ+1ﾀｴｱ桄ｾ
        :b1.pdivno := nvl(wc_shsch.pdivno, 0) + 1;
        --B1. ｼ・鰆ｱﾓﾃｹ､ｳﾌﾇ魍ｨDB. ｼ・鰆ｱCODEﾀｴｱ桄ｾ
        :b1.ispcter := wc_mprcs.ispcter;
        OPEN c_3;
        FETCH c_3
            INTO wc_ordar;
        :b1.skid := wc_ordar.skid;
        CLOSE c_1;
        CLOSE c_2;
        CLOSE c_3;
    
        -- logｼﾍﾂｼ
        msg.ed_log('I', 1, :system.current_form, pg_id || 'success');
    EXCEPTION
        WHEN OTHERS THEN
            --ｹﾘｱﾕCURSOR
            IF c_1%ISOPEN THEN
                CLOSE c_1;
            END IF;
            IF c_2%ISOPEN THEN
                CLOSE c_2;
            END IF;
            IF c_3%ISOPEN THEN
                CLOSE c_3;
            END IF;
            IF c_4%ISOPEN THEN
                CLOSE c_4;
            END IF;
        
            IF SQLCODE = -100501 THEN
                NULL;
            ELSE
                -- logｼﾍﾂｼ 
                msg.ed_log('E',
                           1,
                           :system.current_form,
                           pg_id || 'failed,error:' || substr(SQLERRM, 1, 80));
                RAISE;
            END IF;
    END sl_incoil;
END;
