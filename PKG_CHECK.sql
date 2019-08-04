/*...5....10....15....20....25....30....35....40....45....50....55....60....65....70
+==================================================================================+
|             Copyright (C) 2004 NS Solutions Corporation,                         |
|                         All Rights Reserved.                                     |
+==================================================================================+
* ==================================================================================
*
*   NAME  pkg_check
*   COMMONS｣ｺﾊ菠・鍗ｿｼ・鰌ﾃｵﾄPACKAGE
*
*   DESCRIPTION
*
*   HISTORY
*        1.00  2005/07/12  kan li(P@W)
* =================================================================================*/
PACKAGE BODY pkg_check IS
    -- --------------------------------------------------------------------------------
    -- Program Name      : ck_code
    -- Description       : :B1 ﾊ菠・鍗ｿｼ・・
    -- Arguments         : st1 out varchar2
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE ck_code(st1 OUT VARCHAR2) IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_CHECK.ck_code:';
        -- cursor ｶｨﾒ・--- DB : ｹ､ｳﾌﾇ魍ｨ 
        CURSOR c_1 IS
            SELECT *
              FROM mprcs m
             WHERE m.grupcd = '20';
        wc_mprcs c_1%ROWTYPE;
        --cursor ｶｨﾒ・--- DB : SHL ﾉ嵂愑・・
        CURSOR c_2 IS
            SELECT *
              FROM shsch s
             WHERE s.prcscd = :b1.procd -- add by xgb XXX 
               AND s.shlpgno = :b1.shlpgno;
        wc_shsch c_2%ROWTYPE;
        -- cursor ｶｨﾒ・--- DB : ｵ邯ﾆﾎCOIL 
        --Modified by Liupeizhi 20130802   begin-------------------------------
        --No.211  ﾔﾓﾈ・ﾐﾇﾖｵﾄﾅﾐｶﾏ
        /*CURSOR c_3 IS
            SELECT *
              FROM etcol e
             WHERE e.shlpgno = :b1.shlpgno; */
        CURSOR c_3 IS
            SELECT e.*
              FROM etcol e,shsch s
             WHERE e.etlcno = s.etlcno
               AND s.prcscd = :b1.procd
               AND s.shlpgno = :b1.shlpgno; 
        --Modified by Liupeizhi 20130802   end  -------------------------------
        wc_etcol c_3%ROWTYPE;
        --cursor ｶｨﾒ・--- DB : ｹ､ｳﾌﾇ魍ｨ 
        CURSOR c_4 IS
            SELECT *
              FROM mprcs m
             WHERE m.prcscd = :b1.procd;
        wc_mprcs2 c_4%ROWTYPE;
        --cursor ｶｨﾒ・--- DB : SHL ﾉ嵂愑・・
        CURSOR c_5 IS
            SELECT s.etlcno
              FROM rtshl r,
                   shsch s
             WHERE s.prcscd = :b1.procd -- add by xgb XXX 
               AND s.shlpgno = :b1.shlpgno
               AND s.workfg = '1'
               AND r.shlpgno = :b1.shlpgno
               AND r.prcscd = :b1.procd
               AND r.brcd = 'B'
               AND r.nocd = 'N'
               AND r.rtstat = '1'
               AND r.etlcno = s.etlcno;
        wc_shsch2 c_5%ROWTYPE;
        -- added by zhangtao 2005/10/11 for design change. begin
        -- cursor ｶｨﾒ・--- DB : SHL ﾍｨﾋｳDB 
        CURSOR c_6 IS
            SELECT *
              FROM shnum s
             WHERE s.shlpgno = :b1.shlpgno
               AND s.prcscd = :b1.procd;
        wc_shnum c_6%ROWTYPE;
        -- added by zhangtao 2005/10/11 for design change. end
        -- added by xgb 2005/11/2 for design change. begin
        -- cursor ｶｨﾒ・--- DB : SHL ﾍｨﾋｳDB 
        CURSOR c_7(p_tmbpno varchar2) IS
            SELECT t.etlend
              FROM tmbpc t
             WHERE t.tmbpno = p_tmbpno;
        wc_7 c_7%ROWTYPE;
        -- added by zhangtao 2005/11/2 for design change. end
        w_cnt number(4);
        w_rjflag varchar2(1);
    BEGIN
        --ﾗｴﾌｬｳｼｻｯ 
        msg.ed_log('I', 1, :system.current_form, pg_id || 'start');
        st1 := NULL;
        --ﾊ菠・・・
        IF st1 IS NULL THEN
            --ﾊ菠・・・--- ﾏ鍗ｿ : ｹ､ｳﾌ
            IF :b1.procd IS NULL THEN
                st1 := '1';
                msg.ed_mess('E', '003', NULL);
                RETURN;
            END IF;
            OPEN c_1;
            LOOP
                FETCH c_1
                    INTO wc_mprcs;
                EXIT WHEN c_1%NOTFOUND;
                IF wc_mprcs.prcscd = :b1.procd THEN
                    st1 := '0';
                    EXIT;
                ELSE
                    st1 := '1';
                END IF;
            END LOOP;
            CLOSE c_1;
            IF st1 = '1' THEN
                msg.ed_mess('E', '002', NULL);
                RETURN;
            END IF;
            
            --ｴｪcursor  
            OPEN c_2;
            OPEN c_3;
            OPEN c_4;
            FETCH c_2
                INTO wc_shsch;
            FETCH c_3
                INTO wc_etcol;
            FETCH c_4
                INTO wc_mprcs2;
            -- ﾊ菠・・・--- ﾏ鍗ｿ: ﾉ嵂愑・琮o 
            IF :b1.shlpgno IS NULL THEN
                st1 := '2';
                msg.ed_mess('E', '003', NULL);
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            --ﾉ嵂愑・玽Bﾖﾐｲｻｴ贇ﾚ
            IF c_2%NOTFOUND THEN
                st1 := '2';
                msg.ed_mess('E', '001', NULL);
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            msg.ed_log('I', 2, :system.current_form, 'get wc_shsch.workfg :'|| wc_shsch.workfg );                                                                            
            
            --ﾉ嵂愑・釭桄ﾇﾎｴﾗｵ 
            /* DELETED BY XUGUOBIAO 20051019 BEGIN -------------------------              
            IF wc_shsch.workfg IS NULL THEN
                st1 := '2';
                msg.ed_mess('E', '080', NULL);
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            DELETED BY XUGUOBIAO 20051019 END ------------------------- */    
            --ﾉ嵂愑・釭桄ﾇﾃ・鏸｡ﾏ・   
            IF wc_shsch.workfg = '9' THEN
                st1 := '2';
                msg.ed_mess('E', '081', NULL);
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            IF wc_shsch.etlcno IS NOT NULL AND c_3%NOTFOUND THEN
                st1 := '2';
                msg.ed_mess('E', '001', NULL);
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            
            --Added by Liupeizhi 20130704   begin-------------------------------
            --No.211  ﾔﾓﾈ・ﾐﾇﾖｵﾄﾅﾐｶﾏ
            IF c_3%FOUND THEN
            	IF wc_etcol.cdivcd = '1' THEN
            		st1 := '2';
            		msg.ed_mess('E','105',NULL);
            		CLOSE c_2;
            		CLOSE c_3;
            		CLOSE c_4;
            		RETURN;
            	END IF;
            END IF;
            --Added by Liupeizhi 20130704   end  -------------------------------
            
            -- add by xgb 20051102 begin ---------------------------------------
            IF wc_shsch.etlcno IS NULL THEN
            	  open c_7(wc_shsch.tmbpno);
            		FETCH c_7 INTO wc_7;
            	  IF c_7%FOUND AND nvl(wc_7.etlend,'2') != '1' THEN
		                st1 := '2';
		                msg.ed_mess('E', '023', NULL);
		                CLOSE c_2;
		                CLOSE c_3;
		                CLOSE c_4;
		                RETURN;
            	  END IF;
            	  close c_7;
            	  
            	  -- ﾒﾑｾｭｱｻｷﾖｸ鑅ｱ
            	  select count(1)
            	    into w_cnt
            	    from etcol e
            	   where e.tmbpno = wc_shsch.tmbpno; 
            	  if w_cnt > 1 then 
            	  		st1 := '2';
		                msg.ed_mess('E', '050', NULL);
		                CLOSE c_2;
		                CLOSE c_3;
		                CLOSE c_4;
		                RETURN;
            	  END IF;
            	  
            	  -- etlﾊ菠・ﾐﾎｴｽ睫ｱ
            	  if w_cnt = 1 then 
            	  	  /* del by xgb 20060912
            	  	  select e.rjflag
		            	    into w_rjflag
		            	    from etsch e
		            	   where e.tmbpno = wc_shsch.tmbpno; 
		            	   */
		            	  -- add by xgb 20060912 
		            	  select e.rjflag
		            	    into w_rjflag
		            	    from etsch e,
		            	    		 etcol t
		            	   where e.tmbpno = wc_shsch.tmbpno
		            	     and t.tmbpno = wc_shsch.tmbpno
		            	     and e.etlpgno = t.etlpgno;
		            	  if w_rjflag is null then  
		            	  		st1 := '2';
				                msg.ed_mess('E', '050', NULL);
				                CLOSE c_2;
				                CLOSE c_3;
				                CLOSE c_4;
				                RETURN;
		            	  else
		            	  	  begin
		            	  	  select e.etlcno
			            	    into :b1.n_etlcno
			            	    from etcol e
			            	   where e.tmbpno = wc_shsch.tmbpno;
		            	  	  exception
		            	  	  	when others then
		            	  	  	  null;
		            	  	  end; 	  
				            END IF;    
            	  END IF;
            END IF;
            -- add by xgb 20051102 end  ---------------------------------------
            
            -- ﾊ菠・・・--- ﾏ鍗ｿ : ﾊﾜﾗ｢ﾍ・
            IF (:b1.ordcdno IS NOT NULL AND :b1.ordcdno != '9') THEN
                st1 := '3';
                msg.ed_mess('E', '002', NULL);
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;

						-- add by xuguobiao 20051019 begin -------------
						OPEN c_5;
            FETCH c_5
                INTO wc_shsch2;
            IF c_5%FOUND THEN
            		:b1.etlcno := wc_shsch2.etlcno;
            END IF;	
            CLOSE c_5;
			      -- add by xuguobiao 20051019 end -------------
            	
            -- added by zhangtao 2005/10/11 for design change. begin
            OPEN c_6;
            FETCH c_6 
                INTO wc_shnum;
            -- ｲﾄﾁﾏｹｩｸｴｵﾇﾂｼ(ﾔﾚFGF06ｵﾇﾂｼ)ｵﾄｻｰ｣ｬｱｨｴ・
            IF c_6%NOTFOUND THEN
            	  -- CHECK ﾊｽﾑ・NO.7
            	  IF :b1.shlpgno != wc_mprcs2.workno1 THEN
                    st1        := '9';
                    msg.ed_mess('W', '107', NULL);
                    CLOSE c_2;
                    CLOSE c_3;
                    CLOSE c_4;
                    CLOSE c_6;
                    RETURN;
			          END IF;
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                CLOSE c_6;
                RETURN;
            ELSE
                msg.ed_log('I', 2, :system.current_form, 'get wc_shnum.thsta :'||wc_shnum.thsta);                                                                                                                                                                                                                                                                                                                                               
            	  -- ｲﾄﾁﾏｹｩｸﾇﾂｼﾁﾋ｣ｬｵｫｻｹﾎｴﾍｨｰ蠢ｪﾊｼ｣ｨﾍｨｰ蠢ｪﾊｼﾇﾖ<>'1'｣ｩ｣ｬｱｨｴ・
                IF nvl(wc_shnum.thsta,'9999') <> '1' THEN
            	      st1 := '2';
                    -- ﾊ菠・・・--- ﾏ鍗ｿ: ﾉ嵂愑・琮o 
										msg.ed_mess('E', '261', NULL);
                    CLOSE c_2;
                    CLOSE c_3;
                    CLOSE c_4;
                    CLOSE c_6;
                    RETURN;
                END IF;
                CLOSE c_6;
            END IF;
            -- added by zhangtao 2005/10/11 for design change. end
            
            
            CLOSE c_2;
            CLOSE c_3;
            CLOSE c_4;
            
        END IF;
        IF st1 IS NULL THEN
            st1 := '0';
        END IF;
    
        -- logｼﾍﾂｼ
        msg.ed_log('I', 1, :system.current_form, pg_id || 'success');
    EXCEPTION
        WHEN OTHERS THEN
            -- CURSOR ｹﾘｱﾕ
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
    END ck_code;
    -- --------------------------------------------------------------------------------
    -- Program Name      : ck_data
    -- Description       : :B2 ﾊ菠・鍗ｿｼ・・
    -- Arguments         : st1 out varchar2
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE ck_data(st1 OUT VARCHAR2) IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_CHECK.ck_data:';
    
        --cursor ｶｨﾒ・-- DB : SHL ﾉ嵂愑・・
        CURSOR c_1 IS
            SELECT s.pdivno,s.exorno1
              FROM shsch s
             WHERE s.prcscd = :b1.procd -- add by xgb XXX 
               AND s.shlpgno = :b1.shlpgno;
        wc_shsch c_1%ROWTYPE;
        --cursor ｶｨﾒ・--- DB : ﾊﾜﾗ｢
        CURSOR c_2(p_ordno varchar2) IS
            SELECT o.smlcd,
                   o.numppkg,
                   o.grade,
                   o.orwid,
                   o.orlen,
                   contweit
              FROM ordar o
             WHERE o.ordno = p_ordno;
        wc_ordar c_2%ROWTYPE;
        --cursor ｶｨﾒ・-- DB : ﾍｨﾓﾃ
        CURSOR c_3 IS
            SELECT m.tvalue
              FROM mtabl m
             WHERE syscd = 'HG'
               AND sysnum = 1;
        wc_mtabl c_3%ROWTYPE;
        -- cursor ｶｨﾒ・--- DB : ｵ邯ﾆﾎCOIL
        CURSOR c_4 IS
            SELECT e.prewid
              FROM etcol e
             WHERE e.etlcno = :b1.etlcno;
        wc_etcol c_4%ROWTYPE;
        -- 2005/07/13 kanli begin 
        --cursor ｶｨﾒ・--- DB : ﾎﾄﾕﾂﾌﾘｼﾇCode 
        CURSOR c_5 IS
            SELECT spmemo
              FROM mmemo m
             WHERE m.spmemocd = :b2.rpmemocd;
        wc_mmemo c_5%ROWTYPE;
        -- 2005/07/13 kanli end
    
        st2 CHAR(2);
    BEGIN
        msg.ed_log('I', 1, :system.current_form, pg_id || 'start');
        -- ﾗｴﾌｬｳｼｻｯ
        st1 := NULL;
        st2 := NULL;
        -- ﾊ菠・・・
        IF st1 IS NULL THEN
            OPEN c_1;
            OPEN c_2(:b1.ordno);
            OPEN c_3;
            OPEN c_4;
            FETCH c_1
                INTO wc_shsch;
            FETCH c_2
                INTO wc_ordar;
            FETCH c_3
                INTO wc_mtabl;
            FETCH c_4
                INTO wc_etcol;
            -- ﾊ菠・・・--- ﾏ鍗ｿ : LOTﾇﾖ 
            IF :b2.lotcd IS NULL THEN
                st1 := '1';
                msg.ed_mess('E', '003', NULL);
                CLOSE c_1;
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            IF (:b2.lotcd != '1' AND :b2.lotcd != '2' AND :b2.lotcd != '3') THEN
                st1 := '1';
                msg.ed_mess('E', '002', NULL);
                CLOSE c_1;
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            --ﾊ菠・・・--- ﾏ鍗ｿ: ﾋｪﾊｱｼ・
            IF :b2.prdtm IS NULL THEN
                st1 := '8';
                msg.ed_mess('W', '003', NULL);
                RETURN;
            END IF;
            -- ﾊ菠・・・--- ﾏ鍗ｿ: ｵﾈｼｶ
            IF :b2.grade IS NULL THEN
                st1 := '2';
                msg.ed_mess('E', '003', NULL);
                CLOSE c_1;
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            IF (:b2.grade != '1' AND :b2.grade != '2' AND :b2.grade != 'A' AND
               :b2.grade != '9' AND :b2.grade != 'S') THEN
                st1 := '2';
                msg.ed_mess('E', '002', NULL);
                CLOSE c_1;
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            msg.ed_log('I', 2, :system.current_form, 'get wc_ordar.grade :'|| wc_ordar.grade ); 
            IF :b1.ordno != '99999999' THEN
                IF ((:b2.lotcd = '1' OR :b2.lotcd = '3') AND
                   (:b2.grade = '1' OR :b2.grade = '2' OR :b2.grade = 'A')) THEN
                    IF nvl(wc_ordar.grade,' ') != :b2.grade THEN
                        st1 := '2';
                        msg.ed_mess('E', '102', NULL);
                        CLOSE c_1;
                        CLOSE c_2;
                        CLOSE c_3;
                        CLOSE c_4;
                        RETURN;
                    END IF;
                END IF;
            END IF;
            IF ((:b2.grade = '9' OR :b2.grade = 'S') AND
               (:b2.lotcd = '2' OR :b2.lotcd = '3')) THEN
                st1 := '7';
                msg.ed_mess('E', '002', NULL);
                CLOSE c_1;
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            ---- add by zyt 20051203 --------------------
            IF :b1.ordcdno = '9' and :b2.grade = '1' then
            	  st1 := '2';
                msg.ed_mess('E', '002', NULL);
                CLOSE c_1;
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            ---- add by zyt 20051203 --------------------
            
            --ﾊ菠・・・--- ﾏ鍗ｿ: ﾃｶﾊ
            IF :b2.prdnum IS NULL THEN
                st1 := '3';
                msg.ed_mess('E', '003', NULL);
                CLOSE c_1;
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            -- add by xgb 20051028 begin ------------------------
            IF :b2.prdnum = 0 THEN
                st1 := '3';
                msg.ed_mess('E', '002', NULL);
                CLOSE c_1;
                CLOSE c_2;
                CLOSE c_3;
                CLOSE c_4;
                RETURN;
            END IF;
            -- add by xgb 20051028 end    ------------------------
            msg.ed_log('I', 2, :system.current_form, 'get wc_ordar.smlcd :'|| wc_ordar.smlcd );
            msg.ed_log('I', 2, :system.current_form, 'get wc_ordar.numppkg :'|| wc_ordar.numppkg );                                      
            IF (:b2.lotcd = '1' AND
               (:b2.grade = '1' OR :b2.grade = '2' OR :b2.grade = 'A')AND :b1.ordno != '99999999') THEN
                IF wc_ordar.smlcd IS NULL  THEN
                    IF nvl(wc_ordar.numppkg, 0) != nvl(:b2.prdnum, 0) THEN
                        st1 := '3';
                        msg.ed_mess('E', '052', NULL);
                        CLOSE c_1;
                        CLOSE c_2;
                        CLOSE c_3;
                        CLOSE c_4;
                        RETURN;
                    END IF;
                ELSIF wc_ordar.smlcd = '1' THEN
                    IF wc_ordar.numppkg != nvl(:b2.prdnum, 0) THEN
                        IF wc_ordar.numppkg > nvl(:b2.prdnum, 0) THEN
                            st1 := '0';
                            -- msg.ed_mess('W', '077', NULL);
                            :b1.n_ewcd := '1';
                            --2005/08/10 kanli  ﾊｹﾏﾂﾃ豬ﾄｼ・魎ﾙﾗﾜｹｻﾖｴﾐﾐ                            
                            --CLOSE c_1;
                            --CLOSE c_2;
                            --CLOSE c_3;
                            --CLOSE c_4;
                            --RETURN;
                        ELSIF wc_ordar.numppkg < nvl(:b2.prdnum, 0) THEN
                            st1 := '3';
                            msg.ed_mess('E', '084', NULL);
                            :b1.n_ewcd := '0';
                            CLOSE c_1;
                            CLOSE c_2;
                            CLOSE c_3;
                            CLOSE c_4;
                            RETURN;
                        END IF;
                    END IF;
                END IF;
            ELSIF ((:b2.lotcd = '2') OR
                  (:b2.lotcd = '1' AND (:b2.grade = '9' OR :b2.grade = 'S'))) THEN
                msg.ed_log('I', 2, :system.current_form, 'get wc_mtabl.tvalue :'|| wc_mtabl.tvalue );                                      
                IF nvl(:b2.prdnum, 0) >= to_number(wc_mtabl.tvalue) THEN
                    st1 := '3';
                    msg.ed_mess('E', '078', NULL);
                    CLOSE c_1;
                    CLOSE c_2;
                    CLOSE c_3;
                    CLOSE c_4;
                    RETURN;
                END IF;
            ELSIF (:b2.lotcd = '3'AND :b1.ordno != '99999999') THEN
                IF :b2.prdnum >= wc_ordar.numppkg THEN
                    st1 := '3';
                    msg.ed_mess('E', '084', NULL);
                    CLOSE c_1;
                    CLOSE c_2;
                    CLOSE c_3;
                    CLOSE c_4;
                    RETURN;
                END IF;
            END IF;
            -- ﾊ菠・・・--- ﾏ鍗ｿ: ｱ｣ﾁODE｡｢ｱ｣ﾁODE2 
            IF :b2.hdrscd IS NULL
               AND :b2.hdrscd2 IS NOT NULL THEN
                st1 := '9';
                msg.ed_mess('E', '003', NULL);
                RETURN;
            END IF;
            
            -- add by xgb 20051203 begin -------------------------
            if :b1.ordcdno = '9' and :b2.grade = '9' then
            	 close c_2;
            	 open c_2(wc_shsch.exorno1);
            	 FETCH c_2
                INTO wc_ordar;
               if c_2%found then
                  if :b2.prewid is null then
                  	 :b2.prewid := wc_ordar.orwid;
                  end if;	
                  if :b2.prelen is null then
                  	 :b2.prelen := wc_ordar.orlen;
                  end if;
               end if;
               close c_2;
            end if;		
            -- add by xgb 20051203 end   -------------------------
            
            -- ﾊ菠・・・--- ﾏ鍗ｿ: ｶﾌｱﾟ , ｳ､ｱﾟ 
            IF :b1.ordcdno = '9'
               OR :b1.ordno = '99999999' THEN
                IF (:b2.prelen IS NULL AND :b2.prewid IS NULL) THEN
                    st1 := '6';
                    msg.ed_mess('E', '003', NULL);
                    CLOSE c_1;
                    CLOSE c_2;
                    CLOSE c_3;
                    CLOSE c_4;
                    RETURN;
                ELSIF :b2.prewid IS NULL THEN
                    st1 := '4';
                    msg.ed_mess('E', '003', NULL);
                    CLOSE c_1;
                    CLOSE c_2;
                    CLOSE c_3;
                    CLOSE c_4;
                    RETURN;
                ELSIF :b2.prelen IS NULL THEN
                    st1 := '5';
                    msg.ed_mess('E', '003', NULL);
                    CLOSE c_1;
                    CLOSE c_2;
                    CLOSE c_3;
                    CLOSE c_4;
                    RETURN;
                ELSIF :b2.prewid > :b2.prelen THEN
                    st1 := '6';
                    msg.ed_mess('E', '091', NULL);
                    CLOSE c_1;
                    CLOSE c_2;
                    CLOSE c_3;
                    CLOSE c_4;
                    RETURN;
                END IF;
                msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.prewid :'|| wc_etcol.prewid);                                                      
                IF ((:b2.prewid != nvl(wc_etcol.prewid,0)) AND
                   (:b2.prelen != nvl(wc_etcol.prewid,0))) THEN
                    st1 := '6';
                    msg.ed_mess('E', '108', NULL);
                    CLOSE c_1;
                    CLOSE c_2;
                    CLOSE c_3;
                    CLOSE c_4;
                    RETURN;
                END IF;
            END IF;
            
            -- ﾊｵｼﾊﾖﾘﾁｿﾊﾇｷﾉﾊ菠・ﾐｶﾏ          
		        ---- add by zyt 20051203 --------------------
		        if :b2.lotcd='1' then
		        	if nvl(:b1.ordcdno,' ')='9' then
			            	:b1.input:='1';
			        else 
			        		if wc_ordar.contweit='J' then
			        			  :b1.input:='0';
			        		else
			        			  :b1.input:='1';
			        		end if;
			        end if;	
			      else
			        :b1.input:='0';
			      end if;
			      ---- add by zyt 20051203 --------------------
					      
            CLOSE c_1;
            IF c_2%ISOPEN THEN
                CLOSE c_2;
            END IF;
            CLOSE c_3;
            CLOSE c_4;
            --2005/07/13 kanli begin
            --ﾊ菠・・・--- ﾏ鍗ｿ: ﾌﾘｼﾇCODE*/
            IF :b2.rpmemocd IS NOT NULL THEN
                OPEN c_5;
                FETCH c_5
                    INTO wc_mmemo;
                IF c_5%NOTFOUND THEN
                    st1 := '10';
                    msg.ed_mess('W', '002', NULL);
                    RETURN;
                ELSE
                    msg.ed_log('I', 2, :system.current_form, 'get wc_mmemo.spmemo:'|| wc_mmemo.spmemo);                                                                      	
                    --:b2.rpmemo := wc_mmemo.spmemo;
                END IF;
            END IF;
            --2005/07/13 kanli end 
        END IF;
    
        IF st1 IS NULL THEN
            st1 := '0';
        END IF;
        -- logｼﾍﾂｼ
        msg.ed_log('I', 1, :system.current_form, pg_id || 'success');
    EXCEPTION
        WHEN OTHERS THEN
            -- CURSOR ｹﾘｱﾕ
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
    END ck_data;
    -- --------------------------------------------------------------------------------
    -- Program Name      : ck_weight
    -- Description       : :b2 ｳﾉﾆｷﾂﾊｼ・・
    -- Arguments         : st1 out varchar2
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE ck_weight(st1 OUT VARCHAR2) IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_CHECK.ck_weight:';
        --cursor ｶｨﾒ・--- DB : ﾊﾜﾗ｢
        CURSOR c_1 IS
            SELECT o.*
              FROM ordar o
             WHERE o.ordno = :b1.ordno;
        wc_ordar c_1%ROWTYPE;
        -- cursor ｶｨﾒ・--- DB : SHL ﾉ嵂愑・・
        CURSOR c_2 IS
            SELECT s.prewg,
                   s.sumwg
              FROM shsch s
             WHERE s.prcscd = :b1.procd -- add by xgb XXX 
               AND s.shlpgno = :b1.shlpgno;
        wc_shsch c_2%ROWTYPE;
        --cursor ｶｨﾒ・--- DB : ｵ邯ﾆﾎCOIL 
        CURSOR c_3 IS
            SELECT e.*
              FROM etcol e
             WHERE e.etlcno = :b1.etlcno;
        
        wc_etcol c_3%ROWTYPE;
        w_prethk NUMBER(4, 3);
        w_prewid NUMBER(5, 1);
        w_prelen NUMBER(5, 1);
        w_prdnum NUMBER(5);
        w_wgps   NUMBER(5);
        w_weight NUMBER(5);
        w_widch  CHAR(1);
        w_widex  CHAR(1);
        w_thkex  CHAR(1);
        w_exfg   CHAR(1);
    BEGIN
        msg.ed_log('I', 1, :system.current_form, pg_id || 'start');
    
        --ﾗｴﾌｬｳｼｻｯ     
        st1 := NULL;
        --ｱ・ｾｱ菽ｿｳｼｻｯ   
        w_widch := NULL;
        w_widex := NULL;
        w_thkex := NULL;
        w_exfg  := NULL;
        --ｳﾟｴ邀菽ｿｳｼｻｯ  
        w_prethk := NULL;
        w_prewid := NULL;
        w_prelen := NULL;
        w_prdnum := NULL;
        -- ﾖﾘﾁｿｱ菽ｿｳｼｻｯ 
        :b3.n_lotwg := NULL;
        w_wgps      := NULL;
        w_weight    := NULL;
        IF st1 IS NULL THEN
            OPEN c_1;
            OPEN c_2;
            OPEN c_3;
            FETCH c_1
                INTO wc_ordar;
            FETCH c_2
                INTO wc_shsch;
            FETCH c_3
                INTO wc_etcol;
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.widch1:'|| wc_etcol.widch1); 
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.widex1:'|| wc_etcol.widex1);                                                                      	            	
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.thkex1:'|| wc_etcol.thkex1);   
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.prethk:'|| wc_etcol.prethk); 
            msg.ed_log('I', 2, :system.current_form, 'get wc_etcol.prewid:'|| wc_etcol.prewid); 
            msg.ed_log('I', 2, :system.current_form, 'get wc_ordar.orlen:'|| wc_ordar.orlen); 
            msg.ed_log('I', 2, :system.current_form, 'get wc_ordar.orwid:'|| wc_ordar.orwid); 
            msg.ed_log('I', 2, :system.current_form, 'get wc_ordar.orthk:'|| wc_ordar.orthk); 
            --ｱ・ｾﾉ靹ﾃ : ｶﾌｱﾟ｣ｬｳ､ｱﾟ｣ｬｺﾈ
            IF :b1.ordno != '99999999' THEN
                IF :b1.ordno = wc_etcol.exorno1 THEN
                    w_widch := wc_etcol.widch1;
                    w_widex := wc_etcol.widex1;
                    w_thkex := wc_etcol.thkex1;
                END IF;
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
            -- ﾏ鍗ｿﾉ靹ﾃ :ｺﾈ,ｶﾌｱﾟ,ｳ､ｱﾟ,ﾃｶﾊ 
            IF :b1.ordno = '99999999' THEN
                --ﾊﾜﾗ｢no = '99999999'ｵﾄﾇ鯀・
                w_prethk := wc_etcol.prethk;
                w_prewid := :b2.prewid;
                w_prelen := :b2.prelen;
                w_prdnum := :b2.prdnum;
            ELSIF w_exfg = 'D' THEN
                IF w_widch = 'S' THEN
                    w_prethk := wc_etcol.prethk;
                    w_prewid := wc_etcol.prewid;
                    w_prelen := wc_ordar.orlen;
                    w_prdnum := :b2.prdnum;
                ELSIF w_widch = 'L' THEN
                    w_prethk := wc_etcol.prethk;
                    w_prewid := wc_ordar.orwid;
                    w_prelen := wc_etcol.prewid;
                    w_prdnum := :b2.prdnum;
                END IF;
            ELSIF w_exfg = 'W' THEN
                IF w_widch = 'S' THEN
                    w_prethk := wc_ordar.orthk;
                    w_prewid := wc_etcol.prewid;
                    w_prelen := wc_ordar.orlen;
                    w_prdnum := :b2.prdnum;
                ELSIF w_widch = 'L' THEN
                    w_prethk := wc_ordar.orthk;
                    w_prewid := wc_ordar.orwid;
                    w_prelen := wc_etcol.prewid;
                    w_prdnum := :b2.prdnum;
                END IF;
            ELSIF w_exfg = 'T' THEN
                w_prethk := wc_etcol.prethk;
                w_prewid := wc_ordar.orwid;
                w_prelen := wc_ordar.orlen;
                w_prdnum := :b2.prdnum;
            ELSE
                -- ﾕｳ｣           
                w_prethk := wc_ordar.orthk;
                w_prewid := wc_ordar.orwid;
                w_prelen := wc_ordar.orlen;
                w_prdnum := :b2.prdnum;
            END IF;
			        
            -- ﾖﾘﾁｿｼﾆﾋ・
            --2005/07/13  kanli begin
            common.ed_lotwg(w_prethk,
                            w_prewid,
                            w_prelen,
                            w_prdnum,
                            w_wgps,
                            w_weight);
            msg.ed_log('I', 1, :system.current_form, 'w_weight:=' || w_weight);
        
            --2005/07/13  kanli end
            --ﾖﾘﾁｿｼ・・
            ---- modify by zyt 20051203 -------------------------------------------
            IF :b2.prdwg IS NOT NULL AND 
            	(w_weight < :b2.prdwg * 0.95 OR w_weight > :b2.prdwg * 1.05) THEN
                pkg_ctrl.set_err('b2.prdwg', 1);
                if st1 is null then 
                		st1 := '2';
                		msg.ed_mess('E', '254', NULL);
                end if;
             ---- modify by zyt 20051203 -------------------------------------------
                CLOSE c_1;
                CLOSE c_2;
            		CLOSE c_3;
                RETURN;
            END IF;
            
            -- add by xgb 20051207 
            --ﾖﾘﾁｿｼ・・       
		        IF (nvl(:b2.prdwg,w_weight) +  nvl(wc_shsch.sumwg,0)> (nvl(wc_shsch.prewg,0) + 1500)) THEN
		            st1 := '1';
		            msg.ed_mess('E', '064', NULL);
		            RETURN;
		        END IF;
        
            CLOSE c_1;
            CLOSE c_2;
            CLOSE c_3;
            :b3.n_lotwg := nvl(:b2.prdwg,w_weight);
        END IF;
        IF st1 IS NULL THEN
            st1 := '0';
        END IF;
    
        -- logｼﾍﾂｼ
        msg.ed_log('I', 1, :system.current_form, pg_id || 'success');
    EXCEPTION
        WHEN OTHERS THEN
            -- CURSOR ｹﾘｱﾕ
            IF c_1%ISOPEN THEN
                CLOSE c_1;
            END IF;
            IF c_2%ISOPEN THEN
                CLOSE c_2;
            END IF;
            IF c_3%ISOPEN THEN
                CLOSE c_3;
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
    END ck_weight;

END;
