SELECT CASE_DATA.CASE_KEY    CASE_KEY_ACC,
       BEN_TYPES.BNTP_KEY    BNTP_KEY_ACC,
       CDR_VIEW.MBGP_KEY_ACC MBGP_KEY_ACC,
       CASE_DATA.CONT_NO     SCHEME_NO_ACC,
       CASE_DATA.PLAN_NM     SCHEME_NM_ACC,
       BEN_TYPES.DESCRIPT    BEN_DESC_ACC,
--- Start FIRST Section of new CDR prototype form, Accident Tab
       CDR_VIEW.BNTP_EFF_DT_ACC,
       TO_DATE(SCY708_BEN_LKUP.GET_BEOP_VALUE('COVG_ORIG_EFF_DATE_STD',
                                              CASE_DATA.CASE_KEY,
                                              NULL,NULL,
                                              SYSDATE,'L'),
                                              'YYYY/MM/DD')COVG_ORIG_EFF_DATE_ACC,
       CDR_VIEW.ELGBL_PRSN_ACC,
       CDR_VIEW.ELGBL_PRSN2_ACC,
       SCY708_BEN_LKUP.GET_MBGP_DESC(CDR_VIEW.MBGP_KEY_ACC,
                                     CASE_DATA.CASE_KEY,
                                     CDR_VIEW. DUP_BEN_MBGP_ACC) MBR_GRP_DESC_ACC,
       CDR_VIEW.SLR_MBR_GRP_KEY_ACC,
       -- Solar Member Group Key field is duplicated on the CDR form
       CDR_VIEW.DOMESTIC_PARTNER_ACC,
       ENH_ELIG_RULES.MIN_HOURS                             MIN_PERIODIC_HRS_ACC,
       SCY708_BEN_LKUP.F_GET_PERIODIC_HRS_DEF(ENH_ELIG_RULES.SLRY_KEY)
                                                            PERIODIC_HRS_DEF_ACC,
       SCY708_BEN_LKUP.GET_CTRB_DESC(RISK_RULE_DETL.FDRT_KEY,
                                     SYSDATE)         CONTRIB_ACC,
       --CDR_VIEW.CONTRACT_PART_ACC,
       CDR_VIEW.PARTIC_ARRNGMT_ACC,
       SCY708_BEN_LKUP.GET_REF_CD_DESC(RISK_RULES.PRRT_CD,'RKRL PRRT CD')
                                                            BILL_PROR_METH_ACC,
       SCY708_BEN_LKUP.GET_REF_CD_DESC(RISK_RULES.REL_TYP_CD,'RKRL REL TYP CD')
                                                            THIS_IS_A_CELL_BEN_ACC, 
                                                           --this is a ____ benefit
--- Start SECOND Section
       ENH_ELIG_RTRNCH_ISS.MIN_SRVC_PRD                     ISS_SRVC_RQT_ACC,
       SCY708_BEN_LKUP.GET_SVDF_DESC(ENH_ELIG_RTRNCH_ISS.SVDF_KEY)
                                                            ISS_SRVC_RQT_MOD_ACC,
       ENH_ELIG_RTRNCH_FUT.MIN_SRVC_PRD                     FUT_SRVC_RQT_ACC,
       SCY708_BEN_LKUP.GET_SVDF_DESC(ENH_ELIG_RTRNCH_FUT.SVDF_KEY)
                                                            FUT_SRVC_RQT_MOD_ACC,
       DECODE(ENH_ELIG_RTRNCH_FUT.EDRL_KEY,
                      NULL, 'Immediate',
                      EFF_DT_RULES.DESCRIPT)                ENTRY_DT_ACC,
       CDR_VIEW.SPC_ENTRY_DT_ACC,
       SCY708_BEN_LKUP.F_GET_TERM_DT(CASE_DATA.CASE_KEY, 
                                     CDR_VIEW.BNTP_KEY)     TERM_DT_ACC,
       CDR_VIEW.SPC_TERM_DT_ACC,
       CDR_VIEW.TERM_DT_MODE_ACC,
--- Start THIRD Section
       CDR_VIEW.ACC_TYPE,
       CDR_VIEW.SP_DSBLTY_DUR,
       CDR_VIEW.SP_DSBLTY_AMT,
       CDR_VIEW.WELLNESS_BNFT_ACC,
       CDR_VIEW.EMERGENCY_ROOM,
       CDR_VIEW.NON_EMERG_ROOM,
       CDR_VIEW.ACCIDENTAL_DEATH,
       --CDR_VIEW.ACCID_DEATH_SP,  -- Column being added to SCV915_BEN_ACC view
       --CDR_VIEW.ACCID_DEATH_CH,  -- Column being added to SCV915_BEN_ACC view
--- Start FOURTH Section
       SCY708_BEN_LKUP.F_GET_SLRY_CHG_DT(BEN_TYPES.BNTP_KEY,
                                          SYSDATE)    SLRY_CHNG_DT_ACC, 
       CDR_VIEW.CH_MAX_AGE_ACC,
       CDR_VIEW.STUDENT_AGE_ACC,
       CDR_VIEW.CNTRCT_TYPE_ACC,
       CDR_VIEW.SERIES_ACC,
--- Start FIFTH Section
       CDR_VIEW.S125_PLAN_ACC,
       CDR_VIEW.S125_TAX_ACC,
       CDR_VIEW.EMP_CNTRB_TYP_ACC,
       CDR_VIEW.NUM_ELIG_DEP_ACC,
       CDR_VIEW.NUM_PARTICIP_DEP_ACC,
       CDR_VIEW. PARTIC_DEP_ACC,
       SCB_BEN_LKUP.F_GET_COMMISSION_SCALE(CDR_VIEW.CASE_KEY,
                                           CDR_VIEW.BNTP_KEY,
                                           SYSDATE)   COMM_SCALE_ACC,
       CDR_VIEW.SERVICE_FEE_ACC,
       CDR_VIEW.BROKER_FEE_ACC,
--- Start SIXTH Section
       CDR_VIEW.SOLAR_GRP_ID_ACC,
       CDR_VIEW.SOLAR_SCHED_SEQ_NUM_ACC,
       CDR_VIEW.SOLAR_SEQ_NUM_ACC,
       TO_DATE(CDR_VIEW.APP_SIG_DT_ACC,'YYYY/MM/DD')        APP_SIG_DT_ACC,
       SCY708_BEN_LKUP.GET_PLAN_TYPE(BEN_TYPES.BNTP_KEY)    PLAN_TYPE_ACC,
       CDR_VIEW.PLAN_TYPE_ID_SUB_ACC,
       CDR_VIEW.SL_RTNG_ADMIN_ACC,
       CDR_VIEW.TPA_ALLOW_ACC,
       CDR_VIEW.RISK_ACC,
       CDR_VIEW.ACT_PARTIC_PCT_ACC,
       CDR_VIEW.RATE_GUAR_MO_ACC,
       CDR_VIEW.POOLING_CD_ACC,
       CDR_VIEW.RT_CHG_RSN_CD_ACC,
       CDR_VIEW.AGE_RATES_ACC
  FROM SCY915_BEN_ACC   CDR_VIEW,
       CASE_DATA,
       BEN_TYPES,
       RISK_RULES,
       RISK_RULE_DETL,
       RISK_BEN_TRNCH,
       ENH_ELIG_RULES,
       EFF_DT_RULES,
       ENH_ELIG_RTRNCH ENH_ELIG_RTRNCH_ISS,
       ENH_ELIG_RTRNCH ENH_ELIG_RTRNCH_FUT
 WHERE CDR_VIEW.RPT_KEY = 22606
--   AND CDR_VIEW.SBGC_KEY = :V_SBCG_KEY
   AND CDR_VIEW.CASE_KEY = CASE_DATA.CASE_KEY
   AND CDR_VIEW.BNTP_KEY = BEN_TYPES.BNTP_KEY
   AND BEN_TYPES.BNTP_KEY = RISK_RULES.BNTP_KEY
   AND RISK_RULE_DETL.RSK_SHR_PCT = 100
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
