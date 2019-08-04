/*...5....10....15....20....25....30....35....40....45....50....55....60....65....70
+==================================================================================+
|             Copyright (C) 2004 NS Solutions Corporation,                         |
|                         All Rights Reserved.                                     |
+==================================================================================+
* ==================================================================================
*
*   NAME  pkg_ctrl
*   COMMONS｣ｺｻｭﾃ豼ﾘﾖﾆﾓﾃｵﾄPACKAGE
*
*   DESCRIPTION
*
*   HISTORY
*        1.00  2005/07/18  kanli(P@W)
* =================================================================================*/
PACKAGE BODY pkg_ctrl IS
    -- --------------------------------------------------------------------------------
    -- Program Name      : init_form
    -- Description       : ｻｭﾃ豕ｼｻｯ
    -- Arguments         : 
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE init_form IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_CTRL.INIT_FORM:';
    BEGIN
    
        -- logｼﾇﾂｼ 
        msg.ed_log('I', 1, :system.current_form, 'form start');
        
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
    END init_form;
    -- --------------------------------------------------------------------------------
    -- Program Name      : set_status
    -- Description       : ﾉ靹ﾃﾊｾﾝｿ鯑ﾚﾏ鍗ｿｿﾉｷ菠・
    -- Arguments         : p_block IN VARCHAR2
    --                   : p_status IN NUMBER 0:TRUE; 1:FALSE
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE set_status(p_block  IN VARCHAR2,
                         p_status IN NUMBER) IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_CTRL.SET_STATUS:';
        w_curr_item  VARCHAR2(50);
        w_block_item VARCHAR2(50);
        w_canvas     VARCHAR2(50);
    BEGIN
    
        -- logｼﾍﾂｼ 
        msg.ed_log('I', 1, :system.current_form, pg_id || 'start');
    
        w_curr_item := get_block_property(p_block, first_item);
        WHILE w_curr_item IS NOT NULL
        LOOP
            -- ﾖｻｿﾘﾖﾆﾎﾄｱｾﾏ・
            IF get_item_property(w_curr_item, item_type) = 'TEXT ITEM' THEN
                IF p_status = 0 THEN
                    set_item_property(w_curr_item, enabled, property_true);
                ELSE
                    set_item_property(w_curr_item, enabled, property_false);
                END IF;
            END IF;
        
            -- ﾈ｡ｵﾃﾏﾂﾒｻｸ鍗ｿ
            w_curr_item := get_item_property(w_curr_item, nextitem);
        END LOOP;
    
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
    END set_status;

    -- --------------------------------------------------------------------------------
    -- Program Name      : set_err
    -- Description       : ﾉ靹ﾃﾊｾﾝｿ鯑ﾚﾏ鍗ｿﾊﾇｷﾐｴ﨔・
    -- Arguments         : p_item IN VARCHAR2
    --                   : p_status IN NUMBER 0:NORMAL; 1:ERROR
    -- Returns           : 
    -- Notes             :
    -- ModifyDate/Author :
    -- --------------------------------------------------------------------------------
    PROCEDURE set_err(p_item   IN VARCHAR2,
                      p_status IN NUMBER) IS
        pg_id CONSTANT VARCHAR2(50) DEFAULT 'PKG_CTRL.SET_ERR:';
    BEGIN
    
        IF p_status = 0 THEN
            set_item_instance_property(p_item,
                                       current_record,
                                       visual_attribute,
                                       'VIS_TEXT');
        ELSE
            set_item_instance_property(p_item,
                                       current_record,
                                       visual_attribute,
                                       'VIS_ERR');
        END IF;
    
    EXCEPTION
        WHEN OTHERS THEN
            --IF SQLCODE = -100501 THEN
            --    NULL;
            --ELSE
            -- logｼﾍﾂｼ 
            msg.ed_log('E',
                       1,
                       :system.current_form,
                       pg_id || 'failed,error:' || substr(SQLERRM, 1, 80));
            --RAISE;
        --END IF;
    END set_err;
END;
