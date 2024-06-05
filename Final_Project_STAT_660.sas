FILENAME REFFILE '/home/u63551053/STAT_660/STAT_660_Stocks_fill_remove_missingdata_final.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;

data stocks;
set work.import;

Proc GLM;
	CLASS Market_Cap Industry_Group;
	model P_v_FCP_fixed_values= Market_Cap Industry_Group Industry_Group|True_ROA_Fixed_Values|Debt_Load_Fixed_Values;
	TITLE 'Analysis of Covariance';
	LSMeans Industry_Group / StdErr Pdiff CL Adjust = Tukey;
RUN;
	
*Adjusted means can be calculated in SAS via the LSMEANS (least-squares means) statement;
proc glm data=stocks;
CLASS Market_Cap Industry_Group;
	model P_v_FCP_fixed_values= Market_Cap Industry_Group Industry_Group|True_ROA_Fixed_Values|Debt_Load_Fixed_Values;
	TITLE 'Analysis of Covariance Part 2';
LSMeans Industry_Group / StdErr Pdiff CL Adjust = Tukey;
ODS output LSMeanCL=adj;
output out=stocksM p=predict r=resid;
run;
quit;




proc glm data=stocks;
CLASS Market_Cap Industry_Group;
	model P_v_FCP_fixed_values= Market_Cap Industry_Group Industry_Group|True_ROA_Fixed_Values|Debt_Load_Fixed_Values;
	TITLE 'Analysis of Covariance Part 3 Contrast Sectors';
LSMeans Industry_Group;
Contrast 'Information Technology vs. Healthcare' Industry_Group -2 2 2 -1 -1;
Contrast 'Hardware vs. Healthcare' Industry_Group -1 1 0 0 0;
run;
quit;




/*
Proc Univariate Data = stocksM normal;
Var resid; run;

Proc GLM data=Oyster_adj;
Title 'Homogeneity of variances';
Class Trt;
Model final_adj = Trt;
Means Trt / hovtest = Levene; run; quit;

*/



	