DECLARE
    pg_id CONSTANT VARCHAR2(50) DEFAULT 'B2:KEY-F9:';
    w_lotno VARCHAR2(8);
    st1     CHAR(2);
    st2     CHAR(2);
    st3     CHAR(2);
    st4     CHAR(2);
BEGIN
    -- logｼﾍﾂｼ 
    msg.ed_log('I', 1, :system.current_form, pg_id || 'start');
    
    -- add by xgb 20051207
    go_field('b1.procd');
    IF NOT Form_Success  THEN
    	  RAISE form_trigger_failure;
    END IF;
    
    st1 := NULL;
    st2 := NULL;
    st3 := NULL;
    st4 := NULL;
    --flagｳｼｻｯ 
    :b1.n_ewcd := NULL;
    -- ﾊｾﾝｼ・・
    IF st1 IS NULL THEN
        -- ﾏﾔﾊｾｳｼｻｯ 
        pkg_ctrl.set_err('b2.lotcd', 0);
        pkg_ctrl.set_err('b2.grade', 0);
        pkg_ctrl.set_err('b2.prdnum', 0);
        pkg_ctrl.set_err('b2.hdrscd', 0);
        pkg_ctrl.set_err('b2.prewid', 0);
        pkg_ctrl.set_err('b2.prelen', 0);
        --2005/07/19 kanli begin
        pkg_ctrl.set_err('b2.prdtm', 0);
        pkg_ctrl.set_err('b2.hdrscd2', 0);
        pkg_ctrl.set_err('b2.rpmemo', 0);
        pkg_ctrl.set_err('b2.rpmemocd', 0);
        --2005/07/19 kanli end
        --ﾊ菠・鍗ｿｼ・・
        pkg_check.ck_data(st2);
        msg.ed_log('I', 1, :system.current_form, 'ck_data return: status:' || st2);                    
        IF st2 != '0' THEN
            IF st2 = '1' THEN
                go_field('b2.lotcd');
                pkg_ctrl.set_err('b2.lotcd', 1);
            ELSIF st2 = '2' THEN
                go_field('b2.grade');
                pkg_ctrl.set_err('b2.grade', 1);
            ELSIF st2 = '3' THEN
                go_field('b2.prdnum');
                pkg_ctrl.set_err('b2.prdnum', 1);
            ELSIF st2 = '4' THEN
                go_field('b2.prewid');
                pkg_ctrl.set_err('b2.prewid', 1);
            ELSIF st2 = '5' THEN
                go_field('b2.prelen');
                pkg_ctrl.set_err('b2.prelen', 1);
            ELSIF st2 = '6' THEN
                go_field('b2.prewid');
                pkg_ctrl.set_err('b2.prewid', 1);
                pkg_ctrl.set_err('b2.prelen', 1);
            ELSIF st2 = '7' THEN
                go_field('b2.lotcd');
                pkg_ctrl.set_err('b2.lotcd', 1);
                pkg_ctrl.set_err('b2.grade', 1);
            ELSIF st2 = '8' THEN
                go_field('b2.prdtm');
                pkg_ctrl.set_err('b2.prdtm', 1);
            ELSIF st2 = '9' THEN
                go_field('b2.hdrscd');
                pkg_ctrl.set_err('b2.hdrscd', 1);
            ELSIF st2 = '10' THEN
                go_field('b2.rpmemocd');
                pkg_ctrl.set_err('b2.rpmemocd', 1);
            END IF;
            msg.ed_log('I', 1, :system.current_form, pg_id || ' form_trigger_failure return.');                                                        
            RAISE form_trigger_failure;
        END IF;
msg.ed_log('I', 1, :system.current_form, pg_id || ':b1.input='||:b1.input);
        ---- add by zyt 20051203 --------------------
        if :b1.input = '0' and :b2.prdwg is not null then
		    	  msg.ed_mess('E', '089', NULL);
		    	  go_field('b2.prdwg');
		        pkg_ctrl.set_err('b2.prdwg', 1);
		        RAISE form_trigger_failure;
		    elsif :b1.input = '1' and :b2.prdwg is null then
		    	  msg.ed_mess('E', '003', NULL);
		    	  go_field('b2.prdwg');
		        pkg_ctrl.set_err('b2.prdwg', 1);
		        RAISE form_trigger_failure;
		    end if;
		    ---- add by zyt 20051203 --------------------
		    -- add by xgb 20051205 begin--------------------
        if :b2.lotcd != '1' and :b2.prdwg is not null then
		    	  msg.ed_mess('E', '089', NULL);
		    	  go_field('b2.prdwg');
		        pkg_ctrl.set_err('b2.prdwg', 1);
		        RAISE form_trigger_failure;
        end if;  
        -- add by xgb 20051205 end --------------------
        -- ﾖﾘﾁｿｼ・・
        pkg_check.ck_weight(st3);
        msg.ed_log('I', 1, :system.current_form, 'ck_weight return: status:' || st3);                            
        IF st3 != '0' THEN
            go_field('b2.prdnum');
            pkg_ctrl.set_err('b2.prdnum', 1);
            msg.ed_log('I', 1, :system.current_form, pg_id || ' form_trigger_failure return.');                                                                    
            RAISE form_trigger_failure;
        END IF;
    ELSE
        msg.ed_log('I', 1, :system.current_form, pg_id || ' form_trigger_failure return.');                                                                
        RAISE form_trigger_failure;
    END IF;
    --ｾｯｸ豬ﾄﾇ鯀・
    IF :b1.n_ewcd = '1' THEN
    	  msg.ed_mess('W', '077', NULL);
        go_field('b3.chk');
    ELSE
        --ｵﾇﾂｼｴｦﾀ・
        --ｶﾋﾄｩｷｬｺﾅﾈ｡ｵﾃ
        dbcommon.ed_termno(:parameter.p_termno, :parameter.p_status);
        :parameter.p_prntdt := to_char(SYSDATE, 'YYMMDDHH24MISS');
        
--2016/10/28 ﾎﾞｶｩｵ･ｺﾅﾌ袞ｵｱ荳・ﾔﾓｦ MDK ADD START  
   IF (:b1.procd_1 != :b1.procd)
       OR (:b1.shlpgno_1 != :b1.shlpgno) THEN
        pkg_ctrl.set_err('shlpgno', 1);
        msg.ed_mess('E', '049', NULL);
        go_field('b1.shlpgno');
        RAISE form_trigger_failure;
   END IF;
--2016/10/28 ｶｩｵ･ｺﾅﾌ袞ｵｱ荳・ﾔﾓｦ MDK ADD END 
    
        pkg_db.in_table(st4);
        msg.ed_log('I', 1, :system.current_form, 'ck_weight return: status:' || st4);                                    
        IF st4 != '0' THEN
            msg.ed_log('I', 1, :system.current_form, pg_id || ' form_trigger_failure return.');                                                                        	
            RAISE form_trigger_failure;
        END IF;
        --lotno ｼ・・
        w_lotno := :b1.lotno;
        -- COMMIT      
        COMMIT;
        msg.ed_mess('I', '053', NULL);
        --ﾕﾊﾆｱｴｦﾀ・
        pkg_list.ex_list;
        
        clear_form(no_validate);
        :b1.lotno := w_lotno;
    END IF;

    -- logｼﾍﾂｼ
    msg.ed_log('I', 1, :system.current_form, pg_id || 'success');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -100501 THEN
            NULL;
        ELSE
            ROLLBACK;
            -- 2019/08/02 xiaorui add start
            dbms_output.put_line(SQLCODE);
            -- 2019/08/02 xiaorui add end
            msg.ed_mess('E', '031', NULL);
            msg.ed_log('E',
                       1,
                       :system.current_form,
                       pg_id || 'failed,error:' || substr(SQLERRM, 1, 80));
        END IF;
END;
