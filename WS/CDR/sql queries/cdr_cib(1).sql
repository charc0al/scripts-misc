SELECT CASE_DATA.CASE_KEY    CASE_KEY_CIB,
       BEN_TYPES.BNTP_KEY    BNTP_KEY_CIB,
       CDR_VIEW.MBGP_KEY_CIB  MBGP_KEY_CIB,
       CASE_DATA.CONT_NO     SCHEME_NO_CIB,
       CASE_DATA.PLAN_NM     SCHEME_NM_CIB,
       BEN_TYPES.DESCRIPT    BEN_DESC_CIB,
--- Start FIRST Section of new CDR prototype form, Critical Illness Tab
       CDR_VIEW.BNTP_EFF_DT_CIB,
       TO_DATE(SCY708_BEN_LKUP.GET_BEOP_VALUE('COVG_ORIG_EFF_DATE_CIB',
                                              CASE_DATA.CASE_KEY,
                                              NULL, NULL,
                                              SYSDATE,'L'),'YYYY/MM/DD')  
                                                          COVG_ORIG_EFF_DATE_CIB,
       CDR_VIEW.ELGBL_PRSN_CIB,
       CDR_VIEW.ELGBL_PRSN2_CIB,
       SCY708_BEN_LKUP.GET_MBGP_DESC(CDR_VIEW.MBGP_KEY_CIB,
                                     CASE_DATA.CASE_KEY,
                                     CDR_VIEW.DUP_BEN_MBGP_CIB) MBR_GRP_DESC_CIB,
       CDR_VIEW.SLR_MBR_GRP_KEY_CIB,
       -- Solar Member Group Key field is duplicated in the form
       CDR_VIEW.DOMESTIC_PARTNER_CIB,
       ENH_ELIG_RULES.MIN_HOURS                                MIN_PERIODIC_HRS_CIB,
       SCY708_BEN_LKUP.F_GET_PERIODIC_HRS_DEF(ENH_ELIG_RULES.SLRY_KEY)
                                                               PERIODIC_HRS_DEF_CIB,
       SCY708_BEN_LKUP.GET_CTRB_DESC(RISK_RULE_DETL.FDRT_KEY, SYSDATE)
                                                               CONTRIB_CIB,
       CDR_VIEW.CONTRACT_PART_CIB,
       CDR_VIEW. PARTIC_ARRNGMT_CIB,
       SCY708_BEN_LKUP.GET_REF_CD_DESC(RISK_RULES.PRRT_CD,'RKRL PRRT CD')
                                                               BILL_PROR_METH_CIB,
       SCY708_BEN_LKUP.GET_REF_CD_DESC(RISK_RULES.REL_TYP_CD, 'RKRL REL TYP CD') 
                                                              THIS_IS_A_CELL_BEN_CIB, 
                                                          --this is a ____ benefit
--- Start SECOND Section
       ENH_ELIG_RTRNCH_ISS.MIN_SRVC_PRD                        ISS_SRVC_RQT_CIB,
       SCY708_BEN_LKUP.GET_SVDF_DESC(ENH_ELIG_RTRNCH_ISS.SVDF_KEY) 
                                                               ISS_SRVC_RQT_MOD_CIB,
       ENH_ELIG_RTRNCH_FUT.MIN_SRVC_PRD                        FUT_SRVC_RQT_CIB,
       SCY708_BEN_LKUP.GET_SVDF_DESC(ENH_ELIG_RTRNCH_FUT.SVDF_KEY) 
                                                               FUT_SRVC_RQT_MOD_CIB,
       DECODE(ENH_ELIG_RTRNCH_FUT.EDRL_KEY,
                  NULL, 'Immediate', 
                  EFF_DT_RULES.DESCRIPT)                       ENTRY_DT_CIB,
       CDR_VIEW.SPC_ENTRY_DT_CIB,
       SCY708_BEN_LKUP.F_GET_TERM_DT(CASE_DATA.CASE_KEY, CDR_VIEW.BNTP_KEY)
                                                               TERM_DT_CIB,
       CDR_VIEW.SPC_TERM_DT_CIB,
       CDR_VIEW.TERM_DT_MODE_CIB,
--- Start THIRD Section
       CDR_VIEW.LEVEL_CIB,
       CDR_VIEW.WELLNESS_CIB,
       CDR_VIEW.RECRRNC_CIB, 
       CDR_VIEW.RECRRNC_TIME_CIB,
       CDR_VIEW.ADDNL_OCCRNC_CIB,
--- Start FOURTH Section
       CDR_VIEW.MIN_BNFT_EE_CIB,
       CDR_VIEW.MIN_BNFT_SP_CIB,
       CDR_VIEW.MIN_BNFT_CH_CIB,
       CDR_VIEW.MAX_BNFT_EE_CIB,
       CDR_VIEW.MAX_BNFT_SP_CIB, 
       CDR_VIEW.MAX_BNFT_CH_CIB, 
       CDR_VIEW.UNIT_AMT_CIB,
       CDR_VIEW.EMPLOYEE_GI_CIB,
       SCY708_BEN_LKUP.F_GET_RKBS_BASIS_XAMT(RISK_BEN_TRNCH.RKBT_KEY, SYSDATE)
                                                               REDUC_RND_AMT_CIB,
       SCY708_BEN_LKUP.GET_REF_CD_LOOKUP(SCY708_BEN_LKUP.F_GET_RKBS_OPERATION_CD
                                              (RISK_BEN_TRNCH.RKBT_KEY,SYSDATE),
                                         'RISK_BEN_SENTENCE',
                                         'OPERATION_CD')       REDUC_RND_TYP_CIB,
       CDR_VIEW.MIN_BEN_RDCTN_CIB                                                                 REDUCTION_CIB,
       CDR_VIEW.MIN_PART_AGE_CIB,
       CDR_VIEW.PRE_EXST_CIB,
CDR_VIEW.INCR_PRE_EXST_CIB,
-- Census Age Type (see description below)
       CDR_VIEW.PR_CVG_CIB,
       CDR_VIEW.INCR_PRE_EXST_CIB,
--- Start FIFTH Section
       SCY708_BEN_LKUP.F_GET_SLRY_CHG_DT(BEN_TYPES.BNTP_KEY, SYSDATE)
                                                               SLRY_CHNG_DT_CIB,
       CDR_VIEW.STUDENT_AGE_CIB,
       CDR_VIEW.STUD_MAX_AGE_CIB,
       CDR_VIEW.CNTRCT_TYPE_CIB,
       CDR_VIEW.SERIES_CIB,
--- Start SIXTH Section
       CDR_VIEW.S125_PLAN_CIB,
       CDR_VIEW.S125_TAX_CIB,
       CDR_VIEW.EMP_CNTRB_MO_CIB,
       CDR_VIEW.EE_CNTRB_MO_CIB,
   SCB_BEN_LKUP.F_GET_COMMISSION_SCALE(CDR_VIEW.CASE_KEY,
                                           CDR_VIEW.BNTP_KEY,
                                           SYSDATE)       COMM_SCALE_CIB,
       CDR_VIEW.MIN_PART_AGE_CIB,
       CDR_VIEW.BROKER_FEE_CIB,
       CDR_VIEW.SERVICE_FEE_CIB,
--- Start SEVENTH Section
       CDR_VIEW.SOLAR_GRP_ID_CIB,
       CDR_VIEW.SOLAR_SCHED_SEQ_NUM_CIB,
       CDR_VIEW.SOLAR_SEQ_NUM_CIB,
       TO_DATE(CDR_VIEW.APP_SIG_DT_CIB,'YYYY/MM/DD')           APP_SIG_DT_CIB,
       SCY708_BEN_LKUP.GET_PLAN_TYPE(BEN_TYPES.BNTP_KEY)       PLAN_TYPE_CIB,
       CDR_VIEW.PLAN_TYPE_ID_SUB_CIB,
       CDR_VIEW.SL_RTNG_ADMIN_CIB,
       CDR_VIEW.TPA_ALLOW_CIB,
       CDR_VIEW.RISK_CIB,
       CDR_VIEW.ACT_PARTIC_PCT_CIB,
       CDR_VIEW.RATE_GUAR_MO_CIB,
       CDR_VIEW.POOLING_CD_CIB,
       CDR_VIEW.RT_CHG_RSN_CD_CIB
       --CDR_VIEW.AGE_RATES_CIB
  FROM SCY924_BEN_CIB     CDR_VIEW,
       CASE_DATA,
       BEN_TYPES,
       RISK_RULES,
       RISK_RULE_DETL,
       RISK_BEN_TRNCH,
       ENH_ELIG_RULES,
       EFF_DT_RULES,
       ENH_ELIG_RTRNCH   ENH_ELIG_RTRNCH_ISS,
       ENH_ELIG_RTRNCH   ENH_ELIG_RTRNCH_FUT
 WHERE CDR_VIEW.RPT_KEY = 22606
   AND CDR_VIEW.CASE_KEY = CASE_DATA.CASE_KEY
   AND CDR_VIEW.BNTP_KEY = BEN_TYPES.BNTP_KEY
   AND BEN_TYPES.BNTP_KEY = RISK_RULES.BNTP_KEY
   AND risk_rule_detl.rsk_shr_pct = 100
   AND RISK_RULE_DETL.EFF_DT <= SYSDATE
   AND (RISK_RULE_DETL.XPIR_DT >= SYSDATE 
        OR RISK_RULE_DETL.XPIR_DT IS NULL)
   AND RISK_BEN_TRNCH.EFF_DT <= SYSDATE
   AND (RISK_BEN_TRNCH.XPIR_DT >= SYSDATE 
        OR RISK_BEN_TRNCH.XPIR_DT IS NULL)
   AND RISK_RULES.RKRL_KEY = RISK_RULE_DETL.RKRL_KEY
   AND RISK_RULE_DETL.RKRL_KEY = RISK_BEN_TRNCH.RKRL_KEY
   AND RISK_BEN_TRNCH.RKRL_KEY = ENH_ELIG_RULES.RKRL_KEY
   AND ENH_ELIG_RULES.EERL_KEY = ENH_ELIG_RTRNCH_ISS.EERL_KEY
   AND ENH_ELIG_RTRNCH_ISS.GF_CD = '1'
   AND ENH_ELIG_RULES.EERL_KEY = ENH_ELIG_RTRNCH_FUT.EERL_KEY
   AND ENH_ELIG_RTRNCH_FUT.GF_CD = '0'
   AND ENH_ELIG_RTRNCH_FUT.EDRL_KEY = EFF_DT_RULES.EDRL_KEY(+)
   AND ENH_ELIG_RTRNCH_ISS.EFF_DT <= SYSDATE
   AND (ENH_ELIG_RTRNCH_ISS.XPIR_DT >= SYSDATE 
        OR ENH_ELIG_RTRNCH_ISS.XPIR_DT IS NULL)
   AND ENH_ELIG_RTRNCH_FUT.EFF_DT <= SYSDATE
   AND (ENH_ELIG_RTRNCH_FUT.XPIR_DT >= SYSDATE 
        OR ENH_ELIG_RTRNCH_FUT.XPIR_DT IS NULL)
 ORDER BY BEN_TYPES.SEQ_NUM;
