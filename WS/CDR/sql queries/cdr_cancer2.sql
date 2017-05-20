SELECT CASE_DATA.CASE_KEY     CASE_KEY_CAN,
       BEN_TYPES.BNTP_KEY     BNTP_KEY_CAN,
       CDR_VIEW.MBGP_KEY_CAN  MBGP_KEY_CAN,
       CASE_DATA.CONT_NO      SCHEME_NO_CAN,
       CASE_DATA.PLAN_NM      SCHEME_NM_CAN,
       BEN_TYPES.DESCRIPT     BEN_DESC_CAN,
--- Start FIRST Section of new CDR prototype form, Cancer Tab
       CDR_VIEW.BNTP_EFF_DT_CAN,
       TO_DATE(SCY708_BEN_LKUP.GET_BEOP_VALUE('COVG_ORIG_EFF_DATE_CAN',
                                              CASE_DATA.CASE_KEY,
                                              NULL, NULL,
                                              '19-JUN-2012','L'),'YYYY/MM/DD')  
                                                          COVG_ORIG_EFF_DATE_CAN,
       CDR_VIEW.ELGBL_PRSN_CAN,
       CDR_VIEW.ELGBL_PRSN2_CAN,
       SCY708_BEN_LKUP.GET_MBGP_DESC(CDR_VIEW.MBGP_KEY_CAN,
                                     CASE_DATA.CASE_KEY,
                                     CDR_VIEW.DUP_BEN_MBGP_CAN) MBR_GRP_DESC_CAN,
       CDR_VIEW.SLR_MBR_GRP_KEY_CAN,
       -- Solar Member Group Key field is duplicated on the CDR form
       CDR_VIEW.DOMESTIC_PARTNER_CAN,
       ENH_ELIG_RULES.MIN_HOURS                               MIN_PERIODIC_HRS_CAN,
       SCY708_BEN_LKUP.F_GET_PERIODIC_HRS_DEF(ENH_ELIG_RULES.SLRY_KEY)
                                                              PERIODIC_HRS_DEF_CAN,
       SCY708_BEN_LKUP.GET_CTRB_DESC(RISK_RULE_DETL.FDRT_KEY, '19-JUN-2012')
                                                              CONTRIB_CAN,
       CDR_VIEW.CONTRACT_PART_CAN,
       CDR_VIEW. PARTIC_ARRNGMT_CAN,
       SCY708_BEN_LKUP.GET_REF_CD_DESC(RISK_RULES.PRRT_CD,'RKRL PRRT CD')
                                                              BILL_PROR_METH_CAN,
       SCY708_BEN_LKUP.GET_REF_CD_DESC(RISK_RULES.REL_TYP_CD, 'RKRL REL TYP CD') 
                                                            THIS_IS_A_CELL_BEN_CAN, 
                                                          --this is a ____ benefit
--- Start SECOND Section
       ENH_ELIG_RTRNCH_ISS.MIN_SRVC_PRD                       ISS_SRVC_RQT_CAN,
       SCY708_BEN_LKUP.GET_SVDF_DESC(ENH_ELIG_RTRNCH_ISS.SVDF_KEY) 
                                                              ISS_SRVC_RQT_MOD_CAN,
       ENH_ELIG_RTRNCH_FUT.MIN_SRVC_PRD                       FUT_SRVC_RQT_CAN,
       SCY708_BEN_LKUP.GET_SVDF_DESC(ENH_ELIG_RTRNCH_FUT.SVDF_KEY) 
                                                              FUT_SRVC_RQT_MOD_CAN,
       DECODE(ENH_ELIG_RTRNCH_FUT.EDRL_KEY,
                  NULL, 'Immediate', 
                  EFF_DT_RULES.DESCRIPT)                      ENTRY_DT_CAN,
       CDR_VIEW.SPC_ENTRY_DT_CAN,
       SCY708_BEN_LKUP.F_GET_TERM_DT(CASE_DATA.CASE_KEY, CDR_VIEW.BNTP_KEY)
                                                              TERM_DT_CAN,
       CDR_VIEW.SPC_TERM_DT_CAN,
       CDR_VIEW.TERM_DT_MODE_CAN,
--- Start THIRD Section
       -- Plan Type (this field is duplicated, should be in the fifth section)
       -- EOI ? See description below
       -- The GI fields are not needed on the Cancer tab
       CDR_VIEW.PRE_EXIST_CAN,
       -- Census Age Type ? See description below
--- Start FOURTH Section
       SCY708_BEN_LKUP.F_GET_SLRY_CHG_DT(BEN_TYPES.BNTP_KEY, '19-JUN-2012')
                                                               SLRY_CHNG_DT_CAN,
       CDR_VIEW.STUDENT_AGE_CAN,
       CDR_VIEW.STUD_MAX_AGE_CAN,
       CDR_VIEW.CNTRCT_TYPE_CAN,
       CDR_VIEW.SERIES_CAN,
--- Start FIFTH Section
       CDR_VIEW.S125_PLAN_CAN,
       CDR_VIEW.S125_TAX_CAN,
       CDR_VIEW. EMP_CNTRB_MO_CAN,
       SCB_BEN_LKUP.F_GET_COMMISSION_SCALE(CDR_VIEW.CASE_KEY,
                                          CDR_VIEW.BNTP_KEY,
                                          '19-JUN-2012')        COMM_SCALE_CAN,
       CDR_VIEW. MIN_PART_AGE_CAN,
       CDR_VIEW.BROKER_FEE_CAN,
       CDR_VIEW.SERVICE_FEE_CAN,
--- Start SIXTH Section
       CDR_VIEW.SOLAR_GRP_ID_CAN,
       CDR_VIEW.SOLAR_SCHED_SEQ_NUM_CAN,
       CDR_VIEW.SOLAR_SEQ_NUM_CAN,
       TO_DATE(CDR_VIEW.APP_SIG_DT_CAN,'YYYY/MM/DD')          APP_SIG_DT_CAN,
       SCY708_BEN_LKUP.GET_PLAN_TYPE(BEN_TYPES.BNTP_KEY)      PLAN_TYPE_CAN,
       CDR_VIEW.PLAN_TYPE_ID_SUB_CAN,
       CDR_VIEW.SL_RTNG_ADMIN_CAN,
       CDR_VIEW.TPA_ALLOW_CAN,
       CDR_VIEW.RISK_CAN,
       CDR_VIEW.ACT_PARTIC_PCT_CAN,
       CDR_VIEW.RATE_GUAR_MO_CAN,
       CDR_VIEW.POOLING_CD_CAN,
       CDR_VIEW.RT_CHG_RSN_CD_CAN,
       CDR_VIEW.AGE_RATES_CAN
  FROM SCY927_BEN_CAN   CDR_VIEW,
      CASE_DATA,
      BEN_TYPES,
      RISK_RULES,
      RISK_RULE_DETL,
      RISK_BEN_TRNCH,
      ENH_ELIG_RULES,
      EFF_DT_RULES,
      ENH_ELIG_RTRNCH  ENH_ELIG_RTRNCH_ISS,
      ENH_ELIG_RTRNCH  ENH_ELIG_RTRNCH_FUT
WHERE CDR_VIEW.RPT_KEY = 22606
  AND CDR_VIEW.CASE_KEY = CASE_DATA.CASE_KEY
  AND CDR_VIEW.BNTP_KEY = BEN_TYPES.BNTP_KEY
  AND BEN_TYPES.BNTP_KEY = RISK_RULES.BNTP_KEY
  AND risk_rule_detl.rsk_shr_pct = 100
  AND RISK_RULE_DETL.EFF_DT <= '19-JUN-2012'
  AND (RISK_RULE_DETL.XPIR_DT >= '19-JUN-2012' 
       OR RISK_RULE_DETL.XPIR_DT IS NULL)
  AND RISK_BEN_TRNCH.EFF_DT <= '19-JUN-2012'
  AND (RISK_BEN_TRNCH.XPIR_DT >= '19-JUN-2012'
       OR RISK_BEN_TRNCH.XPIR_DT IS NULL)
  AND RISK_RULES.RKRL_KEY = RISK_RULE_DETL.RKRL_KEY
  AND RISK_RULE_DETL.RKRL_KEY = RISK_BEN_TRNCH.RKRL_KEY
  AND RISK_BEN_TRNCH.RKRL_KEY = ENH_ELIG_RULES.RKRL_KEY
  AND ENH_ELIG_RULES.EERL_KEY = ENH_ELIG_RTRNCH_ISS.EERL_KEY
  AND ENH_ELIG_RTRNCH_ISS.GF_CD = '1'
  AND ENH_ELIG_RULES.EERL_KEY = ENH_ELIG_RTRNCH_FUT.EERL_KEY
  AND ENH_ELIG_RTRNCH_FUT.GF_CD = '0'
  AND ENH_ELIG_RTRNCH_FUT.EDRL_KEY = EFF_DT_RULES.EDRL_KEY(+)
  AND ENH_ELIG_RTRNCH_ISS.EFF_DT <= '19-JUN-2012'
  AND (ENH_ELIG_RTRNCH_ISS.XPIR_DT >= '19-JUN-2012' 
       OR ENH_ELIG_RTRNCH_ISS.XPIR_DT IS NULL)
  AND ENH_ELIG_RTRNCH_FUT.EFF_DT <= '19-JUN-2012'
  AND (ENH_ELIG_RTRNCH_FUT.XPIR_DT >= '19-JUN-2012' 
       OR ENH_ELIG_RTRNCH_FUT.XPIR_DT IS NULL)
ORDER BY BEN_TYPES.SEQ_NUM;
