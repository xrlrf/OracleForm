DECLARE
    pg_id CONSTANT VARCHAR2(50) DEFAULT 'B3.chk:KEY-F9:';
    w_lotno VARCHAR2(8);
    st1     CHAR(1);
    st2     CHAR(1);
    st3     CHAR(1);
    st4     CHAR(1);
BEGIN
    msg.ed_log('I', 1, :system.current_form, pg_id || 'start');
    st1 := NULL;
    st2 := NULL;
    st3 := NULL;
    st4 := NULL;
    
    IF st1 IS NULL THEN
        --b3块的check
        IF :b3.chk = 'N' THEN
            -- 如果chk没有确认，根据lotcd是否输入跳到对应的区域
            :b3.chk := NULL;
            IF :b2.lotcd IS NULL THEN
                -- 如果lotcd没有输入则跳到b1块的shlpgno
                go_field('b1.shlpgno');
            ELSE
                -- 如果lotcd已经输入则跳到b2块的prdnum枚数
                go_field('b2.prdnum');
            END IF;
            msg.ed_log('I', 1, :system.current_form, pg_id || ' form_trigger_failure return.');  
            -- 抛出表格错误                                                      
            RAISE form_trigger_failure;
            --               
        ELSIF :b3.chk IS NULL THEN
            msg.ed_mess('W', '003', NULL);
            msg.ed_log('I', 1, :system.current_form, pg_id || ' form_trigger_failure return.');                                                        
            RAISE form_trigger_failure;
            --  
        ELSIF :b3.chk = 'Y' THEN
            -- 如果b3.chk已经确认查看lotcd是否已经输入，如果不为空则执行db操作
            IF :b2.lotcd IS NULL THEN
                pkg_db.sl_incoil;
                go_field('b2.lotcd');
                :b1.lotno := NULL;
                msg.ed_log('I', 1, :system.current_form, pg_id || ' form_trigger_failure return.');                                                            
                RAISE form_trigger_failure;                
            END IF;
             -- 
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
        --2016/10/28 ﾎﾞｶｩｵ･ｺﾅﾌ袞ｵｱ荳・ﾔﾓｦ MDK ADD END  

        IF st2 IS NULL THEN
            --ｵﾇﾂｼｴｦﾀ・
            pkg_db.in_table(st2);
            msg.ed_log('I', 1, :system.current_form, 'in_table return: status:' || st2);                                        
            IF st2 != '0' THEN
                msg.ed_log('I', 1, :system.current_form, pg_id || ' form_trigger_failure return.');                                                        	
                RAISE form_trigger_failure;
            END IF;
            --lotno ｸ・ﾂ
            w_lotno := :b1.lotno;
            -- COMMIT       
            COMMIT;
            --ﾕﾊﾆｱｴｦﾀ・
            pkg_list.ex_list;
            msg.ed_mess('I', '053', NULL);
            clear_form(no_validate);
            :b1.lotno := w_lotno;
        ELSE
            msg.ed_log('I', 1, :system.current_form, pg_id || ' form_trigger_failure return.');                                                        	
            RAISE form_trigger_failure;
        END IF;
    END IF;
    msg.ed_log('I', 1, :system.current_form, pg_id || 'success');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -100501 THEN
            NULL;
        ELSE
            ROLLBACK;
            msg.ed_mess('E', '031', NULL);
            --message(substr((pg_id||sqlerrm),1,80))｣ｻ
            -- logｼﾍﾂｼ 
            msg.ed_log('E',
                       1,
                       :system.current_form,
                       pg_id || 'failed,error:' || substr(SQLERRM, 1, 80));
            --;pause;
        END IF;
END;
