Set con=createobject("adodb.connection")
Set rs=createobject("adodb.recordset")
'Set rs2=createobject("adodb.recordset")
con.Open "Driver=Oracle in OraHome92;Dbq=fd3a;Uid=pj7960;Pwd=compass1;"

rs.open "select * from SCY901_BEN_POL, SCY909_BEN_CASD where scy901_ben_pol.case_key = 204804 and scy909_ben_casd.case_key = 204804", con
'rs1.open "select * from SCY901_BEN_POL where CASE_KEY = 213044", con
'rs2.open "select * from SCY909_BEN_CASD where case_key = 213044", con

recCount = rs.fields.count
'msgBox "Fields: " & recCount

df "Nature of business", "NATURE_BUS_POL"
df "Industry Code", "IND_CODE_POL"
df "Tax ID Number", "TAX_ID_NO_POL"
df "Employer Type", "EMPLOYER_TYPE_POL"
df "Legal Entity", "LEGAL_ENTTY_POL"
df "Post Scheme Install Status", "POST_SCHEME_INSTALL_STAT_POL"
df "Scheme Orig. Eff. Dt", "ORIG_EFF_DT_POL"
'   Not working--------- 'df "Associated Companies", "ORGNAME_ASSOC_CO" 
df "Policy Issue State", "CONTRACT_ST_POL"
df "Tax State", "TAX_ST_POL"
df "Tax City", "CITY_CD_POL"
df "Tax County", "COUNTY_POL"
df "Block of Business Code", "BLOCK_BSNSS_POL"
df "Cert Code", "CERT_PREP_CD_POL"
df "Booklet Code", "SOLAR_CD_POL"
df "Readable Code", "CTRT_POL"
df "Scheme Provider", "COMPANY_CD_POL"
df "Policy Type", "POL_TYPE_POL"
df "Life claim pay", "CLAIM_PAY_LIF_POL"
df "Dental claim pay", "CLAIM_PAY_DEN_POL"
df "Disability claim pay", "CLAIM_PAY_LTD_POL"
df "Discount card", "DISCOUNT_CARD_POL"
df "Account Executive", "ACCT_EXEC_POL"
df "Service Team", "SERV_TEAM_POL"
df "Customer Tier", "CUSTOMER_TIER_POL"
df "Manual Process Required", "MANUAL_PROCESS_REQ_POL"
df "Tier Reason", "TIER_REASON_POL"
df "E-Commerce", "ECOMMERCE_POL"
df "Distribution Channel", "DSTRB_CHNL_POL"
df "Census indicator", "CENSUS_IND_POL"
df "Marketing Arrangement", "MRKTNG_ARRNGMT_POL"
df "Business Arrangement", "BSNSS_ARRANGMENT_POL"
df "Initial Bill Prep", "BILL_CERT_PREP_POL"
df "Employee Assistance Program", "EMP_ASST_PROG_POL"
df "Multiple Systems", "MULTIPLE_SYSTEMS_POL"
df "Other AEB Policies", "OTHER_FORTIS_POLICIES_POL"
df "Employees outside U.S.", "EMP_NOT_IN_USA_POL"
df "Employees not AAW", "ACTVLY_AT_WORK_POL"
df "Cancel/Rewrite/Spinoff", "ACTN_TYPE_POL"
df "Cancel/Rewrite/Spinoff Old Scheme No.", "CANCEL_REWRITE_OLD_POL"
df "Cancel/Rewrite/Spinoff Prior Coverage", "CASE_TYPE_COV_POL"
df "Ann. Enrollment Type", "ENRLL_TYPE_DEN_POL"
df "Issue Begin Date", "ENRLL_BEG_PRD_DEN_POL"
df "Issue End Date", "ENRLL_END_PRD_DEN_POL"
df "Ann. Enrollment Effective Date", "ANNUAL_ENRLL_EFF_DT_POL"
df "Future Begin Date", "FUT_BEG_PRD_POL"
df "Future End Date", "FUT_END_PRD_POL"
df "ASO/CSO Dental Coverage", "ASO_CSO_COVG_DEN"
df "ASO/CSO LTD Coverage", "ASO_CSO_COVG_LTD"
df "ASO/CSO STD Coverage", "ASO_CSO_COVG_STD"
df "ASO/CSO Plan Info", "ASO_CSO_PLAN_INFO_POL"
df "ASO/CSO Policy No.", "ASO_CSO_POLICY_NUM_POL"
df "Disability Benefit Tax Option", "DIS_BNFT_TAX_OPT_LTD_POL"
df "Policy Anniversary Date", "POL_ANNIV_DT_POL"
df "PARR Code", "PARR_CD_POL"
df "Renewal Type", "RENEW_TYP_POL"
df "Deliver Rate Letter", "DLVR_RT_LTTR_POL"
df "Combined Dividends", "COMB_DIV_POL"
df "Plans Combined for Rating", "PLAN_COMB_POL"
df "Schemes Combined for Rating", "SCHEME_COMB_POL"
df "Other Scheme Numbers", "OTH_SCHEM_NO_POL"
''   Not working--------- 'df "Total Number of Member Groups", 
''   Not working--------- 'Total Number of Bill Groups TOT_....
function df(name, column)
	msgBox name & ": " & rs.fields.item(column)
end function

con.Close