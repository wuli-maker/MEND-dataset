clear all
set more off
set maxvar 10000
global root="C:\Users\25051\Desktop\CLHLS"
************************* 注：运行前更改上述路径 *******************************
global dofiles="$root\Dofiles"
global logfiles="$root\Logfiles"
global raw_data="$root\Raw_data"
global working_data="$root\Working_data"
cap mkdir "$working_data"
cap mkdir "$tables"          //'cap'命令可让错误的代码继续运行
cap mkdir "$figures"
cap mkdir "$dofiles"         //如果已经创建了这些文件夹,也可以运行
cap mkdir "$logfiles"


use "$raw_data\CLHLS_dataset_2008-2018_SPSS\clhls_2008_2018_longitudinal.dta", clear

**************************************************************************
label var yearin "2008/2009 入组"
count if yearin==2008|2009 //16.954

label var dth08_11 "2011年调查中的存活状态"
label define dth08_11_lbl -9 "失访" 0 "存活" 1 "死亡" 2 "死亡"
label values dth08_11 dth08_11_lbl
count if dth08_11==0 //surviving sample during 08-11:8,418(2008,2011)

label var dth11_14 "2014年调查中的存活状态"
label define dth11_14_lbl -9  "失访" 0 "存活" -8 "死亡/失访" 1 "死亡"
label values dth11_14 dth11_14_lbl 
count if dth11_14==0 //surviving sample during 08-14:5,245(2088, 2011, 2014)

label var dth14_18 "2018年调查中的存活状态"
label define dth14_18_lbl -9 "失访" 0 "存活" 1 "死亡"
label values dth14_18 dth14_18_lbl
count if dth14_18==0 //surviving sample during 08-18:2,440(2008,2011,2014, 2018)

**************************************************************************
*人口特征学变量
*注:8/9代表无法回答和缺失
*年龄trueage vage_11 trueage_14 trueage_18 年龄在数据集已生成
rename trueage trueage_08
gen trueage_11=vage_11
replace trueage_11=. if trueage_11==-9 | trueage_11==-7

*性別
recode a1 (1=1) (2=0), gen(sex)  //男为1,女为8
label define sex_lbl 1 "男" 0 "女"
label values sex sex_lbl

*民族
recode a2 (1=1) (2/8=0), gen(ethnic) //汉族为1,非汉族为θ
label define ethnic_lbl 1 "汉族" 0 "非汉族"
label values ethnic ethnic_lbl

*出生地
recode a43 (1=1) (2=0) (8/9=.), gen(birth_place)  //城市为1,农村为0
label define birth_place_lbl 1 "城市" 0 "农村"
label values birth_place birth_place_lbl

*教育状况无11年
recode f1 (88/99=.), gen(edu_08)  //years of schooling
recode f1_14 (88/99=.), gen(edu_14)
recode f1_18 (88/99=.), gen(edu_18)

*婚姻状况
recode f41 (2/5=8), gen(marital_08) // living without partners(separated,divorced,widowed,never married)=0,curently maried and living with spouse=1
recode f41_11 (-9/-7=.) (2/5=0) (8/9=.), gen(marital_11)
recode f41_14 (2/5=0) (9=.), gen(marital_14)
recode f41_18 (2/5=0), gen(marital_18)
label define marital_lbl 1 "已婚和伴侣住" 0 "其他"
label values marital_08 marital_11 marital_14 marital_18 marital_lbl

*生活是否富裕(和当地的其他人相比)
recode f34 (1/2=1) (3/5=0) (8/9=.), gen(econ_state_08)
recode f34_11 (1/2=1) (3/5=0) (8/9=.) (-9/-7=.), gen(econ_state_11)
recode f34_14 (1/2=1) (3/5=0) (8/9=.), gen(econ_state_14)
recode f34_18 (1/2=1) (3/5=0) (8/9=.), gen(econ_state_18)
label define econ_state_lbl 1 "富裕及以上" 0 "一般及以下"
label values econ_state_08 econ_state_11 econ_state_14 econ_state_18 econ_state_lbl

*上一年家庭收入
recode f35 (99999=.), gen(income_08)  // total income of your household last year 超过10万元：99998
recode f35_11 (-9/-7=.) (99999=.), gen(income_11)
recode f35_14 (99999=.), gen(income_14)
recode f35_18 (99999=.), gen(income_18)

*保险状测
gen basic_medical_insur_08=f64f //08不区分基本医保明细
label define insur_lbl 1 "有基本医疗保险" 0 "没有基本医疗保险"
label values basic_medical_insur_08 insur_lbl

recode f64e1_11 (-9/-7=.) (8/9=.), gen(uebmi_11)
label define uebmi_lbl 1 "有城职保" 0 "无城职保"
label values uebmi_11 uebmi_lbl
recode f64f1_11 (-9/-7=.) (8/9=.), gen(urbmi_11)
label define urbmi_lbl 1 "有城居保" 0 "无城居保"
label values urbmi_11 urbmi_lbl
recode f64g1_11 (-9/-7=.) (8/9=.), gen(nrcm_11)
label define nrcm_lbl 1 "有新农合" 0 "无新农合"
label values nrcm_11 nrcm_lbl

recode f64e_14 (9=.), gen(uebmi_14)
label define uebmi_lbl_14 1 "有城职保" 0 "无城职保"
label values uebmi_14 uebmi_lbl_14
recode f64f_14 (9=.), gen(urbmi_14)
label define urbmi_lbl_14 1 "有城居保" 0 "无城居保"
label values urbmi_14 urbmi_bl_14
recode f64g_14 (9=.), gen(nrcm_14)
label define nrcm_lbl_14 1 "有新农合" 0 "无新农合"
label values nrcm_14 nrcm_lbl_14

gen uebmi_18=f64e_18
label define uebmi_lb1_18 1 "有城职保/城居保" 0 "无城职保/城居保"
label values uebmi_18 uebmi_lbl_18
gen nrcm_18=f64g_18
label define nrcm_lbl_18 1 "有新农合" 0 "无新农合"
label values nrcm_18 nrcm_lbl_18

*居住状态
gen co_residence_08 = a51
recode a51_11 (-9/-7=.) (9=.), gen(co_residence_11)
recode a51_14 (8=.), gen(co_residence_14)
gen co_residence_18 = a51_18
label define co_residence_lbl 1 "与家庭成员同住" 2 "独居" 3 "在机构居住"  //co-residence of interviewee; 1 with household member; 2 alone; 3 in an institution
label values co_residence_08 co_residence_11 co_residence_14 co_residence_18 co_residence_lbl

*子女数量（曾经生过的孩子数量）
recode f10 (88/99=.), gen(children_number_08)
recode f10_11 (-9/-7=.) (88/99=.), gen(children_number_11)
recode f10_14 (88/99=.), gen(children_number_14)
recode f10_18 (88/99=.), gen(children_number_18)

*目前是否吸烟
recode d71 (1=1) (2=0), gen(smoke_08)
recode d71_11 (-9/-7=.) (1=1) (2=0) (8/9=.), gen(smoke_11)
recode d71_14 (1=1) (2=0) (9=.), gen(smoke_14)
recode d71_18 (1=1) (2=0) (9=.), gen(smoke_18)
label define smoke_lbl 0 "否" 1 "是"
label values smoke_08 smoke_11 smoke_14 smoke_18 smoke_lbl

*目前是否饮酒
recode d81 (1=1) (2=0), gen(drink_08)
recode d81_11 (-9/-7=.) (1=1) (2=0) (8/9=.), gen(drink_11)
recode d81_14 (1=1) (2=0) (8/9=.), gen(drink_14)
recode d81_18 (1=1) (2=0) (9=.), gen(drink_18)
label define drink_lbl 0 "否" 1 "是"
label values drink_08 drink_11 drink_14 drink_18 drink_lbl

*目前是否锻炼
recode d91 (1=1) (2=0) (8=.), gen(exercise_08)
recode d91_11 (9/-7=.) (1=1) (2=0) (8/9=.), gen(exercise_11)
recode d91_14 (1=1) (2=0) (8/9=.), gen(exercise_14)
recode d91_18 (1=1) (2=0) (8=.), gen(exercise_18)
label define exercise_lbl 0 "否" 1 "是"
label values exercise_08 exercise_11 exercise_14 exercise_18 exercise_lbl


*健康状况变量
*self_reported_health
recode b12 (1=4) (2=3) (3=2) (4=1) (5=0) (8/9=.), gen(self_reported_health_08) //反向计分处理,0-4,very bad-very good
recode b12_11 (9/-7=.) (1=4) (2=3) (3=2) (4=1) (5=0) (8/9=.), gen(self_reported_health_11) //反向计分处理,0-4,very bad-very good
recode b12_14 (1=4) (2=3) (3=2) (4=1) (5=0) (8/9=.),gen(self_reported_health_14) //反向计分处理,0-4,very bad-very good
recode b12_18 (1=4) (2=3) (3=2) (4=1) (5=0) (8/9=.),gen(self_reported_health_18) //反向计分处理,0-4,very bad-very good
label define self_reported_health_lbl 0 "very_bad" 1 "bad" 2 "fair" 3 "good" 4 "very_good"
label values self_reported_health_08 self_reported_health_11 self_reported_health_14 self_reported_health_18 self_reported_health_lbl


*抑郁量表得分-only-18年
*简版流调中心抑郁量表(CESD-10)10个CESD项目,每个项目的分值范围是0到3分,将每个CESD项日的分值相加,得到总得分
foreach var in b31_18 b32_18 b33_18 b34_18 b36_18 b38_18 b39_18 {
    recode `var' (1=3) (2=2) (3=2) (4=1) (5=0) (8=.), gen(new_`var')
}   //b31_18 b32_18 b33_18 b34_18 b36_18 b38_18 b39_18 反向计分处理

foreach var in b35_18 b37_18 b310a_18 {
    recode `var' (1=0) (2/3=1) (4=2) (5=3) (8/9=.), gen(new_`var')
}   //b35_18 b37_18 b310a_18 不用反向计分处即

egen cesd=rowtotal(new_b31_18 new_b32_18 new_b33_18 new_b34_18 new_b35_18 new_b36_18 new_b37_18 new_b38_18 new_b39_18 new_b310a_18 ),mi
recode cesd (0/15=0) (16/30=1), gen(cesd_d) //常见的cutoff值是 16分,其cutoff可能会根据特定研究或临床环境而有所不同如10,20
label define cesd_lbl 0 "无抑郁症状" 1 "有抑郁症状"
label values cesd_d cesd_lbl


*日常生活活动能力
*ADL包含bathing, dressing, eating, indoor transferring, toileting, and continence，每个项目的分值范围是0到2分，将每个ADL项目的分值相加，得到总得分
foreach var in e1 e2 e3 e4 e5 e6 {
    recode `var' (1=0) (2=1) (3=2) (8/9=.), gen(new_`var')
}

foreach var in e1_11 e2_11 e3_11 e4_11 e5_11 e6_11 {
    recode `var' (-9/-7=.) (1=0) (2=1) (3=2) (8/9=.), gen(new_`var')
}

foreach var in e1_14 e2_14 e3_14 e4_14 e5_14 e6_14 {
    recode `var' (1=0) (2=1) (3=2) (8/9=.), gen(new_`var')
}

foreach var in e1_18 e2_18 e3_18 e4_18 e5_18 e6_18 {
    recode `var' (1=0) (2=1) (3=2) (8/9=.), gen(new_`var')
}

egen adl_08=rowtotal(new_e1 new_e2 new_e3 new_e4 new_e5 new_e6),mi
egen adl_11=rowtotal(new_e1_11 new_e2_11 new_e3_11 new_e4_11 new_e5_11 new_e6_11),mi
egen adl_14=rowtotal(new_e1_14 new_e2_14 new_e3_14 new_e4_14 new_e5_14 new_e6_14),mi
egen adl_18=rowtotal(new_e1_18 new_e2_18 new_e3_18 new_e4_18 new_e5_18 new_e6_18),mi
recode adl_08 (1/12=1), gen(adl_d_08)
recode adl_11 (1/12=1), gen(adl_d_11)
recode adl_14 (1/12=1), gen(adl_d_14)
recode adl_18 (1/12=1), gen(adl_d_18)
label define adl_lbl 0 "无损失" 1 "有损失"
label values adl_d_08 adl_d_11 adl_d_14 adl_d_18 adl_lbl


*认知功能
*简易精神状态评估量表 (Mini-mental State Examination, MMSE) 中文版，该量表包括一般能力(12分)、反应能力(3分)、注意力与计算力(6分)、回忆力(3分)、语言理解与自我协调能力(6分)5个部分24个问题,总分30分，分数越高，表示认知功能水平越高
foreach var in c11 c12 c13 c14 c15 c21a c21b c21c c31a c31b c31c c31d c31e c32 c41a c41b c41c c51a c51b c52 c53a c53b c53c {
    recode `var' (8/9=.), gen(new_`var')
}

foreach var in c11_11 c12_11 c13_11 c14_11 c15_11 c21a_11 c21b_11 c21c_11 c31a_11 c31b_11 c31c_11 c31d_11 c31e_11 c32_11 c41a_11 c41b_11 c41c_11 c51a_11 c51b_11 c52_11 c53a_11 c53b_11 c53c_11 {
    recode `var' (9/-7=.) (8/9=.), gen(new_`var')
}

foreach var in c11_14 c12_14 c13_14 c14_14 c15_14 c21a_14 c21b_14 c21c_14 c31a_14 c31b_14 c31c_14 c31d_14 c31e_14 c32_14 c41a_14 c41b_14 c41c_14 c51a_14 c51b_14 c52_14 c53a_14 c53b_14 c53c_14 {
    recode `var' (8/9=.), gen(new_`var')
}

foreach var in c11_18 c12_18 c13_18 c14_18 c15_18 c21a_18 c21b_18 c21c_18 c31a_18 c31b_18 c31c_18 c31d_18 c31e_18 c32_18 c41a_18 c41b_18 c41c_18 c51a_18 c51b_18 c52_18 c53a_18 c53b_18 c53c_18 {
    recode `var' (8/9=.), gen(new_`var')
}

recode c16 (1/25=1) (88/99=.), gen(new_c16)
recode c16_11 (9/-7=.) (1/81=1) (91/96=1) (88=.) (99=.), gen(new_c16_11)
recode c16_14 (1/85=1) (90=1) (88=.) (99=.), gen(new_c16_14)
recode c16_18 (1/55=1) (88/99=.), gen(new_c16_18)


egen general_cognitive_08 = rowtotal(new_c11 new_c12 new_c13 new_c14 new_c15 new_c16), mi
replace general_cognitive_08 = general_cognitive_08*2
egen reaction_08 = rowtotal(new_c21a new_c21b new_c21c), mi
egen attention_calculation_08 = rowtotal(new_c31a new_c31b new_c31c new_c31d new_c31e new_c32), mi
egen memory_08 = rowtotal(new_c41a new_c41b new_c41c), mi
egen language_selfcoordination_08 = rowtotal(new_c51a new_c51b new_c52 new_c53a new_c53b new_c53c), mi
egen mmse_08 = rowtotal(general_cognitive_08 reaction_08 attention_calculation_08 memory_08 language_selfcoordination_08), mi

egen general_cognitive_11 = rowtotal(new_c11_11 new_c12_11 new_c13_11 new_c14_11 new_c15_11 new_c16_11), mi
replace general_cognitive_11 = general_cognitive_11*2
egen reaction_11 = rowtotal(new_c21a_11 new_c21b_11 new_c21c_11), mi
egen attention_calculation_11 = rowtotal(new_c31a_11 new_c31b_11 new_c31c_11 new_c31d_11 new_c31e_11 new_c32_11), mi
egen memory_11 = rowtotal(new_c41a_11 new_c41b_11 new_c41c_11), mi
egen language_selfcoordination_11 = rowtotal(new_c51a_11 new_c51b_11 new_c52_11 new_c53a_11 new_c53b_11 new_c53c_11), mi
egen mmse_11 = rowtotal(general_cognitive_11 reaction_11 attention_calculation_11 memory_11 language_selfcoordination_11), mi

egen general_cognitive_14 = rowtotal(new_c11_14 new_c12_14 new_c13_14 new_c14_14 new_c15_14 new_c16_14), mi
replace general_cognitive_14 = general_cognitive_14*2
egen reaction_14 = rowtotal(new_c21a_14 new_c21b_14 new_c21c_14), mi
egen attention_calculation_14 = rowtotal(new_c31a_14 new_c31b_14 new_c31c_14 new_c31d_14 new_c31e_14 new_c32_14), mi
egen memory_14 = rowtotal(new_c41a_14 new_c41b_14 new_c41c_14), mi
egen language_selfcoordination_14 = rowtotal(new_c51a_14 new_c51b_14 new_c52_14 new_c53a_14 new_c53b_14 new_c53c_14), mi
egen mmse_14 = rowtotal(general_cognitive_14 reaction_14 attention_calculation_14 memory_14 language_selfcoordination_14), mi

egen general_cognitive_18 = rowtotal(new_c11_18 new_c12_18 new_c13_18 new_c14_18 new_c15_18 new_c16_18), mi
replace general_cognitive_18 = general_cognitive_18*2
egen reaction_18 = rowtotal(new_c21a_18 new_c21b_18 new_c21c_18), mi
egen attention_calculation_18 = rowtotal(new_c31a_18 new_c31b_18 new_c31c_18 new_c31d_18 new_c31e_18 new_c32_18), mi
egen memory_18 = rowtotal(new_c41a_18 new_c41b_18 new_c41c_18), mi
egen language_selfcoordination_18 = rowtotal(new_c51a_18 new_c51b_18 new_c52_18 new_c53a_18 new_c53b_18 new_c53c_18), mi
egen mmse_18 = rowtotal(general_cognitive_18 reaction_18 attention_calculation_18 memory_18 language_selfcoordination_18), mi


recode mmse_08 (0/23=0) (24/30=1), gen(mmse_d_08)
recode mmse_11 (0/23=0) (24/30=1), gen(mmse_d_11)
recode mmse_14 (0/23=0) (24/30=1), gen(mmse_d_14)
recode mmse_18 (0/23=0) (24/30=1), gen(mmse_d_18)

label define mmse_lbl 0 "有认知功能障碍" 1 "认知功能正常"
label values mmse_d_08 mmse_d_11 mmse_d_14 mmse_d_18 mmse_lbl


******变量标签******
label var trueage_08 "年龄_08"
label var trueage_11 "年龄_11"
label var trueage_14 "年龄_14"
label var trueage_18 "年龄_18"
label var sex "性别"
label var ethnic "民族"
label var birth_place "出生地"
label var edu_08 "教育年限_08"
// label var edu_11 "教育年限_11"
label var edu_14 "教育年限_14"
label var edu_18 "教育年限_18"
label var marital_08 "婚姻状况_08"
label var marital_11 "婚姻状况_11"
label var marital_14 "婚姻状况_14"
label var marital_18 "婚姻状况_18"
label var econ_state_08 "生活是否富裕_08"
label var econ_state_11 "生活是否富裕_11"
label var econ_state_14 "生活是否富裕_14"
label var econ_state_18 "生活是否富裕_18"
label var income_08 "上一年家庭收入_08"
label var income_11 "上一年家庭收入_11"
label var income_14 "上一年家庭收入_14"
label var income_18 "上一年家庭收入_18"
label var basic_medical_insur_08 "是否有医保_08"
label var uebmi_11 "是否有城职保_11"
label var urbmi_11 "是否有城居保_11"
label var nrcm_11 "是否有新农合_11"
label var uebmi_14 "是否有城职保_14"
label var urbmi_14 "是否有城居保_14"
label var nrcm_14 "是否有新农合_14"
label var uebmi_11 "是否有城职保/城居保_18"
label var nrcm_11 "是否有新农合_18"
label var co_residence_08 "居住状态_08"
label var co_residence_11 "居住状态_11"
label var co_residence_14 "居住状态_14"
label var co_residence_18 "居住状态_18"
label var children_number_08 "子女数量_08"
label var children_number_11 "子女数量_11"
label var children_number_14 "子女数量_14"
label var children_number_18 "子女数量_18"

label var smoke_08 "是否吸烟_08"
label var smoke_11 "是否吸烟_11"
label var smoke_14 "是否吸烟_14"
label var smoke_18 "是否吸烟_18"
label var drink_08 "是否饮酒_08"
label var drink_11 "是否饮酒_11"
label var drink_14 "是否饮酒_14"
label var drink_18 "是否饮酒_18"
label var exercise_08 "是否锻炼_08"
label var exercise_11 "是否锻炼_11"
label var exercise_14 "是否锻炼_14"
label var exercise_18 "是否锻炼_18"
label var cesd_d "是否抑郁_18"
label var cesd "抑郁量表_18"
label var adl_08 "ADL_08"
label var adl_11 "ADL_11"
label var adl_14 "ADL_14"
label var adl_18 "ADL_18"
label var adl_d_08 "ADL损失_08"
label var adl_d_11 "ADL损失_11"
label var adl_d_14 "ADL损失_14"
label var adl_d_18 "ADL损失_18"
label var mmse_08 "认知能力_08"
label var mmse_11 "认知能力_11"
label var mmse_14 "认知能力_14"
label var mmse_18 "认知能力_18"
label var mmse_d_08 "认知功能障碍_08"
label var mmse_d_11 "认知功能障碍_11"
label var mmse_d_14 "认知功能障碍_14"
label var mmse_d_18 "认知功能障碍_18"

keep trueage_08 trueage_11 trueage_14 trueage_18 sex ethnic birth_place edu_08 ///
    edu_14 edu_18 marital_08 marital_11 marital_14 marital_18 econ_state_08 ///
    econ_state_11 econ_state_14 econ_state_18 income_08 income_11 income_14 income_18 ///
    basic_medical_insur_08 uebmi_11 urbmi_11 nrcm_11 uebmi_14 urbmi_14 nrcm_14 ///
    uebmi_18 nrcm_18 co_residence_08 co_residence_11 co_residence_14 co_residence_18 ///
    children_number_08 children_number_11 children_number_14 children_number_18 ///
    smoke_08 smoke_11 smoke_14 smoke_18 drink_08 drink_11 drink_14 drink_18 exercise_08 ///
    exercise_11 exercise_14 exercise_18 cesd_d cesd adl_d_08 adl_08 adl_11 adl_14 adl_18 adl_d_11 adl_d_14 adl_d_18 ///
    mmse_08 mmse_11 mmse_14 mmse_18 mmse_d_08 mmse_d_11 mmse_d_14 mmse_d_18 yearin ///
    dth08_11 dth11_14 dth14_18 id


save "$working_data/clhls08_18.dta", replace