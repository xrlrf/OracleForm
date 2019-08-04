/*...5....10....15....20....25....30....35....40....45....50....55....60....65....70
+==================================================================================+
|             Copyright (C) 2004 NS Solutions Corporation,                         |
|                         All Rights Reserved.                                     |
+==================================================================================+
* ==================================================================================
*
*   NAME  pkg_list
*   COMMONS｣ｺﾓ｡ﾋ｢ﾓﾃPACKAGE
*
*   DESCRIPTION
*
*   HISTORY
*        1.00  2005/07/12  kan li(P@W)
* =================================================================================*/
PACKAGE BODY pkg_list IS
    -- --------------------------------------------------------------------------------
    -- Program Name      : ex_list
    -- Description       : ﾓ｡ﾋ｢
    -- Arguments         :
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE ex_list IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_LIST.EX_LIST:';
        w_cmd1 VARCHAR2(255);
        w_cmd2 VARCHAR2(255);
        w_cmd3 VARCHAR2(255);
		    repid      report_object;
		    v_rep      VARCHAR2(100);
		    rep_status VARCHAR2(20);
        
    BEGIN
        IF (:b2.lotcd = '1' AND
           (:b2.grade = '1' OR :b2.grade = '2' OR :b2.grade = 'A')) THEN
            -- ﾊｾﾝﾓﾐﾎﾞｼ・・
		        pkg_list.ck_list1(:parameter.p_cnt);
		        if :parameter.p_cnt = 0 then 
		        	 msg.ed_mess('I', '250', '(HGR01)');
		        else
		            repid := find_report_object('HGR01');
		            -- ﾌ晴ﾓｲﾎﾊ
		            set_report_object_property(repid, report_other, 'p_termno=' ||:parameter.p_termno||' p_prntdt=' || :parameter.p_prntdt||' paramform=no');
		            -- ﾊ莎靹ﾃ
		            set_report_object_property(repid, report_destype, printer);
		            :parameter.p_printer := dbcommon.get_printer('HGR01');
							  if :parameter.p_printer is not null then 
									  :parameter.p_printer := ''''||:parameter.p_printer||'''';	
									  set_report_object_property(repid, REPORT_DESNAME, :parameter.p_printer);
							  end if;
							  msg.ed_log('I',1, :system.current_form, pg_id || 'Output Report:HGR01,Printer:'|| :parameter.p_printer|| 'Success.');
		            -- ﾓ｡ﾋ｢
		            v_rep := run_report_object(repid);
		            msg.ed_mess('I', '251', NULL);
		        end if;    
            
            -- ﾊｾﾝﾓﾐﾎﾞｼ・・
		        pkg_list.ck_list3(:parameter.p_cnt);
		        if :parameter.p_cnt = 0 then 
		        	 msg.ed_mess('I', '250', '(HGR03)');
		        else
		            repid := find_report_object('HGR03');
		            -- ﾌ晴ﾓｲﾎﾊ
		            -- 2015/10/12 HGR03ﾊ莎ﾁA4(1ﾒｳ2ﾕﾅ)ｶﾔﾓｦ HXF MOD START
		            --set_report_object_property(repid, report_other, 'p_termno=' ||:parameter.p_termno||' p_prntdt=' || :parameter.p_prntdt||' paramform=no'||' copies=2 ');
		            set_report_object_property(repid, report_other, 'p_termno=' ||:parameter.p_termno||' p_prntdt=' || :parameter.p_prntdt||' paramform=no'||' copies=1 ');
		            -- 2015/10/12 HGR03ﾊ莎ﾁA4(1ﾒｳ2ﾕﾅ)ｶﾔﾓｦ HXF MOD END
		            -- ﾊ莎靹ﾃ
		            set_report_object_property(repid, report_destype, printer);
		            :parameter.p_printer := dbcommon.get_printer('HGR03');
							  if :parameter.p_printer is not null then 
									  :parameter.p_printer := ''''||:parameter.p_printer||'''';	
									  set_report_object_property(repid, REPORT_DESNAME, :parameter.p_printer);
							  end if;
							  msg.ed_log('I',1, :system.current_form, pg_id || 'Output Report:HGR03,Printer:'|| :parameter.p_printer|| 'Success.');
		            -- ﾓ｡ﾋ｢
		            v_rep := run_report_object(repid);
		            msg.ed_mess('I', '251', NULL);
		        end if;    
        ELSIF (:b2.lotcd = '1' AND :b2.grade = '9') THEN
            -- ﾊｾﾝﾓﾐﾎﾞｼ・・
		        pkg_list.ck_list2(:parameter.p_cnt);
		        if :parameter.p_cnt = 0 then 
		        	 msg.ed_mess('I', '250', '(HGR02)');
		        else
		            repid := find_report_object('HGR02');
		            -- ﾌ晴ﾓｲﾎﾊ
		            set_report_object_property(repid, report_other, 'p_termno=' ||:parameter.p_termno||' p_prntdt=' || :parameter.p_prntdt||' paramform=no');
		            -- ﾊ莎靹ﾃ
		            set_report_object_property(repid, report_destype, printer);
		            :parameter.p_printer := dbcommon.get_printer('HGR02');
							  if :parameter.p_printer is not null then 
									  :parameter.p_printer := ''''||:parameter.p_printer||'''';	
									  set_report_object_property(repid, REPORT_DESNAME, :parameter.p_printer);
							  end if;
							  msg.ed_log('I',1, :system.current_form, pg_id || 'Output Report:HGR02,Printer:'|| :parameter.p_printer|| 'Success.');
		            -- ﾓ｡ﾋ｢
		            v_rep := run_report_object(repid);
		            msg.ed_mess('I', '251', NULL);
		        end if;    
            
            -- ﾊｾﾝﾓﾐﾎﾞｼ・・
		        pkg_list.ck_list3(:parameter.p_cnt);
		        if :parameter.p_cnt = 0 then 
		        	 msg.ed_mess('I', '250', '(HGR03)');
		        else
		            repid := find_report_object('HGR03');
		            -- ﾌ晴ﾓｲﾎﾊ
		            -- 2015/10/12 HGR03ﾊ莎ﾁA4(1ﾒｳ2ﾕﾅ)ｶﾔﾓｦ HXF MOD START
		            --set_report_object_property(repid, report_other, 'p_termno=' ||:parameter.p_termno||' p_prntdt=' || :parameter.p_prntdt||' paramform=no'||' copies=2 ');
		            set_report_object_property(repid, report_other, 'p_termno=' ||:parameter.p_termno||' p_prntdt=' || :parameter.p_prntdt||' paramform=no'||' copies=1 ');
		            -- 2015/10/12 HGR03ﾊ莎ﾁA4(1ﾒｳ2ﾕﾅ)ｶﾔﾓｦ HXF MOD END
		            -- ﾊ莎靹ﾃ
		            set_report_object_property(repid, report_destype, printer);
		            :parameter.p_printer := dbcommon.get_printer('HGR03');
							  if :parameter.p_printer is not null then 
									  :parameter.p_printer := ''''||:parameter.p_printer||'''';	
									  set_report_object_property(repid, REPORT_DESNAME, :parameter.p_printer);
							  end if;
							  msg.ed_log('I',1, :system.current_form, pg_id || 'Output Report:HGR03,Printer:'|| :parameter.p_printer|| 'Success.');
		            -- ﾓ｡ﾋ｢
		            v_rep := run_report_object(repid);  
		            msg.ed_mess('I', '251', NULL);
		        end if;    
        ELSE
            -- ﾊｾﾝﾓﾐﾎﾞｼ・・
		        pkg_list.ck_list2(:parameter.p_cnt);
		        if :parameter.p_cnt = 0 then 
		        	 msg.ed_mess('I', '250', '(HGR02)');
		        else
		            repid := find_report_object('HGR02');
		            -- ﾌ晴ﾓｲﾎﾊ
		            set_report_object_property(repid, report_other, 'p_termno=' ||:parameter.p_termno||' p_prntdt=' || :parameter.p_prntdt||' paramform=no');
		            -- ﾊ莎靹ﾃ
		            set_report_object_property(repid, report_destype, printer);
		            :parameter.p_printer := dbcommon.get_printer('HGR02');
							  if :parameter.p_printer is not null then 
									  :parameter.p_printer := ''''||:parameter.p_printer||'''';	
									  set_report_object_property(repid, REPORT_DESNAME, :parameter.p_printer);
							  end if;
							  msg.ed_log('I',1, :system.current_form, pg_id || 'Output Report:HGR02,Printer:'|| :parameter.p_printer|| 'Success.');
		            -- ﾓ｡ﾋ｢
		            v_rep := run_report_object(repid);
		            msg.ed_mess('I', '251', NULL);
		        end if;    
        END IF;
			  -- wktableﾊｾﾝﾉｾｳ
			  DELETE FROM WKLOTIF
			   WHERE termno = :parameter.p_termno;
			  COMMIT;   -- add by zyt 20080702 for deadlock
			       
        -- logｼﾍﾂｼ
        msg.ed_log('I', 1, :system.current_form, pg_id || 'success');
    EXCEPTION
        WHEN OTHERS THEN
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
    END ex_list;

    -- --------------------------------------------------------------------------------
    -- Program Name      : ck_list1
    -- Description       : ﾕﾊﾆｱ(HGR01)ﾊｾﾝﾓﾐﾎﾞcheck
    -- Arguments         :
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE ck_list1(p_cnt out number) IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_LIST.ck_list1:';
    BEGIN

        -- logｼﾍﾂｼ 
        msg.ed_log('I',1, :system.current_form, pg_id || 'start');

        SELECT count(1) 
          into p_cnt
				  FROM WKLOTIF
					WHERE (WKLOTIF.TERMNO = :parameter.p_termno
					 AND WKLOTIF.PRNTDT = :parameter.p_prntdt
					 AND WKLOTIF.LOTCD = '1'
					 AND WKLOTIF.GRADE IN ('1', '2', 'A'));

        -- logｼﾍﾂｼ
        msg.ed_log('I',1, :system.current_form, pg_id || 'success');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -100501 THEN
                null;
            ELSE
                -- logｼﾍﾂｼ 
                msg.ed_log('E',1,
                           :system.current_form,
                           pg_id || 'failed,error:' || substr(SQLERRM, 1, 80));
                RAISE;
            END IF;
    END ck_list1;
    
    -- --------------------------------------------------------------------------------
    -- Program Name      : ck_list2
    -- Description       : ﾕﾊﾆｱ(HGR02)ﾊｾﾝﾓﾐﾎﾞcheck
    -- Arguments         :
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE ck_list2(p_cnt out number) IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_LIST.ck_list2:';
    BEGIN

        -- logｼﾍﾂｼ 
        msg.ed_log('I',1, :system.current_form, pg_id || 'start');

        SELECT count(1) 
          into p_cnt
				  FROM WKLOTIF
					WHERE WKLOTIF.TERMNO = :parameter.p_termno
					 AND WKLOTIF.PRNTDT = :parameter.p_prntdt
					 AND(WKLOTIF.LOTCD = '2'
					  OR WKLOTIF.LOTCD = '3'
					  OR (WKLOTIF.LOTCD = '1' AND WKLOTIF.GRADE IN ('3','9', 'S')));

        -- logｼﾍﾂｼ
        msg.ed_log('I',1, :system.current_form, pg_id || 'success');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -100501 THEN
                null;
            ELSE
                -- logｼﾍﾂｼ 
                msg.ed_log('E',1,
                           :system.current_form,
                           pg_id || 'failed,error:' || substr(SQLERRM, 1, 80));
                RAISE;
            END IF;
    END ck_list2;
    
    -- --------------------------------------------------------------------------------
    -- Program Name      : ck_list3
    -- Description       : ﾕﾊﾆｱ(HGR03)ﾊｾﾝﾓﾐﾎﾞcheck
    -- Arguments         :
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE ck_list3(p_cnt out number) IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_LIST.ck_list3:';
    BEGIN

        -- logｼﾍﾂｼ 
        msg.ed_log('I',1, :system.current_form, pg_id || 'start');

        SELECT count(1) 
          into p_cnt
				  FROM WKLOTIF
					WHERE (WKLOTIF.TERMNO = :parameter.p_termno
					 AND WKLOTIF.PRNTDT = :parameter.p_prntdt
					 AND WKLOTIF.LOTCD = '1'
					 AND WKLOTIF.GRADE IN ('1', '2', '3', '9', 'A'));

        -- logｼﾍﾂｼ
        msg.ed_log('I',1, :system.current_form, pg_id || 'success');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -100501 THEN
                null;
            ELSE
                -- logｼﾍﾂｼ 
                msg.ed_log('E',1,
                           :system.current_form,
                           pg_id || 'failed,error:' || substr(SQLERRM, 1, 80));
                RAISE;
            END IF;
    END ck_list3;
END;
