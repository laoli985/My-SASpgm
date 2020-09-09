
/****中国人群健康与养老数据库（charls）分析程序******/
*====================================================
/**数据集说明**/

**
1.charls.merged:原始，未排除基线卒中、心脏疾病患者的数据库，同时包含未患有高血压的群体
2.charls.hypertensives:在原始数据集基础上，只纳入了高血压患者的数据库
3.charls.hypertensive_clean1:剔除11年基线患有心脏疾病以及脑卒中的高血压患者后的数据集，charls.hypertensive_clean1，
用于15年wave4随访时的stroke_incidence和heart_incidence的分析
4.charls.hypertensive_clean2:在剔除11年基线患有心脏疾病以及脑卒中的高血压患者基础上，
进一步剔除15年第四波随访，新出现的卒中和心脏疾病患者的数据集，charls.hypertensive_clean2,用于15年wave4随访时的riskscore_wu和riskscore_frs的分析;

options validvarname=any;
options mstored sasmstore=macr;

/**重要变量说明**/
**（二分类变量采取0、1赋值）
1.bpdrug_11:基线使用药物手段控制血压
2.bpwestdrug_11:基线使用降压药控制血压,cholwestdrug_11:基线使用降脂药物控制血脂，gluwestdrug_11:基线使用降糖药物控制血糖
3.riskscore_11_wu\riskscore_15_wu:基线和15年随访时，10年心血管风险得分（师门文献计算得到）
4.riskscore_11_frs\riskscore_15_frs:基线和15年随访时，10年心血管风险得分（frammingham心血管风险得分计算得到）
5.riskstrata_11_wu,riskstrata_11_frs:基线的10年心血管风险得分分层
6.heart_incidence/stroke_incidence:截止到15年随访时，心脏疾病和脑卒中的累积发病情况
7.r1sport:基线时候是否每周至少有一次持续十分钟以上的体力活动
8.intervention:基线时候的干预状态，包括体育锻炼、药物治疗、体育锻炼＋药物治疗以及无任何干预
9.hypertension:基线时候是否患有高血压，血压诊断标准包括基线血压水平、使用降压药以及医生确诊的高血压
10.BPstatus:基线时候血压水平，分为high (systolic blood pressure 
[SBP] ≥140 mm Hg or diastolic blood pressure [DBP] ≥90 mm Hg) and normal (SBP <140 mm Hg and DBP <90 mm Hg) 
blood pressure.
11.r1cesd10:基线抑郁得分情况
12.r1tr20-r4tr20:波次1-波次4的记忆力部分得分
13.da049_11,da050_11:基线的夜晚睡眠时长以及午睡时长
14.de002_11:基线时候，患者自我评价是否有睡眠方面的困难，包括入睡困难、早醒、以及中间醒来
**;


%varinfo(charls.hypertensive_clean,C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）,数据集变量词典_hypertensive_clean,xlsx)


/**简单描述性分析**/


**基线特征表直接使用宏程序ggBaseline中完成绘制，下面的步骤是为了计算受访者家庭总财富值和过去一年总收入的分位数，将其转换为分类变量**;

proc means data=charls.hypertensives min max p25 p50 p75 ;var hh1atotb hh1itot da049_11 da050_11;run;

proc univariate data=charls.hypertensives; var da049_11 da050_11;histogram da049_11 da050_11/normal;run;

proc means data=charls.hypertensive_clean1 min max p25 p50 p75 p95;var hh1atotb hh1itot;run;

proc means data=charls.hypertensive_clean2 min max p25 p50 p75 p95;var hh1atotb hh1itot;run;

proc means data=charls.hypertensive_clean2 min max p25 p50 p75 p95;var r1agey;run;
proc sgplot data=charls.hypertensive_clean2;histogram r1agey;run;

/**数据集编码**/



data test;set sashelp.class;number=_n_;run;
proc univariate data=test;var number;run;


data charls.merged;set charls.merged;
 length r1agecat $ 12;
 length hypertension $ 12;
 length BPstatus_11 $ 12;
 length night_11 $ 12;
 length ID_new $ 12;*因为旧的ID部分不识别，创建新的ID;
 number=_n_;
 ID_new=input(number,12.);
 if da014s2_11='2 Taking Western morden medicine' then gluwestdrug_11=1;
 else gluwestdrug_11=0;
 if da010_2_s2_11='2' then cholwestdrug_11=1;
 else cholwestdrug_11=0;
 **2019.11.26增加降糖药和降脂药编码;
 if 30<=r1agey<=39 then r1agecat='30-40';
 else if 40<=r1agey<=49 then r1agecat='40-50';
 else if 50<=r1agey<=59 then r1agecat='50-60';
 else if 60<=r1agey<=69 then r1agecat='60-70';
 else if 70<=r1agey then r1agecat='70+';
 if highbp_11=1|hypertension_11=1|bpdrug_11=1 then hypertension='With Hypertension';
 else if highbp_11=0 & hypertension_11=0 & bpdrug_11=0 then hypertension='Without Hypertension';
 if sbp_11>= 140 | dbp_11 >=90 then BPstatus_11='High BP';
 else if sbp_11<140 & dbp_11<90 then BPstatus_11='Normal BP';
 if 0<da049_11<5 then night_11='< 5h';
 else if 5<=da049_11<6 then night_11='5-6h';
 else if 6<=da049_11<7 then night_11='6-7h';
 else if 7<=da049_11<8 then night_11='7-8h';
 else if 8<=da049_11 then night_11='>= 8h';
 if hh1atotb<=14050 then total_wealth=1;
else if 14050<hh1atotb<54138 then total_wealth=2;
else if 54138<=hh1atotb<=128375 then total_wealth=3;
else if 128375<hh1atotb then total_wealth=4;
if hh1itot<=3400 then total_income=1;
else if 3400<hh1itot<15680 then total_income=2;
else if 15680<=hh1itot<=37690 then total_income=3;
else if 37690<hh1itot then total_income=4;
 run;
 proc contents data=charls.merged;run;




 data charls.hypertensives;set charls.hypertensives;
 length r1agecat $ 12;
 length hypertension $ 12;
 length BPstatus_11 $ 12;
 length night_11 $ 12;
  length ID_new $ 12;*因为旧的ID部分不识别，创建新的ID;
 number=_n_;
 ID_new=input(number,12.);
  if da014s2_11='2 Taking Western morden medicine' then gluwestdrug_11=1;
 else gluwestdrug_11=0;
 if da010_2_s2_11='2' then cholwestdrug_11=1;
 else cholwestdrug_11=0;
 if 30<=r1agey<=39 then r1agecat='30-40';
 else if 40<=r1agey<=49 then r1agecat='40-50';
 else if 50<=r1agey<=59 then r1agecat='50-60';
 else if 60<=r1agey<=69 then r1agecat='60-70';
 else if 70<=r1agey then r1agecat='70+';
 if highbp_11=1|hypertension_11=1|bpdrug_11=1 then hypertension='With Hypertension';
 else if highbp_11=0 & hypertension_11=0 & bpdrug_11=0 then hypertension='Without Hypertension';
 if sbp_11>= 140 | dbp_11 >=90 then BPstatus_11='High BP';
 else if sbp_11<140 & dbp_11<90 then BPstatus_11='Normal BP';
 if 0<da049_11<5 then night_11='< 5h';
 else if 5<=da049_11<6 then night_11='5-6h';
 else if 6<=da049_11<7 then night_11='6-7h';
 else if 7<=da049_11<8 then night_11='7-8h';
 else if 8<=da049_11 then night_11='>= 8h';
 run;

 data charls.hypertensive_clean1;set charls.hypertensive_clean1;
  length r1agecat $ 12;
 length hypertension $ 12;
 length BPstatus_11 $ 12;
 length night_11 $ 12;
  length ID_new $ 12;*因为旧的ID部分不识别，创建新的ID;
 number=_n_;
 ID_new=input(number,12.);
  if da014s2_11='2 Taking Western morden medicine' then gluwestdrug_11=1;
 else gluwestdrug_11=0;
 if da010_2_s2_11='2' then cholwestdrug_11=1;
 else cholwestdrug_11=0;
 if 30<=r1agey<=39 then r1agecat='30-40';
 else if 40<=r1agey<=49 then r1agecat='40-50';
 else if 50<=r1agey<=59 then r1agecat='50-60';
 else if 60<=r1agey<=69 then r1agecat='60-70';
 else if 70<=r1agey then r1agecat='70+';
 if highbp_11=1|hypertension_11=1|bpdrug_11=1 then hypertension='With Hypertension';
 else if highbp_11=0 & hypertension_11=0 & bpdrug_11=0 then hypertension='Without Hypertension';
 if sbp_11>= 140 | dbp_11 >=90 then BPstatus_11='High BP';
 else if sbp_11<140 & dbp_11<90 then BPstatus_11='Normal BP';
 if 0<da049_11<5 then night_11='< 5h';
 else if 5<=da049_11<6 then night_11='5-6h';
 else if 6<=da049_11<7 then night_11='6-7h';
 else if 7<=da049_11<8 then night_11='7-8h';
 else if 8<=da049_11 then night_11='>= 8h';
 run;

data charls.hypertensive_clean2;set charls.hypertensive_clean2;
  length r1agecat $ 12;
 length hypertension $ 12;
 length BPstatus_11 $ 12;
 length night_11 $ 12;
  length ID_new $ 12;*因为旧的ID部分不识别，创建新的ID;
 number=_n_;
 ID_new=input(number,12.);
  if da014s2_11='2 Taking Western morden medicine' then gluwestdrug_11=1;
 else gluwestdrug_11=0;
 if da010_2_s2_11='2' then cholwestdrug_11=1;
 else cholwestdrug_11=0;
 if 30<=r1agey<=39 then r1agecat='30-40';
 else if 40<=r1agey<=49 then r1agecat='40-50';
 else if 50<=r1agey<=59 then r1agecat='50-60';
 else if 60<=r1agey<=69 then r1agecat='60-70';
 else if 70<=r1agey then r1agecat='70+';
 if highbp_11=1|hypertension_11=1|bpdrug_11=1 then hypertension='With Hypertension';
 else if highbp_11=0 & hypertension_11=0 & bpdrug_11=0 then hypertension='Without Hypertension';
 if sbp_11>= 140 | dbp_11 >=90 then BPstatus_11='High BP';
 else if sbp_11<140 & dbp_11<90 then BPstatus_11='Normal BP';
 if 0<da049_11<5 then night_11='< 5h';
 else if 5<=da049_11<6 then night_11='5-6h';
 else if 6<=da049_11<7 then night_11='6-7h';
 else if 7<=da049_11<8 then night_11='7-8h';
 else if 8<=da049_11 then night_11='>= 8h';
 run;














data charls.hypertensives;set charls.hypertensives;
length intervention $ 12;
if r1sport=1 & bpwestdrug_11=1 then intervention='Drug & Exercise';
else if r1sport=0 & bpwestdrug_11=1 then  intervention='Drug';
else if r1sport=1 & bpwestdrug_11=0 then  intervention='Exercise';
else if r1sport=0 & bpwestdrug_11=0 then  intervention='None';
run;


data charls.hypertensive_clean1;set charls.hypertensive_clean1;
length intervention $ 12;
if r1sport=1 & bpwestdrug_11=1 then intervention='Drug & Exercise';
else if r1sport=0 & bpwestdrug_11=1 then  intervention='Drug';
else if r1sport=1 & bpwestdrug_11=0 then  intervention='Exercise';
else if r1sport=0 & bpwestdrug_11=0 then  intervention='None';
run;

data charls.hypertensive_clean2;set charls.hypertensive_clean2;
length intervention $ 12;
if r1sport=1 & bpwestdrug_11=1 then intervention='Drug & Exercise';
else if r1sport=0 & bpwestdrug_11=1 then  intervention='Drug';
else if r1sport=1 & bpwestdrug_11=0 then  intervention='Exercise';
else if r1sport=0 & bpwestdrug_11=0 then  intervention='None';
run;






proc freq data=charls.hypertensive_clean1;table intervention r1sport r1vgact_c r1mdact_c r1ltact_c;run;




%ggBaseline(
data=charls.hypertensives,
var=r1agey|TTEST|Age(years)\
r1bmi|TTEST|BMI \
heart_incidence|CHISQ|Newly diagnosis of CHD\
sbp_11|TTEST|Systolic Blood Pressure,
grp=bpwestdrug_11,
grplabel=Not Using drugs|Using drugs,
stdiff=Y,
pctype=col,
filetype=RTF,
exmisspct=Y,
showP=Y,
file=C:\Users\cheng\Desktop\Table1,
title=%str(Table I. Characteristics of study population by 
medication use.)
)













*输出数据集的编码书;
%MakeCodeBook(charls,hypertensives,C:\Users\cheng\Desktop\课题\中国人群健康养老数据库（charls）)




/***数据集降维分析***/

*1.主成分降维;


**提取医疗开支（medical expenditure）部分的变量，命名为医疗开支指数;

proc univariate data=charls.hypertensive_clean1;var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;run;
proc univariate data=charls.hypertensive_clean2;var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;run;
*四个变量分别代表过去一年住院花费金额（自费和总金额）和一个月内就医花费（自费和总金额）; 

*对4个变量提取主成分，命名为医疗开支指数;

proc princomp data=charls.hypertensive_clean1 out=charls.hypertensive_clean1_comp std  prefix=medical_exp noprint;
var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;
run;**结果可知前两个主成分已经解释了超过80%的方差，因此以前两个主成分作为后续的协变量纳入倾向性得分的计算模型,即medical_exp1,medical_exp2;


proc princomp data=charls.hypertensive_clean2 out=charls.hypertensive_clean2_comp std prefix=medical_exp noprint;
var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;
run;**结果可知前两个主成分已经解释了超过80%的方差，因此以前两个主成分作为后续的协变量纳入倾向性得分的计算模型,即medical_exp1,medical_exp2;






**提取医疗服务利用（medical care utilization）部分变量，命名为医疗服务利用指数;
proc univariate data=charls.hypertensive_clean1;var r1hsptim1y r1hspnite r1doctim1m;title 'charls.hypertensive_clean1 descriptive';run;
proc univariate data=charls.hypertensive_clean2;var r1hsptim1y r1hspnite r1doctim1m;title 'charls.hypertensive_clean2 descriptive';run;
**3个变量分别代表过去一年住院次数、最近一次住院天数、过去一个月门诊看医生的次数;

*对3个变量提取主成分，命名为医疗服务指数;
proc princomp data=charls.hypertensive_clean1_comp out=charls.hypertensive_clean1_comp std plot=all prefix=medical_use noprint;
var r1hsptim1y r1hspnite r1doctim1m;
run;*结果可知前两个主成分已经解释了超过80%的方差，因此以前两个主成分作为后续的协变量纳入倾向性得分的计算模型,即medical_use1,medical_use2;


proc princomp data=charls.hypertensive_clean2_comp out=charls.hypertensive_clean2_comp std plot=all prefix=medical_use noprint;
var r1hsptim1y r1hspnite r1doctim1m;
run;*结果可知前两个主成分已经解释了超过80%的方差，因此以前两个主成分作为后续的协变量纳入倾向性得分的计算模型,即medical_use1,medical_use2;
*同时输出计算主成分得分后的数据集，在R中完成倾向性得分匹配操作;
%dataexport(charls.hypertensive_clean1_comp,C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\官方合并的数据集,csv)
%dataexport(charls.hypertensive_clean2_comp,C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\官方合并的数据集,csv)

*2.倾向性得分计算降维;

   

proc logistic data=charls.hypertensive_clean1_comp;
    class ragender raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken  r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')= ragender raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi r1agey sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10;
	*新添加了腰围和C-反应蛋白协变量;
	*2019.11.18,将协变量r1sport重新替换为r1ltact_c;
	*2019.11.21,增加r1cesd10:基线抑郁得分情况;
	output out=charls.hypertensive_clean1_ps predicted=score;
run;



proc logistic data=charls.hypertensive_clean2_comp;
    class ragender raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken  r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')= ragender raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi r1agey sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10;
	*新添加了腰围和C-反应蛋白协变量;
	*2019.11.18,将协变量r1sport重新替换为r1ltact_c;
	output out=charls.hypertensive_clean2_ps predicted=score;
run;



*3.亚组分析的倾向性得分计算，倾向性得分计算并未包括年龄r1agect、性别ragender、基线运动情况r1ltact_c以及居住地类型h1rural，因为这些因素将作为后续亚组划分因素;


proc logistic data=charls.hypertensive_clean1_comp;
    class  raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')= raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10;
	*新添加了腰围和C-反应蛋白协变量;
    *2019.11.21,增加r1cesd10:基线抑郁得分情况;
	output out=charls.hypertensive_clean1_ps_sub predicted=score;
run;


proc logistic data=charls.hypertensive_clean2_comp;
    class  raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')= raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10;
	*新添加了腰围和C-反应蛋白协变量;
	*2019.11.21,增加r1cesd10:基线抑郁得分情况;
	output out=charls.hypertensive_clean2_ps_sub predicted=score;
run;




**计算倾向性得分后的数据集为charls.hypertensive_clean1\2_ps,需要校正的协变量集中为score\score2;
proc univariate data=charls.hypertensive_clean1_comp;var score medical_use1;run;
proc univariate data=charls.hypertensive_clean2_ps;var score;run;

proc ttest data=charls.hypertensive_clean1_ps;class bpwestdrug_11;var score;run;
proc ttest data=charls.hypertensive_clean2_ps;class bpwestdrug_11;var score;run;



*==============================================================*
测试代码
**针对计算得到的倾向性得分进行匹配，对完成匹配的数据集进行后续分析**;


%gmatch (data=charls.hypertensive_clean1_ps,group=bpwestdrug_11,id=ID,mvars=score,wts=1,dmaxk=0.05,dist=1,ncontls=1,seedca=20191107,seedco=201911071,out=psmatch,
outnmca=unmatchca,outnmco=unmatchco,print=N);

proc sql;create table matched1 as 
   select __IDCA as ID ,__CA1 as PS 
from psmatch;
quit;

%datasetinfo(matched1)*ID变成了数值型变量，需要重新转换为字符型;
proc sql;create table matched2 as 
   select __IDCO as ID ,__CO1 as PS 
from psmatch;
quit;
data matched1;set matched1;bpwestdrug_11_new=1;run;
data matched2;set matched2;bpwestdrug_11_new=0;run;

%appendcom(charls.hypertensive_clean1_psmatched,matched1,matched2);
data charls.hypertensive_clean1_psmatched;set charls.hypertensive_clean1_psmatched;rename bpwestdrug_11_new=bpwestdrug_11;run;


proc freq data=charls.hypertensive_clean1_psmatched;table bpwestdrug_11;run;


%merge(charls.hypertensive_clean1_psmatched,charls.hypertensive_clean1_ps,ID,charls.hypertensive_clean1_matched,1);

proc freq data=charls.hypertensive_clean1_matched;table bpwestdrug_11;run;*匹配成功！！！！！！！！！！！！！，根据上述代码将PSmatch宏程序进行改良;


*改良后宏程序代码运行结果，输出数据集为test_psmatch;
%PSmatching(charls.hypertensive_clean1_comp,test_psmatch,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
bpwestdrug_11,1,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10,
ID,0.1,1,20191126,201911261)
*运行结果一致性测试;
proc freq data=charls.hypertensive_clean1_matched;table bpwestdrug_11;run;
proc freq data=test_psmatch;table bpwestdrug_11;run;
*完全一致！！！！??B！！！！！！！！！！！！;

proc sort data=charls.hypertensive_clean1_psmatched out=charls.hypertensive_clean1_psmatched_te nodupkey;by ID r1agey householdID r1bmi;run;


*
测试代码结束
*======================================================*


/**多因素logistic和多因素广义线性模型的相关性分析**/

/**针对二分类因变量，即发病情况，使用混合效应广义线性模型GLMM构建与分析**/
proc sort  data=charls.hypertensive_clean_ps;by riskstrata_11_wu;run;
proc freq data=charls.hypertensive_clean_ps;table (stroke_incidence heart_incidence)*bpwestdrug_11/chisq;run;


data charls.hypertensive_clean1_ps;set charls.hypertensive_clean1_ps;
   if stroke_incidence=1|heart_incidence=1 then cvd_events=1;
   else cvd_events=0;
run;
data charls.hypertensive_clean2_ps;set charls.hypertensive_clean1_ps;
   if stroke_incidence=1|heart_incidence=1 then cvd_events=1;
   else cvd_events=0;
run;

data charls.hypertensive_clean1_ps_sub;set charls.hypertensive_clean1_ps;
   if stroke_incidence=1|heart_incidence=1 then cvd_events=1;
   else cvd_events=0;
run;

data charls.hypertensive_clean2_ps_sub;set charls.hypertensive_clean2_ps;
   if stroke_incidence=1|heart_incidence=1 then cvd_events=1;
   else cvd_events=0;
run;



proc sort data=charls.hypertensive_clean1_ps;by riskstrata_11_wu;run;



ods rtf file='C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\不分层.rtf';
proc freq data=charls.hypertensive_clean1_ps;table bpwestdrug_11*stroke_incidence/relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_ps;table bpwestdrug_11*heart_incidence/relrisk;run;
proc freq data=charls.hypertensive_clean1_ps;table bpwestdrug_11*cvd_events/relrisk;run;
ods rtf close;



*=========================================================
*师门心血管风险分层分析*;

*主分析,直接校正倾向性得分*;

proc sort data=charls.hypertensive_clean1_ps;by riskstrata_11_wu;run;


ods rtf file='C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\分层检验_riskstrata_wu.rtf';
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_wu*bpwestdrug_11*stroke_incidence/cmh relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_wu*bpwestdrug_11*heart_incidence/cmh relrisk;run;
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_wu*bpwestdrug_11*cvd_events/cmh relrisk;run;
ods rtf close;



ods rtf file="C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\心血管事件多因素分析结果_strata_wu_校正PS.rtf" 
style=Journal3a;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1') ID  riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11  score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu （未涉及亚组）';
run;


/**尝试输出校正的RR
proc contents data=predict1;run;
data population;
  set charls.hypertensive_clean1_ps(in=a) charls.hypertensive_clean1_ps(in=b);
  if a then bpwestdrug_11=1;
  if b then bpwestdrug_11=0;
  run;

  proc means data=predict1 nway;
  class bpwestdrug_11;
  var score;
  output out=pop_risk mean=pop_risk;
  run;

  proc transpose data=pop_risk out=pop_risk prefix=bpwestdrug_;
  id bpwestdrug_11;
  var pop_risk;
  run;
  data pop_risk;set pop_risk;
  adjusted_RR=bpwestdrug_0/bpwestdrug_1;
  run;
  proc print data=pop_risk;
  var adjusted_RR;
  run;
/**发现即便输出校正的RR，也无法分层输出，同时无法获得置信区间，故放弃（2019.11.30）**/


/**再次尝试输出校正的RR**/

/**glimmix步**/
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps;
   class bpwestdrug_11(ref=first) ID riskstrata_11_wu(ref=last);
   model cvd_events(event='1')=bpwestdrug_11  score /solution dist=bin link=log;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   estimate 'Using Drug VS Not Using Drug' bpwestdrug_11 1/exp;
   title 'Results of heartdisease_incidence comparisons RR （未涉及亚组）';
run;

/**genmod步**/
proc genmod data=charls.hypertensive_clean1_ps descending;
    class bpwestdrug_11 riskstrata_11_wu/param=ref ref=first;
    model  cvd_events=bpwestdrug_11  score/dist=bin link=log;
    estimate "Results of heartdisease_incidence comparisons RR （未涉及亚组）" bpwestdrug_11 1/ exp;*当我们更改连接函数为log，且对比系数设置为1，并且加上exp选项，得到的就是therapy效应的RR估计结果;
    run;




/**2020.02.22发现glimmix过程步对于二分类响应变量分布，无法兼容link=log的选项，而genmod步虽然可以计算，但是只有exact选项才可以分层，再次放弃计算校正的RR**/


ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11  score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heartdisease_incidence comparisons OR by riskstrata_11_wu （未涉及亚组）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID  riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11  score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu （未涉及亚组）';
run;

ods rtf close;

*主分析，采取倾向性得分匹配后的数据集*;

%PSmatching(charls.hypertensive_clean1_comp,charls.hypertensive_clean1_psmatched,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
bpwestdrug_11,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10,
ID_new,0.05,1,20191126,201911261);
*匹配后;
proc freq data=charls.hypertensive_clean1_psmatched;table bpwestdrug_11;run;




/***旧代码,尝试对匹配完成的数据集进行去重，但是失败，因此决定将数据集导出，在stata中完成PSM过程
proc sort data =psmatched_pre out=nodups5 nodup;
    by ID;
run;

data tt;merge charls.hypertensive_clean1_comp(in=ds1) psmatched_pre(in=ds2);by ID;if ds2;run;

proc sql;
create table tt as 
select * from charls.hypertensive_clean1_comp a right join psmatched_pre b 
on a.ID=b.ID;
quit;

proc freq data=charls.hypertensive_clean1_psmatched;table bpwestdrug_11;run;


proc sort data=charls.hypertensive_clean1_psmatched;by ID;run;

data dups nodups;
set charls.hypertensive_clean1_psmatched;
by ID;
if first.ID and last.ID then output nodups;
else output dups;
run;


proc sort data =charls.hypertensive_clean1_psmatched out=nodups5 nodup;
    by  ragender;
run ;

proc freq data=NODUPS5;table ID;run;

proc sql;create table test as select distinct sbp_11 from charls.hypertensive_clean1_psmatched;quit;
***/

%PSmatching(charls.hypertensive_clean2_comp,charls.hypertensive_clean2_psmatched,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
bpwestdrug_11,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10,
ID_new,0.05,1,201911261,2019112612);

proc freq data=charls.hypertensive_clean2_psmatched;table bpwestdrug_11;run;
**匹配均衡性检验**;
%idcovariates(charls.hypertensive_clean2_psmatched,test_con,charls.hypertensive_clean2_psmatched,bpwestdrug_11,
medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10,
raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
bpwestdrug_11,C:\Users\cheng\Desktop)
**均衡性良好**;




data charls.hypertensive_clean1_psmatched;set charls.hypertensive_clean1_psmatched;
   if stroke_incidence=1|heart_incidence=1 then cvd_events=1;
   else cvd_events=0;
run;
data charls.hypertensive_clean2_psmatched;set charls.hypertensive_clean1_psmatched;
   if stroke_incidence=1|heart_incidence=1 then cvd_events=1;
   else cvd_events=0;
run;


ods rtf file='C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\分层检验_riskstrata_wu_PPSM.rtf';
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_wu*bpwestdrug_11*stroke_incidence/cmh relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_wu*bpwestdrug_11*heart_incidence/cmh relrisk;run;
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_wu*bpwestdrug_11*cvd_events/cmh relrisk;run;
ods rtf close;


proc sort data=charls.hypertensive_clean1_psmatched;by riskstrata_11_wu;run;

ods rtf file="C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\心血管事件多因素分析结果_strata_wu_匹配PS.rtf" 
style=Journal1a;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1') ID  riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu （未涉及亚组）';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heartdisease_incidence comparisons OR by riskstrata_11_wu （未涉及亚组）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1')  ID  riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu （未涉及亚组）';
run;

ods rtf close;








*亚组分析，年龄r1agect,性别ragender、运动情况r1sport为亚组因素，居住地类型为协变量*;

proc sort data=charls.hypertensive_clean1_ps_sub;by riskstrata_11_wu;run;
proc freq data=charls.hypertensive_clean1_ps_sub;table r1agecat ragender r1sport h1rural;run;


ods rtf file="C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\亚组分析结果\心血管事件多因素分析结果_strata_wu_sub.rtf";

**性别亚组分析**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') ragender(ref='1.male') ID  riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 score  ragender bpwestdrug_11*ragender/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu （单独纳入性别亚组）';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') ragender(ref='1.male')  ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 score   ragender bpwestdrug_11*ragender/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heart_incidence comparisons OR by riskstrata_11_wu （单独纳入性别亚组）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') ragender(ref='1.male') ID riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 score  ragender bpwestdrug_11*ragender/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu （单独纳入性别亚组）';
run;




**年龄亚组分析,模型未收敛**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1agecat(ref='30-40') ID riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 score r1agecat bpwestdrug_11*r1agecat/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu （单独纳入年龄亚组）';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1agecat ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 score r1agecat bpwestdrug_11*r1agecat/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heart_incidence comparisons OR by riskstrata_11_wu （单独纳入年龄亚组）';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1agecat(ref='70+') ID riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 score r1agecat bpwestdrug_11*r1agecat/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu （单独纳入年龄亚组）';
run;


**体育锻炼亚组分析**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1sport(ref='1') ID riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 score r1sport bpwestdrug_11*r1sport/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1sport/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu （单独纳入运动亚组）';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1sport(ref='1') ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 score r1sport bpwestdrug_11*r1sport/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1sport/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heart_incidence comparisons OR by riskstrata_11_wu （单独纳入运动亚组）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1sport(ref='1') ID riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 score r1sport bpwestdrug_11*r1sport/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1sport/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu （单独纳入运动亚组）';
run;


**居住地类型亚组分析**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') h1rural(ref='0.Urban Community') ID riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 score h1rural bpwestdrug_11*h1rural/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*h1rural/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu （单独纳入居住地类型亚组）';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') h1rural(ref='0.Urban Community') ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 score h1rural  bpwestdrug_11*h1rural/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*h1rural/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heart_incidence comparisons OR by riskstrata_11_wu （单独纳入居住地类型亚组）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') h1rural(ref='0.Urban Community') ID riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 score h1rural bpwestdrug_11*h1rural/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*h1rural/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu （单独纳入居住地类型亚组）';
run;

**睡眠时长亚组分析**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') night_11(ref='6-7h') ID  riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 night_11 score  bpwestdrug_11*night_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*night_11/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu （单独纳入睡眠时长亚组）';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') night_11(ref='6-7h') ID  riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 night_11 score  bpwestdrug_11*night_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*night_11/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu （单独纳入睡眠时长亚组）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') night_11(ref='6-7h') ID  riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 night_11 score  bpwestdrug_11*night_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*night_11/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu （单独纳入睡眠时长亚组）';
run;
ods rtf close;





*====================================================*;




*=========================================================
*FRS心血管风险分层分析*;
proc sort data=charls.hypertensive_clean1_ps;by riskstrata_11_frs;run;


/***主分析，校正PS得分****/;

ods rtf file='C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\分层检验_riskstrata_frs.rtf';
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_frs*bpwestdrug_11*stroke_incidence/cmh relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_frs*bpwestdrug_11*heart_incidence/cmh relrisk;run;
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_frs*bpwestdrug_11*cvd_events/cmh relrisk;run;
ods rtf close;


ods rtf file="C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件多因素分析结果_strata_frs_校正PS.rtf" style=Journal1a;
proc sort data=charls.hypertensive_clean1_ps;by riskstrata_11_frs;run;
/*重新修改ID位数为13位
data charls.hypertensive_clean1_ps;set charls.hypertensive_clean1_ps;
attrib ID length=$13;
run;
***/
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1') ID riskstrata_11_frs;
   model stroke_incidence(event='1')=bpwestdrug_11 score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_frs （未涉及亚组）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_frs;
   model heart_incidence(event='1')=bpwestdrug_11 score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of heartdisease_incidence comparisons OR by riskstrata_11_frs （未涉及亚组）';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_frs;
   model cvd_events(event='1')=bpwestdrug_11 score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_frs （未涉及亚组）';
run;
ods rtf close;


/***主分析，采取倾向性得分匹配后的数据集*/;

ods rtf file='C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\分层检验_riskstrata_frs_PPSM.rtf';
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_frs*bpwestdrug_11*stroke_incidence/cmh relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_frs*bpwestdrug_11*heart_incidence/cmh relrisk;run;
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_frs*bpwestdrug_11*cvd_events/cmh relrisk;run;
ods rtf close;



ods rtf file="C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\心血管事件多因素分析结果_strata_frs_匹配PS.rtf" style=Journal1a;
proc sort data=charls.hypertensive_clean1_psmatched;by riskstrata_11_frs;run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=rspl;*mmpl算法不收敛，换用rspl算法;
   class bpwestdrug_11(ref='1') ID riskstrata_11_frs;
   model stroke_incidence(event='1')=bpwestdrug_11 /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_frs （未涉及亚组）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_frs;
   model heart_incidence(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of heartdisease_incidence comparisons OR by riskstrata_11_frs （未涉及亚组）';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_frs;
   model cvd_events(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_frs （未涉及亚组）';
run;
ods rtf close;





/**针对连续性因变量，即15年的十年心血管风险得分，使用广义混合效应线性模型MIXED构建与分析,注意改变分布族函数**/


*=========================================================
*师门心血管风险分层分析*;

/**主分析**/
proc sort data=charls.hypertensive_clean2_ps;by riskstrata_11_wu;run;

ods rtf file="C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\十年心血管风险得分分析结果_strata_wu.rtf";

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean2_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_wu;
   model riskscore_15_wu=bpwestdrug_11 score/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff=control('1')  pdiff cl;
   by riskstrata_11_wu;
   title 'Results of 10-years risk score(wu) comparisons by riskstrata_11_wu';
run;
ods rtf close;


*============================*;



*=============================*
*FRS心血管风险分层分析*;
proc sort data=charls.hypertensive_clean2_ps;by riskstrata_11_frs;run;

/**主分析**/
ods rtf file="C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\心血管事件、心血管风险得分分析\十年心血管风险得分分析结果_strata_frs.rtf";
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean2_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_frs;
   model riskscore_15_frs=bpwestdrug_11  score/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff=control('1')  pdiff cl;
   by riskstrata_11_frs;
   title 'Results of 10-years risk score(frs) comparisons by riskstrata_11_frs';
run;
ods rtf close;

*======================*;




*==========================
认知得分分析;


/******全人群分析*************/
proc sort data=charls.merged;by r1agecat;run;
proc means p25 p50 p75 max;var hh1atotb hh1itot;run;
/*****数据集编码*****/
proc freq data=charls.merged;table da014s2_11 da010_2_s2_11 gluwestdrug_11 cholwestdrug_11;run;

data charls.merged;set charls.merged;
 length r1agecat $ 12;
 length hypertension $ 12;
 length BPstatus_11 $ 12;
 length night_11 $ 12;
 if da014s2_11='2 Taking Western morden medicine' then gluwestdrug_11=1;
 else gluwestdrug_11=0;
 if da010_2_s2_11='2' then cholwestdrug_11=1;
 else cholwestdrug_11=0;
 **2019.11.26增加降糖药和降脂药编码;
 if 30<=r1agey<=39 then r1agecat='30-40';
 else if 40<=r1agey<=49 then r1agecat='40-50';
 else if 50<=r1agey<=59 then r1agecat='50-60';
 else if 60<=r1agey<=69 then r1agecat='60-70';
 else if 70<=r1agey then r1agecat='70+';
 if highbp_11=1|hypertension_11=1|bpdrug_11=1 then hypertension='With Hypertension';
 else if highbp_11=0 & hypertension_11=0 & bpdrug_11=0 then hypertension='Without Hypertension';
 if sbp_11>= 140 | dbp_11 >=90 then BPstatus_11='High BP';
 else if sbp_11<140 & dbp_11<90 then BPstatus_11='Normal BP';
 if 0<da049_11<5 then night_11='< 5h';
 else if 5<=da049_11<6 then night_11='5-6h';
 else if 6<=da049_11<7 then night_11='6-7h';
 else if 7<=da049_11<8 then night_11='7-8h';
 else if 8<=da049_11 then night_11='>= 8h';
 if hh1atotb<=14050 then total_wealth=1;
else if 14050<hh1atotb<54138 then total_wealth=2;
else if 54138<=hh1atotb<=128375 then total_wealth=3;
else if 128375<hh1atotb then total_wealth=4;
if hh1itot<=3400 then total_income=1;
else if 3400<hh1itot<15680 then total_income=2;
else if 15680<=hh1itot<=37690 then total_income=3;
else if 37690<hh1itot then total_income=4;
 run;

 proc freq data=charls.merged;table night_11;run;


data charls.hypertensives;set charls.hypertensives;
 length r1agecat $ 12;
 length hypertension $ 12;
 length BPstatus_11 $ 12;
 length night_11 $ 12;
  if da014s2_11='2 Taking Western morden medicine' then gluwestdrug_11=1;
 else gluwestdrug_11=0;
 if da010_2_s2_11='2' then cholwestdrug_11=1;
 else cholwestdrug_11=0;
 if 30<=r1agey<=39 then r1agecat='30-40';
 else if 40<=r1agey<=49 then r1agecat='40-50';
 else if 50<=r1agey<=59 then r1agecat='50-60';
 else if 60<=r1agey<=69 then r1agecat='60-70';
 else if 70<=r1agey then r1agecat='70+';
 if highbp_11=1|hypertension_11=1|bpdrug_11=1 then hypertension='With Hypertension';
 else if highbp_11=0 & hypertension_11=0 & bpdrug_11=0 then hypertension='Without Hypertension';
 if sbp_11>= 140 | dbp_11 >=90 then BPstatus_11='High BP';
 else if sbp_11<140 & dbp_11<90 then BPstatus_11='Normal BP';
 if 0<da049_11<5 then night_11='< 5h';
 else if 5<=da049_11<6 then night_11='5-6h';
 else if 6<=da049_11<7 then night_11='6-7h';
 else if 7<=da049_11<8 then night_11='7-8h';
 else if 8<=da049_11 then night_11='>= 8h';
 run;

 data charls.hypertensive_clean1;set charls.hypertensive_clean1;
  length r1agecat $ 12;
 length hypertension $ 12;
 length BPstatus_11 $ 12;
 length night_11 $ 12;
  if da014s2_11='2 Taking Western morden medicine' then gluwestdrug_11=1;
 else gluwestdrug_11=0;
 if da010_2_s2_11='2' then cholwestdrug_11=1;
 else cholwestdrug_11=0;
 if 30<=r1agey<=39 then r1agecat='30-40';
 else if 40<=r1agey<=49 then r1agecat='40-50';
 else if 50<=r1agey<=59 then r1agecat='50-60';
 else if 60<=r1agey<=69 then r1agecat='60-70';
 else if 70<=r1agey then r1agecat='70+';
 if highbp_11=1|hypertension_11=1|bpdrug_11=1 then hypertension='With Hypertension';
 else if highbp_11=0 & hypertension_11=0 & bpdrug_11=0 then hypertension='Without Hypertension';
 if sbp_11>= 140 | dbp_11 >=90 then BPstatus_11='High BP';
 else if sbp_11<140 & dbp_11<90 then BPstatus_11='Normal BP';
 if 0<da049_11<5 then night_11='< 5h';
 else if 5<=da049_11<6 then night_11='5-6h';
 else if 6<=da049_11<7 then night_11='6-7h';
 else if 7<=da049_11<8 then night_11='7-8h';
 else if 8<=da049_11 then night_11='>= 8h';
 run;

data charls.hypertensive_clean2;set charls.hypertensive_clean2;
  length r1agecat $ 12;
 length hypertension $ 12;
 length BPstatus_11 $ 12;
 length night_11 $ 12;
  if da014s2_11='2 Taking Western morden medicine' then gluwestdrug_11=1;
 else gluwestdrug_11=0;
 if da010_2_s2_11='2' then cholwestdrug_11=1;
 else cholwestdrug_11=0;
 if 30<=r1agey<=39 then r1agecat='30-40';
 else if 40<=r1agey<=49 then r1agecat='40-50';
 else if 50<=r1agey<=59 then r1agecat='50-60';
 else if 60<=r1agey<=69 then r1agecat='60-70';
 else if 70<=r1agey then r1agecat='70+';
 if highbp_11=1|hypertension_11=1|bpdrug_11=1 then hypertension='With Hypertension';
 else if highbp_11=0 & hypertension_11=0 & bpdrug_11=0 then hypertension='Without Hypertension';
 if sbp_11>= 140 | dbp_11 >=90 then BPstatus_11='High BP';
 else if sbp_11<140 & dbp_11<90 then BPstatus_11='Normal BP';
 if 0<da049_11<5 then night_11='< 5h';
 else if 5<=da049_11<6 then night_11='5-6h';
 else if 6<=da049_11<7 then night_11='6-7h';
 else if 7<=da049_11<8 then night_11='7-8h';
 else if 8<=da049_11 then night_11='>= 8h';
 run;

/***除了常规的分析，还可将认知得分作为重复测量的指标，将数据集进行转置后再次进行分析***/
 data charls.merged_long;
 data charls.hypertensives_long;
 data charls.hypertensive_clean1_long;
 data charls.hypertensive_clean2_long;






 proc freq data=charls.merged;table hypertension BPstatus_11;run;

/***倾向性评分和主成分降维***/

proc princomp data=charls.merged out=charls.merged_comp std prefix=medical_exp noprint;
var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;
run;

proc princomp data=charls.merged_comp out=charls.merged_comp std plot=all prefix=medical_use noprint;
var r1hsptim1y r1hspnite r1doctim1m;
run;


proc logistic data=charls.merged_comp;
    class  raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken  r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')=  raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10/link=logit firth;
	*使用firth算法避免无穷大的极大似然比;
	*新添加了腰围和C-反应蛋白协变量;
	*2019.11.18,将协变量r1sport重新替换为r1ltact_c;
	*2019.11.21,增加r1cesd10:基线抑郁得分情况,剔除了年龄和性别以及基线收缩压，前两者将其作为单独的协变量去校正，后者作为分层变量去校正;
	output out=charls.merged_ps predicted=score;
run;

/***以基线血压分层**/
ods rtf file="C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\认知得分分析\15年随访认知得分分析结果_全人群.rtf";
proc sort data=charls.merged_ps;by BPstatus_11;run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat BPstatus_11 ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff  pdiff cl;
   lsmeans ragender/diff=control('1.male') pdiff cl;
   lsmeans r1agecat/diff=control('40-50');
   title 'Results of MMSE score comparisons （以血压分层、未添加年龄与用药交互项）';
   by BPstatus_11;
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat BPstatus_11 ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20 bpwestdrug_11*r1agecat/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/diff  pdiff cl;
   title 'Results of MMSE score comparisons （以血压分层、添加年龄与用药交互项）';
   by BPstatus_11;
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat BPstatus_11 ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20 bpwestdrug_11*ragender/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/diff  pdiff cl;
   title 'Results of MMSE score comparisons （以血压分层、添加性别与用药交互项）';
   by BPstatus_11;
run;



/***以基线是否患有高血压分层**/

proc sort data=charls.merged_ps;by hypertension;run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat hypertension ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff  pdiff cl;
   lsmeans ragender/diff=control('1.male') pdiff cl;
   lsmeans r1agecat/diff=control('40-50');
   title 'Results of MMSE score comparisons （以是否患有高血压分层、未添加年龄与用药交互项）';
   by hypertension;
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat hypertension ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20 bpwestdrug_11*r1agecat/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/diff  pdiff cl;
   title 'Results of MMSE score comparisons （以是否患有高血压分层、添加年龄与用药交互项）';
   by hypertension;
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat hypertension ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20 bpwestdrug_11*ragender/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/diff  pdiff cl;
   title 'Results of MMSE score comparisons （以是否患有高血压分层、添加性别与用药交互项）';
   by hypertension;
run;

ods rtf close;







/************高血压患者群体分析****************/

/***数据集降维***/
proc princomp data=charls.hypertensives out=charls.hypertensives_comp std  prefix=medical_exp;
var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;
run;


proc princomp data=charls.hypertensives_comp out=charls.hypertensives_comp std plot=all prefix=medical_use;
var r1hsptim1y r1hspnite r1doctim1m;
run;


proc logistic data=charls.hypertensives_comp;
    class  raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken  r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')=  raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi  sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11;
	*新添加了腰围和C-反应蛋白协变量;
	*2019.11.19,将协变量gender和r1agecat剥离出来，重新替换为r1ltact_c;
	output out=charls.hypertensives_ps predicted=score;
run;


/***认知得分分析***/
ods rtf file="C:\Users\cheng\Desktop\课题\公共数据库挖掘研究\中国人群健康养老数据库（charls）\分析结果\主分析结果\15年随访认知得分分析结果_高血压人群.rtf";

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensives_ps method=mmpl;
   class bpwestdrug_11(ref='0')  ID r1agecat ragender;
   model r4tr20=bpwestdrug_11 r1agecat ragender r1tr20/solution dist=gaussian link=identity ddfm=kr2;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff  pdiff cl;
   title 'Results of MMSE score comparisons in hypertensives（未添加年龄与用药交互项）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensives_ps method=mmpl;
   class bpwestdrug_11(ref='0') ID r1agecat ragender;
   model r4tr20=bpwestdrug_11 r1agecat ragender r1tr20 score/solution dist=gaussian link=identity ddfm=kr2;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff  pdiff cl;
   title 'Results of MMSE score comparisons in hypertensives（未添加年龄与用药交互项）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensives_ps method=mmpl;
   class bpwestdrug_11(ref='0')  ID r1agecat ragender;
   model r4tr20=bpwestdrug_11 r1agecat ragender  r1tr20  bpwestdrug_11*r1agecat/solution dist=gaussian link=identity ddfm=kr2;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/diff pdiff cl;
   title 'Results of MMSE score comparisons in hypertensives（添加年龄与用药交互项）';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensives_ps method=mmpl;
   class bpwestdrug_11(ref='0')  ID r1agecat ragender;
   model r4tr20=bpwestdrug_11 r1agecat ragender  r1tr20  bpwestdrug_11*r1agecat score/solution dist=gaussian link=identity ddfm=kr2;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/diff pdiff cl;
   title 'Results of MMSE score comparisons in hypertensives（添加年龄与用药交互项）';
run;
ods rtf close;



*=============================
















*======================
other codes;

proc mixed data=charls.hypertensive_clean2_ps;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_wu;
   model riskscore_15_wu=bpwestdrug_11 score/solution;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff cl;
   by riskstrata_11_wu;
run;

/**图形绘制**/




