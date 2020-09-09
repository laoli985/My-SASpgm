
/****�й���Ⱥ�������������ݿ⣨charls����������******/
*====================================================
/**���ݼ�˵��**/

**
1.charls.merged:ԭʼ��δ�ų��������С����༲�����ߵ����ݿ⣬ͬʱ����δ���и�Ѫѹ��Ⱥ��
2.charls.hypertensives:��ԭʼ���ݼ������ϣ�ֻ�����˸�Ѫѹ���ߵ����ݿ�
3.charls.hypertensive_clean1:�޳�11����߻������༲���Լ������еĸ�Ѫѹ���ߺ�����ݼ���charls.hypertensive_clean1��
����15��wave4���ʱ��stroke_incidence��heart_incidence�ķ���
4.charls.hypertensive_clean2:���޳�11����߻������༲���Լ������еĸ�Ѫѹ���߻����ϣ�
��һ���޳�15����Ĳ���ã��³��ֵ����к����༲�����ߵ����ݼ���charls.hypertensive_clean2,����15��wave4���ʱ��riskscore_wu��riskscore_frs�ķ���;

options validvarname=any;
options mstored sasmstore=macr;

/**��Ҫ����˵��**/
**�������������ȡ0��1��ֵ��
1.bpdrug_11:����ʹ��ҩ���ֶο���Ѫѹ
2.bpwestdrug_11:����ʹ�ý�ѹҩ����Ѫѹ,cholwestdrug_11:����ʹ�ý�֬ҩ�����Ѫ֬��gluwestdrug_11:����ʹ�ý���ҩ�����Ѫ��
3.riskscore_11_wu\riskscore_15_wu:���ߺ�15�����ʱ��10����Ѫ�ܷ��յ÷֣�ʦ�����׼���õ���
4.riskscore_11_frs\riskscore_15_frs:���ߺ�15�����ʱ��10����Ѫ�ܷ��յ÷֣�frammingham��Ѫ�ܷ��յ÷ּ���õ���
5.riskstrata_11_wu,riskstrata_11_frs:���ߵ�10����Ѫ�ܷ��յ÷ֲַ�
6.heart_incidence/stroke_incidence:��ֹ��15�����ʱ�����༲���������е��ۻ��������
7.r1sport:����ʱ���Ƿ�ÿ��������һ�γ���ʮ�������ϵ������
8.intervention:����ʱ��ĸ�Ԥ״̬����������������ҩ�����ơ�����������ҩ�������Լ����κθ�Ԥ
9.hypertension:����ʱ���Ƿ��и�Ѫѹ��Ѫѹ��ϱ�׼��������Ѫѹˮƽ��ʹ�ý�ѹҩ�Լ�ҽ��ȷ��ĸ�Ѫѹ
10.BPstatus:����ʱ��Ѫѹˮƽ����Ϊhigh (systolic blood pressure 
[SBP] ��140 mm Hg or diastolic blood pressure [DBP] ��90 mm Hg) and normal (SBP <140 mm Hg and DBP <90 mm Hg) 
blood pressure.
11.r1cesd10:���������÷����
12.r1tr20-r4tr20:����1-����4�ļ��������ֵ÷�
13.da049_11,da050_11:���ߵ�ҹ��˯��ʱ���Լ���˯ʱ��
14.de002_11:����ʱ�򣬻������������Ƿ���˯�߷�������ѣ�������˯���ѡ����ѡ��Լ��м�����
**;


%varinfo(charls.hypertensive_clean,C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��,���ݼ������ʵ�_hypertensive_clean,xlsx)


/**�������Է���**/


**����������ֱ��ʹ�ú����ggBaseline����ɻ��ƣ�����Ĳ�����Ϊ�˼����ܷ��߼�ͥ�ܲƸ�ֵ�͹�ȥһ��������ķ�λ��������ת��Ϊ�������**;

proc means data=charls.hypertensives min max p25 p50 p75 ;var hh1atotb hh1itot da049_11 da050_11;run;

proc univariate data=charls.hypertensives; var da049_11 da050_11;histogram da049_11 da050_11/normal;run;

proc means data=charls.hypertensive_clean1 min max p25 p50 p75 p95;var hh1atotb hh1itot;run;

proc means data=charls.hypertensive_clean2 min max p25 p50 p75 p95;var hh1atotb hh1itot;run;

proc means data=charls.hypertensive_clean2 min max p25 p50 p75 p95;var r1agey;run;
proc sgplot data=charls.hypertensive_clean2;histogram r1agey;run;

/**���ݼ�����**/



data test;set sashelp.class;number=_n_;run;
proc univariate data=test;var number;run;


data charls.merged;set charls.merged;
 length r1agecat $ 12;
 length hypertension $ 12;
 length BPstatus_11 $ 12;
 length night_11 $ 12;
 length ID_new $ 12;*��Ϊ�ɵ�ID���ֲ�ʶ�𣬴����µ�ID;
 number=_n_;
 ID_new=input(number,12.);
 if da014s2_11='2 Taking Western morden medicine' then gluwestdrug_11=1;
 else gluwestdrug_11=0;
 if da010_2_s2_11='2' then cholwestdrug_11=1;
 else cholwestdrug_11=0;
 **2019.11.26���ӽ���ҩ�ͽ�֬ҩ����;
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
  length ID_new $ 12;*��Ϊ�ɵ�ID���ֲ�ʶ�𣬴����µ�ID;
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
  length ID_new $ 12;*��Ϊ�ɵ�ID���ֲ�ʶ�𣬴����µ�ID;
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
  length ID_new $ 12;*��Ϊ�ɵ�ID���ֲ�ʶ�𣬴����µ�ID;
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













*������ݼ��ı�����;
%MakeCodeBook(charls,hypertensives,C:\Users\cheng\Desktop\����\�й���Ⱥ�����������ݿ⣨charls��)




/***���ݼ���ά����***/

*1.���ɷֽ�ά;


**��ȡҽ�ƿ�֧��medical expenditure�����ֵı���������Ϊҽ�ƿ�ָ֧��;

proc univariate data=charls.hypertensive_clean1;var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;run;
proc univariate data=charls.hypertensive_clean2;var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;run;
*�ĸ������ֱ�����ȥһ��סԺ���ѽ��ԷѺ��ܽ���һ�����ھ�ҽ���ѣ��ԷѺ��ܽ�; 

*��4��������ȡ���ɷ֣�����Ϊҽ�ƿ�ָ֧��;

proc princomp data=charls.hypertensive_clean1 out=charls.hypertensive_clean1_comp std  prefix=medical_exp noprint;
var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;
run;**�����֪ǰ�������ɷ��Ѿ������˳���80%�ķ�������ǰ�������ɷ���Ϊ������Э�������������Ե÷ֵļ���ģ��,��medical_exp1,medical_exp2;


proc princomp data=charls.hypertensive_clean2 out=charls.hypertensive_clean2_comp std prefix=medical_exp noprint;
var r1oophos1y r1tothos1y  r1oopdoc1m r1totdoc1m;
run;**�����֪ǰ�������ɷ��Ѿ������˳���80%�ķ�������ǰ�������ɷ���Ϊ������Э�������������Ե÷ֵļ���ģ��,��medical_exp1,medical_exp2;






**��ȡҽ�Ʒ������ã�medical care utilization�����ֱ���������Ϊҽ�Ʒ�������ָ��;
proc univariate data=charls.hypertensive_clean1;var r1hsptim1y r1hspnite r1doctim1m;title 'charls.hypertensive_clean1 descriptive';run;
proc univariate data=charls.hypertensive_clean2;var r1hsptim1y r1hspnite r1doctim1m;title 'charls.hypertensive_clean2 descriptive';run;
**3�������ֱ�����ȥһ��סԺ���������һ��סԺ��������ȥһ�������￴ҽ���Ĵ���;

*��3��������ȡ���ɷ֣�����Ϊҽ�Ʒ���ָ��;
proc princomp data=charls.hypertensive_clean1_comp out=charls.hypertensive_clean1_comp std plot=all prefix=medical_use noprint;
var r1hsptim1y r1hspnite r1doctim1m;
run;*�����֪ǰ�������ɷ��Ѿ������˳���80%�ķ�������ǰ�������ɷ���Ϊ������Э�������������Ե÷ֵļ���ģ��,��medical_use1,medical_use2;


proc princomp data=charls.hypertensive_clean2_comp out=charls.hypertensive_clean2_comp std plot=all prefix=medical_use noprint;
var r1hsptim1y r1hspnite r1doctim1m;
run;*�����֪ǰ�������ɷ��Ѿ������˳���80%�ķ�������ǰ�������ɷ���Ϊ������Э�������������Ե÷ֵļ���ģ��,��medical_use1,medical_use2;
*ͬʱ����������ɷֵ÷ֺ�����ݼ�����R����������Ե÷�ƥ�����;
%dataexport(charls.hypertensive_clean1_comp,C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�ٷ��ϲ������ݼ�,csv)
%dataexport(charls.hypertensive_clean2_comp,C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�ٷ��ϲ������ݼ�,csv)

*2.�����Ե÷ּ��㽵ά;

   

proc logistic data=charls.hypertensive_clean1_comp;
    class ragender raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken  r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')= ragender raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi r1agey sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10;
	*���������Χ��C-��Ӧ����Э����;
	*2019.11.18,��Э����r1sport�����滻Ϊr1ltact_c;
	*2019.11.21,����r1cesd10:���������÷����;
	output out=charls.hypertensive_clean1_ps predicted=score;
run;



proc logistic data=charls.hypertensive_clean2_comp;
    class ragender raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken  r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')= ragender raeducl h1rural r1mstath  r1diabe r1drinkl r1smoken r1ltact_c r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi r1agey sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10;
	*���������Χ��C-��Ӧ����Э����;
	*2019.11.18,��Э����r1sport�����滻Ϊr1ltact_c;
	output out=charls.hypertensive_clean2_ps predicted=score;
run;



*3.��������������Ե÷ּ��㣬�����Ե÷ּ��㲢δ��������r1agect���Ա�ragender�������˶����r1ltact_c�Լ���ס������h1rural����Ϊ��Щ���ؽ���Ϊ�������黮������;


proc logistic data=charls.hypertensive_clean1_comp;
    class  raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')= raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10;
	*���������Χ��C-��Ӧ����Э����;
    *2019.11.21,����r1cesd10:���������÷����;
	output out=charls.hypertensive_clean1_ps_sub predicted=score;
run;


proc logistic data=charls.hypertensive_clean2_comp;
    class  raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income;
    model bpwestdrug_11(event='1')= raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income
    medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10;
	*���������Χ��C-��Ӧ����Э����;
	*2019.11.21,����r1cesd10:���������÷����;
	output out=charls.hypertensive_clean2_ps_sub predicted=score;
run;




**���������Ե÷ֺ�����ݼ�Ϊcharls.hypertensive_clean1\2_ps,��ҪУ����Э��������Ϊscore\score2;
proc univariate data=charls.hypertensive_clean1_comp;var score medical_use1;run;
proc univariate data=charls.hypertensive_clean2_ps;var score;run;

proc ttest data=charls.hypertensive_clean1_ps;class bpwestdrug_11;var score;run;
proc ttest data=charls.hypertensive_clean2_ps;class bpwestdrug_11;var score;run;



*==============================================================*
���Դ���
**��Լ���õ��������Ե÷ֽ���ƥ�䣬�����ƥ������ݼ����к�������**;


%gmatch (data=charls.hypertensive_clean1_ps,group=bpwestdrug_11,id=ID,mvars=score,wts=1,dmaxk=0.05,dist=1,ncontls=1,seedca=20191107,seedco=201911071,out=psmatch,
outnmca=unmatchca,outnmco=unmatchco,print=N);

proc sql;create table matched1 as 
   select __IDCA as ID ,__CA1 as PS 
from psmatch;
quit;

%datasetinfo(matched1)*ID�������ֵ�ͱ�������Ҫ����ת��Ϊ�ַ���;
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

proc freq data=charls.hypertensive_clean1_matched;table bpwestdrug_11;run;*ƥ��ɹ����������������������������������������뽫PSmatch�������и���;


*����������������н����������ݼ�Ϊtest_psmatch;
%PSmatching(charls.hypertensive_clean1_comp,test_psmatch,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
bpwestdrug_11,1,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10,
ID,0.1,1,20191126,201911261)
*���н��һ���Բ���;
proc freq data=charls.hypertensive_clean1_matched;table bpwestdrug_11;run;
proc freq data=test_psmatch;table bpwestdrug_11;run;
*��ȫһ�£�������??B������������������������;

proc sort data=charls.hypertensive_clean1_psmatched out=charls.hypertensive_clean1_psmatched_te nodupkey;by ID r1agey householdID r1bmi;run;


*
���Դ������
*======================================================*


/**������logistic�Ͷ����ع�������ģ�͵�����Է���**/

/**��Զ�����������������������ʹ�û��ЧӦ��������ģ��GLMM���������**/
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



ods rtf file='C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\���ֲ�.rtf';
proc freq data=charls.hypertensive_clean1_ps;table bpwestdrug_11*stroke_incidence/relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_ps;table bpwestdrug_11*heart_incidence/relrisk;run;
proc freq data=charls.hypertensive_clean1_ps;table bpwestdrug_11*cvd_events/relrisk;run;
ods rtf close;



*=========================================================
*ʦ����Ѫ�ܷ��շֲ����*;

*������,ֱ��У�������Ե÷�*;

proc sort data=charls.hypertensive_clean1_ps;by riskstrata_11_wu;run;


ods rtf file='C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\�ֲ����_riskstrata_wu.rtf';
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_wu*bpwestdrug_11*stroke_incidence/cmh relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_wu*bpwestdrug_11*heart_incidence/cmh relrisk;run;
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_wu*bpwestdrug_11*cvd_events/cmh relrisk;run;
ods rtf close;



ods rtf file="C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\��Ѫ���¼������ط������_strata_wu_У��PS.rtf" 
style=Journal3a;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1') ID  riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11  score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu ��δ�漰���飩';
run;


/**�������У����RR
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
/**���ּ������У����RR��Ҳ�޷��ֲ������ͬʱ�޷�����������䣬�ʷ�����2019.11.30��**/


/**�ٴγ������У����RR**/

/**glimmix��**/
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps;
   class bpwestdrug_11(ref=first) ID riskstrata_11_wu(ref=last);
   model cvd_events(event='1')=bpwestdrug_11  score /solution dist=bin link=log;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   estimate 'Using Drug VS Not Using Drug' bpwestdrug_11 1/exp;
   title 'Results of heartdisease_incidence comparisons RR ��δ�漰���飩';
run;

/**genmod��**/
proc genmod data=charls.hypertensive_clean1_ps descending;
    class bpwestdrug_11 riskstrata_11_wu/param=ref ref=first;
    model  cvd_events=bpwestdrug_11  score/dist=bin link=log;
    estimate "Results of heartdisease_incidence comparisons RR ��δ�漰���飩" bpwestdrug_11 1/ exp;*�����Ǹ������Ӻ���Ϊlog���ҶԱ�ϵ������Ϊ1�����Ҽ���expѡ��õ��ľ���therapyЧӦ��RR���ƽ��;
    run;




/**2020.02.22����glimmix���̲����ڶ�������Ӧ�����ֲ����޷�����link=log��ѡ���genmod����Ȼ���Լ��㣬����ֻ��exactѡ��ſ��Էֲ㣬�ٴη�������У����RR**/


ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11  score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heartdisease_incidence comparisons OR by riskstrata_11_wu ��δ�漰���飩';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID  riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11  score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu ��δ�漰���飩';
run;

ods rtf close;

*����������ȡ�����Ե÷�ƥ�������ݼ�*;

%PSmatching(charls.hypertensive_clean1_comp,charls.hypertensive_clean1_psmatched,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
bpwestdrug_11,raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10,
ID_new,0.05,1,20191126,201911261);
*ƥ���;
proc freq data=charls.hypertensive_clean1_psmatched;table bpwestdrug_11;run;




/***�ɴ���,���Զ�ƥ����ɵ����ݼ�����ȥ�أ�����ʧ�ܣ���˾��������ݼ���������stata�����PSM����
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
**ƥ������Լ���**;
%idcovariates(charls.hypertensive_clean2_psmatched,test_con,charls.hypertensive_clean2_psmatched,bpwestdrug_11,
medical_exp1 medical_exp2 medical_use1 medical_use2 r1bmi sbp_11 newglu_11 newtg_11 newcho_11 newhba1c_11 newcrp_11 qm002_11 r1cesd10,
raeducl r1mstath  r1diabe  r1drinkl r1smoken r1higov  r1pubpen h1coresd total_wealth total_income,
bpwestdrug_11,C:\Users\cheng\Desktop)
**����������**;




data charls.hypertensive_clean1_psmatched;set charls.hypertensive_clean1_psmatched;
   if stroke_incidence=1|heart_incidence=1 then cvd_events=1;
   else cvd_events=0;
run;
data charls.hypertensive_clean2_psmatched;set charls.hypertensive_clean1_psmatched;
   if stroke_incidence=1|heart_incidence=1 then cvd_events=1;
   else cvd_events=0;
run;


ods rtf file='C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\�ֲ����_riskstrata_wu_PPSM.rtf';
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_wu*bpwestdrug_11*stroke_incidence/cmh relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_wu*bpwestdrug_11*heart_incidence/cmh relrisk;run;
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_wu*bpwestdrug_11*cvd_events/cmh relrisk;run;
ods rtf close;


proc sort data=charls.hypertensive_clean1_psmatched;by riskstrata_11_wu;run;

ods rtf file="C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\��Ѫ���¼������ط������_strata_wu_ƥ��PS.rtf" 
style=Journal1a;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1') ID  riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu ��δ�漰���飩';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heartdisease_incidence comparisons OR by riskstrata_11_wu ��δ�漰���飩';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1')  ID  riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu ��δ�漰���飩';
run;

ods rtf close;








*�������������r1agect,�Ա�ragender���˶����r1sportΪ�������أ���ס������ΪЭ����*;

proc sort data=charls.hypertensive_clean1_ps_sub;by riskstrata_11_wu;run;
proc freq data=charls.hypertensive_clean1_ps_sub;table r1agecat ragender r1sport h1rural;run;


ods rtf file="C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\����������\��Ѫ���¼������ط������_strata_wu_sub.rtf";

**�Ա��������**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') ragender(ref='1.male') ID  riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 score  ragender bpwestdrug_11*ragender/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu �����������Ա����飩';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') ragender(ref='1.male')  ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 score   ragender bpwestdrug_11*ragender/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heart_incidence comparisons OR by riskstrata_11_wu �����������Ա����飩';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') ragender(ref='1.male') ID riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 score  ragender bpwestdrug_11*ragender/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu �����������Ա����飩';
run;




**�����������,ģ��δ����**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1agecat(ref='30-40') ID riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 score r1agecat bpwestdrug_11*r1agecat/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu �����������������飩';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1agecat ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 score r1agecat bpwestdrug_11*r1agecat/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heart_incidence comparisons OR by riskstrata_11_wu �����������������飩';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1agecat(ref='70+') ID riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 score r1agecat bpwestdrug_11*r1agecat/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu �����������������飩';
run;


**���������������**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1sport(ref='1') ID riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 score r1sport bpwestdrug_11*r1sport/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1sport/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu �����������˶����飩';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1sport(ref='1') ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 score r1sport bpwestdrug_11*r1sport/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1sport/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heart_incidence comparisons OR by riskstrata_11_wu �����������˶����飩';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') r1sport(ref='1') ID riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 score r1sport bpwestdrug_11*r1sport/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1sport/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu �����������˶����飩';
run;


**��ס�������������**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') h1rural(ref='0.Urban Community') ID riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 score h1rural bpwestdrug_11*h1rural/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*h1rural/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu �����������ס���������飩';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') h1rural(ref='0.Urban Community') ID riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 score h1rural  bpwestdrug_11*h1rural/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*h1rural/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of heart_incidence comparisons OR by riskstrata_11_wu �����������ס���������飩';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') h1rural(ref='0.Urban Community') ID riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 score h1rural bpwestdrug_11*h1rural/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*h1rural/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_wu �����������ס���������飩';
run;

**˯��ʱ���������**;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') night_11(ref='6-7h') ID  riskstrata_11_wu;
   model stroke_incidence(event='1')=bpwestdrug_11 night_11 score  bpwestdrug_11*night_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*night_11/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu ����������˯��ʱ�����飩';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') night_11(ref='6-7h') ID  riskstrata_11_wu;
   model heart_incidence(event='1')=bpwestdrug_11 night_11 score  bpwestdrug_11*night_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*night_11/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu ����������˯��ʱ�����飩';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps_sub method=mmpl;
   class bpwestdrug_11(ref='1') night_11(ref='6-7h') ID  riskstrata_11_wu;
   model cvd_events(event='1')=bpwestdrug_11 night_11 score  bpwestdrug_11*night_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*night_11/ diff oddsratio pdiff cl;
   by riskstrata_11_wu;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_wu ����������˯��ʱ�����飩';
run;
ods rtf close;





*====================================================*;




*=========================================================
*FRS��Ѫ�ܷ��շֲ����*;
proc sort data=charls.hypertensive_clean1_ps;by riskstrata_11_frs;run;


/***��������У��PS�÷�****/;

ods rtf file='C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\�ֲ����_riskstrata_frs.rtf';
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_frs*bpwestdrug_11*stroke_incidence/cmh relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_frs*bpwestdrug_11*heart_incidence/cmh relrisk;run;
proc freq data=charls.hypertensive_clean1_ps;table riskstrata_11_frs*bpwestdrug_11*cvd_events/cmh relrisk;run;
ods rtf close;


ods rtf file="C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼������ط������_strata_frs_У��PS.rtf" style=Journal1a;
proc sort data=charls.hypertensive_clean1_ps;by riskstrata_11_frs;run;
/*�����޸�IDλ��Ϊ13λ
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
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_frs ��δ�漰���飩';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_frs;
   model heart_incidence(event='1')=bpwestdrug_11 score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of heartdisease_incidence comparisons OR by riskstrata_11_frs ��δ�漰���飩';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_frs;
   model cvd_events(event='1')=bpwestdrug_11 score /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_frs ��δ�漰���飩';
run;
ods rtf close;


/***����������ȡ�����Ե÷�ƥ�������ݼ�*/;

ods rtf file='C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\�ֲ����_riskstrata_frs_PPSM.rtf';
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_frs*bpwestdrug_11*stroke_incidence/cmh relrisk;title 'RR=drug(0)/drug(1)';run;
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_frs*bpwestdrug_11*heart_incidence/cmh relrisk;run;
proc freq data=charls.hypertensive_clean1_psmatched;table riskstrata_11_frs*bpwestdrug_11*cvd_events/cmh relrisk;run;
ods rtf close;



ods rtf file="C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\��Ѫ���¼������ط������_strata_frs_ƥ��PS.rtf" style=Journal1a;
proc sort data=charls.hypertensive_clean1_psmatched;by riskstrata_11_frs;run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=rspl;*mmpl�㷨������������rspl�㷨;
   class bpwestdrug_11(ref='1') ID riskstrata_11_frs;
   model stroke_incidence(event='1')=bpwestdrug_11 /solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of stroke_incidence comparisons OR by riskstrata_11_frs ��δ�漰���飩';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_frs;
   model heart_incidence(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of heartdisease_incidence comparisons OR by riskstrata_11_frs ��δ�漰���飩';
run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensive_clean1_psmatched method=mmpl;
   class bpwestdrug_11(ref='1')  ID riskstrata_11_frs;
   model cvd_events(event='1')=bpwestdrug_11/solution oddsratio dist=binary link=logit;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/ diff=control('1') oddsratio pdiff cl;
   by riskstrata_11_frs;
   title 'Results of combined_cvdevents_incidence comparisons OR by riskstrata_11_frs ��δ�漰���飩';
run;
ods rtf close;





/**������������������15���ʮ����Ѫ�ܷ��յ÷֣�ʹ�ù�����ЧӦ����ģ��MIXED���������,ע��ı�ֲ��庯��**/


*=========================================================
*ʦ����Ѫ�ܷ��շֲ����*;

/**������**/
proc sort data=charls.hypertensive_clean2_ps;by riskstrata_11_wu;run;

ods rtf file="C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\ʮ����Ѫ�ܷ��յ÷ַ������_strata_wu.rtf";

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
*FRS��Ѫ�ܷ��շֲ����*;
proc sort data=charls.hypertensive_clean2_ps;by riskstrata_11_frs;run;

/**������**/
ods rtf file="C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��Ѫ���¼�����Ѫ�ܷ��յ÷ַ���\ʮ����Ѫ�ܷ��յ÷ַ������_strata_frs.rtf";
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
��֪�÷ַ���;


/******ȫ��Ⱥ����*************/
proc sort data=charls.merged;by r1agecat;run;
proc means p25 p50 p75 max;var hh1atotb hh1itot;run;
/*****���ݼ�����*****/
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
 **2019.11.26���ӽ���ҩ�ͽ�֬ҩ����;
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

/***���˳���ķ��������ɽ���֪�÷���Ϊ�ظ�������ָ�꣬�����ݼ�����ת�ú��ٴν��з���***/
 data charls.merged_long;
 data charls.hypertensives_long;
 data charls.hypertensive_clean1_long;
 data charls.hypertensive_clean2_long;






 proc freq data=charls.merged;table hypertension BPstatus_11;run;

/***���������ֺ����ɷֽ�ά***/

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
	*ʹ��firth�㷨���������ļ�����Ȼ��;
	*���������Χ��C-��Ӧ����Э����;
	*2019.11.18,��Э����r1sport�����滻Ϊr1ltact_c;
	*2019.11.21,����r1cesd10:���������÷����,�޳���������Ա��Լ���������ѹ��ǰ���߽�����Ϊ������Э����ȥУ����������Ϊ�ֲ����ȥУ��;
	output out=charls.merged_ps predicted=score;
run;

/***�Ի���Ѫѹ�ֲ�**/
ods rtf file="C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\��֪�÷ַ���\15�������֪�÷ַ������_ȫ��Ⱥ.rtf";
proc sort data=charls.merged_ps;by BPstatus_11;run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat BPstatus_11 ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff  pdiff cl;
   lsmeans ragender/diff=control('1.male') pdiff cl;
   lsmeans r1agecat/diff=control('40-50');
   title 'Results of MMSE score comparisons ����Ѫѹ�ֲ㡢δ�����������ҩ�����';
   by BPstatus_11;
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat BPstatus_11 ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20 bpwestdrug_11*r1agecat/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/diff  pdiff cl;
   title 'Results of MMSE score comparisons ����Ѫѹ�ֲ㡢�����������ҩ�����';
   by BPstatus_11;
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat BPstatus_11 ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20 bpwestdrug_11*ragender/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/diff  pdiff cl;
   title 'Results of MMSE score comparisons ����Ѫѹ�ֲ㡢����Ա�����ҩ�����';
   by BPstatus_11;
run;



/***�Ի����Ƿ��и�Ѫѹ�ֲ�**/

proc sort data=charls.merged_ps;by hypertension;run;
ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat hypertension ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff  pdiff cl;
   lsmeans ragender/diff=control('1.male') pdiff cl;
   lsmeans r1agecat/diff=control('40-50');
   title 'Results of MMSE score comparisons �����Ƿ��и�Ѫѹ�ֲ㡢δ�����������ҩ�����';
   by hypertension;
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat hypertension ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20 bpwestdrug_11*r1agecat/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/diff  pdiff cl;
   title 'Results of MMSE score comparisons �����Ƿ��и�Ѫѹ�ֲ㡢�����������ҩ�����';
   by hypertension;
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.merged_ps method=mmpl;
   class bpwestdrug_11(ref='1')  ID r1agecat hypertension ragender night_11 ;
   model r4tr20=bpwestdrug_11 r1agecat ragender night_11 r1tr20 bpwestdrug_11*ragender/solution dist=gaussian link=identity;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*ragender/diff  pdiff cl;
   title 'Results of MMSE score comparisons �����Ƿ��и�Ѫѹ�ֲ㡢����Ա�����ҩ�����';
   by hypertension;
run;

ods rtf close;







/************��Ѫѹ����Ⱥ�����****************/

/***���ݼ���ά***/
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
	*���������Χ��C-��Ӧ����Э����;
	*2019.11.19,��Э����gender��r1agecat��������������滻Ϊr1ltact_c;
	output out=charls.hypertensives_ps predicted=score;
run;


/***��֪�÷ַ���***/
ods rtf file="C:\Users\cheng\Desktop\����\�������ݿ��ھ��о�\�й���Ⱥ�����������ݿ⣨charls��\�������\���������\15�������֪�÷ַ������_��Ѫѹ��Ⱥ.rtf";

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensives_ps method=mmpl;
   class bpwestdrug_11(ref='0')  ID r1agecat ragender;
   model r4tr20=bpwestdrug_11 r1agecat ragender r1tr20/solution dist=gaussian link=identity ddfm=kr2;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff  pdiff cl;
   title 'Results of MMSE score comparisons in hypertensives��δ�����������ҩ�����';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensives_ps method=mmpl;
   class bpwestdrug_11(ref='0') ID r1agecat ragender;
   model r4tr20=bpwestdrug_11 r1agecat ragender r1tr20 score/solution dist=gaussian link=identity ddfm=kr2;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11/diff  pdiff cl;
   title 'Results of MMSE score comparisons in hypertensives��δ�����������ҩ�����';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensives_ps method=mmpl;
   class bpwestdrug_11(ref='0')  ID r1agecat ragender;
   model r4tr20=bpwestdrug_11 r1agecat ragender  r1tr20  bpwestdrug_11*r1agecat/solution dist=gaussian link=identity ddfm=kr2;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/diff pdiff cl;
   title 'Results of MMSE score comparisons in hypertensives�������������ҩ�����';
run;

ods select Tests3 LSMeans Diffs;
proc glimmix data=charls.hypertensives_ps method=mmpl;
   class bpwestdrug_11(ref='0')  ID r1agecat ragender;
   model r4tr20=bpwestdrug_11 r1agecat ragender  r1tr20  bpwestdrug_11*r1agecat score/solution dist=gaussian link=identity ddfm=kr2;
   random intercept/sub=ID;
   lsmeans bpwestdrug_11*r1agecat/diff pdiff cl;
   title 'Results of MMSE score comparisons in hypertensives�������������ҩ�����';
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

/**ͼ�λ���**/




