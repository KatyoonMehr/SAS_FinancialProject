
DATA Wireless;
INFILE 'C:\Users\Rayan\Desktop\Kati\SASFile\Mini Project\New_Wireless_fixed.txt' ; 
INPUT
		@1  Acctno $13.
        @15 Actdt  mmddyy10.
        @26 Deactdt mmddyy10.
        @41 DeactReason $4. 
        @53 GoodCredit 1.
        @62 RatePlan 1. 
        @65 DealerType $2.
        @74 AGE 2.
        @80 Province $2.
        @85 Sales    dollar8.2;
RUN;

/* 1.1. Explore and describe the dataset briefly */ 
ODS RTF FILE='C:\Users\Rayan\Desktop\Kati\SASFile\Mini Project\ODS\RFTFiles1.rtf';
PROC PRINT DATA=Wireless (OBS=10) LABEL ;
FORMAT Actdt Deactdt MMDDYY10.;
RUN;
PROC CONTENTS DATA=Wireless;
RUN;
ODS RTF CLOSE;

DATA Pipe;
INFILE 'C:\Users\Rayan\Desktop\Kati\SASFile\Mini Project\New_Wireless_Pipe.TXT' DLM ="|" DSD FIRSTOBS=2;
INPUT Acctno $ Actdt Deactdt DeactReason $ GoodCredit RatePlan DealerType $ AGE Province $ Sales;
INFORMAT Actdt mmddyy10. Deactdt mmddyy10. sales dollar8.2; 
LENGTH Acctno $13 DeactReason $4 DealerType $2 Province $2; 
LABEL AGE="Age" Sales="Funds";
RUN;

/* 1.1. Explore and describe the dataset briefly */ 
ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles2.rtf';
PROC PRINT DATA=Pipe (OBS=10) LABEL;
RUN;
PROC CONTENTS DATA=Pipe;
RUN;
ODS RTF CLOSE;

/* 1.1. Is the acctno unique? */
ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles3.rtf';
PROC SORT DATA=Pipe OUT=Pipe_Sort NODUPKEY;
BY Acctno;
RUN;
PROC CONTENTS DATA=Pipe_Sort;
RUN;
ODS RTF CLOSE;
/* OR */
PROC SQL;
SELECT COUNT(DISTINCT Acctno) FROM Pipe;
QUIT;
	

ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles4.rtf';
PROC SORT DATA=Wireless OUT=Wireless_Sort NODUPKEY;
BY Acctno;
RUN;
PROC CONTENTS DATA=Wireless_Sort;
RUN;
ODS RTF CLOSE;
/* OR */
PROC SQL;
SELECT COUNT(DISTINCT Acctno) FROM Wireless;
QUIT;


/*1.1. What is the number of accounts activated and deactivated? */
ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles5.rtf';
PROC MEANS DATA=Wireless N NMISS MEDIAN;
TITLE 'Missing Data For Data=Pipe';
RUN;
TITLE;
PROC MEANS DATA=Wireless N NMISS;
TITLE 'Missing Data For Data=Pipe';
RUN;
TITLE;
ODS RTF CLOSE;


/* 1.1. When is the earliest and latest activation/deactivation dates available? */
ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles5.rtf';
PROC TABULATE DATA=Wireless;
VAR Actdt Deactdt;
table Actdt Deactdt,  (MIN MAX)*FORMAT=MMDDYY10. RANGE;
RUN;
ODS RTF CLOSE;


/*1.1. More Information? */
ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles7.rtf';
PROC MEANS DATA=Pipe N NMISS MIN MAX MEAN MAXDEC=2;
VAR Age Sales;
RUN;
ODS RTF CLOSE;


ODS RTF FILE='C:\Users\Administrator\Desktop\KatiSAS\Mini Project\Q1\RFTFiles8.rtf';
PROC FREQ DATA=Wireless;
TABLE Goodcredit*Age/MISSING CHISQ RELRISK;
FORMAT Age AgeGrp.;
RUN;
PROC FREQ DATA=Pipe;
TABLE Goodcredit*province/MISSING CHISQ RELRISK;
RUN;
ODS RTF CLOSE;


/*1.2. The distribution of Age and Province and Account type: Active/Deactivated */
ODS RTF FILE='C:\Users\Administrator\Desktop\KatiSAS\Mini Project\Q1\RFTFiles9.rtf';
PROC FREQ DATA=Wireless;
TABLE Province*Age/MISSING chisq measures;
FORMAT Age AgeGrp.;
RUN;
ODS GRAPHICS ON;
PROC SGPLOT DATA=Wireless;
VBAR Province/ MISSING GROUP=Age GROUPDISPLY=cluster;
FORMAT Age AgeGrp.;
RUN;
ODS GRAPHICS OFF;
ODS RTF CLOSE;

PROC TABULATE DATA= Wireless;
CLASS Age Province/MISSING;
TABLE Age*(N PCTN), Province ALL;
FORMAT Age AgeGrp.;
RUN;


/*1.2  What is the age distributions of active and deactivated customers?  */
ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles10.rtf';
PROC UNIVARIATE DATA=Wireless NORMAL PLOT FREQ;
VAR Age;
WHERE DEACTDT=.;
HISTOGRAM/ NORMAL;
RUN;
PROC UNIVARIATE DATA=Wireless NORMAL PLOT FREQ;
VAR Age;
WHERE DEACTDT^=.;
HISTOGRAM/ NORMAL;
RUN;
ODS RTF CLOSE;


PROC UNIVARIATE DATA=Wireless NORMAL PLOT FREQ;
VAR Age;
HISTOGRAM/ NORMAL;
RUN;
PROC SGPLOT DATA=Wireless;
HISTOGRAM Age;
DENSITY Age / TYPE=NORMAL;
WHERE DEACTDT=.;
RUN;

PROC SGPLOT DATA=Wireless;
HISTOGRAM Age;
DENSITY Age / TYPE=NORMAL;
WHERE DEACTDT^=.;
RUN;



/*1.2. The distribution of Province and Account type: Active/Deactivated */
ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles12.rtf';
PROC SGPLOT DATA=Wireless;
VBAR Province;
WHERE DEACTDT=.;
RUN;

PROC SGPLOT DATA=Wireless;
VBAR Province;
WHERE DEACTDT^=.;
RUN;
ODS RTF CLOSE;

ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles13.rtf';
GOPTIONS FTEXT='Arial/Bold' HTEXT=1.5 CTEXT=BLACK; 
PROC GCHART DATA=Wireless;
PIE Province/ DISCRETE VALUE=INSIDE PERCENT=OUTSIDE SLICE=OUTSIDE;
WHERE DEACTDT=.;
TITLE 'The PieChart for Province and Deactivated Accounts';
RUN;
PROC GCHART DATA=Wireless;
PIE Province/ DISCRETE VALUE=INSIDE PERCENT=OUTSIDE SLICE=OUTSIDE;
WHERE DEACTDT^=.;
TITLE 'The PieChart for Province and Active Accounts';
RUN;
QUIT;
ODS RTF CLOSE;



/*1.3 Segment the customers based on age, province and sales amount */

PROC FORMAT;
VALUE AgeGrp 
				. = 'Missing'
				0 = 'Missing'
				1-21='<=20'
			   21-41='21-40'
			   41-61='41-60'
			   61-High='>=61';
VALUE SaleGrp
     			Low -<101='<=100  '
	 			101 -<501='101-500'
	 			501 -<801='501-800'
				801 -high='801 +  ';
RUN;

ODS RTF FILE='C:\Users\Administrator\Desktop\KatiSAS\Mini Project\Q1\RFTFiles14.rtf';
PROC TABULATE DATA=Wireless_New (WHERE=(Active=1)) MISSING NOSEPS;
  CLASS Province Sales;
  VAR AccChar;
  FORMAT Sales SaleGrp.;
  TABLE Province=' ' ALL, Sales='Sales'*AccChar=' '*N/ BOX='Province';
  TITLE 'Table for Active Account'; RUN;
PROC TABULATE DATA=Wireless_New (WHERE=(Active=0)) MISSING NOSEPS;
  CLASS Province Sales;
  VAR AccChar;
  FORMAT Sales SaleGrp.;
  TABLE Province=' ' ALL, Sales='Sales'*AccChar=' '*N/ BOX='Province';
  TITLE 'Table for Non-Active Account'; RUN;
PROC TABULATE DATA=Wireless_New (WHERE=(Active=1)) MISSING NOSEPS;
  CLASS Age Sales;
  VAR AccChar;
  FORMAT Age AgeGrp. Sales SaleGrp.;
  TABLE Age=' ' ALL, Sales='Sales'*AccChar=' '*N/ BOX='Age';
  TITLE 'Table for Active Account'; RUN;
PROC TABULATE DATA=Wireless_New (WHERE=(Active=0)) MISSING NOSEPS;
  CLASS Age Sales;
  VAR AccChar;
  FORMAT Age AgeGrp. Sales SaleGrp.;
  TABLE Age=' ' ALL, Sales='Sales'*AccChar=' '*N/ BOX='Age';
  TITLE 'Table for Active Account'; RUN;
PROC TABULATE DATA=Wireless_New (WHERE=(Active=1)) MISSING NOSEPS;
  CLASS Province Age Sales;
  VAR AccChar;
  FORMAT Age AgeGrp. Sales SaleGrp. ;
  TABLE Province=' ' ALL, Age=' '* Sales='Sales' * AccChar=' '*N='Number_of_Accounts' /BOX='Province'; RUN;
PROC TABULATE DATA=Wireless_New (WHERE=(Active=0)) MISSING NOSEPS;
  CLASS Province Age Sales;
  VAR AccChar;
  FORMAT Age AgeGrp. Sales SaleGrp. ;
  TABLE Province=' ' ALL, Age=' '* Sales='Sales' * AccChar=' '*N='Number_of_Accounts' /BOX='Province'; RUN;
ODS RTF CLOSE;

/* Is not working with this data */
ODS GRAPHICS ON;
PROC CLUSTER DATA=WireProv METHOD=ward ccc pseudo print=15;
VAR Sales Age Province_code;
   FORMAT Age AgeGrp. Sales SaleGrp.;
run;
ODS GRAPHICS OFF;
PROC TREE DATA=Tree OUT=CLUS_New nclusters=3 noprint;
   COPY Sales Age Province_code;
   FORMAT Age AgeGrp. Sales SaleGrp.;
RUN;
PROC SGPLOT DATA=CLUS_New;
   SCATTER Y=Age X=Province_Code / GROUP=Sales;
    FORMAT Age AgeGrp. Sales SaleGrp.;
RUN;
/********************************/


PROC ANOVA DATA=Wireless_New;
CLASS Province RatePlan DealerType Active;
MODEL GoodCredit=Province RatePlan DealerType Active;
RUN;


ODS RTF FILE='C:\Users\Rayan\Desktop\SASFile\Mini Project\ODS\RFTFiles13.rtf';
PROC LOGISTIC DATA=Wireless_New;
MODEL GoodCredit=Sales Province_Code RatePlan DealCode Age;
RUN;
PROC LOGISTIC DATA=Wireless_New;
MODEL GoodCredit=  RatePlan DealCode;
RUN;
ODS RTF CLOSE;


/* 1.4.1 Calculate the tenure in days for each account and give its simple statistics. */
DATA Wireless_New;
SET Wireless;
AccChar=INPUT(Acctno, 13.);
IF Deactdt=. THEN DO;
	Active=1;
	Tenure=INTCK ('DAY', Actdt, '20JUN2001'D);
		END;
		ELSE IF Deactdt^=. THEN DO;
		Active=0;
		Tenure=INTCK ('DAY', Actdt, Deactdt);
		END;
			ELSE DO;
			Active=.;
			Tenure=.;
			END;
			IF Province='AB' THEN Province_Code=1;
ELSE IF Province='BC' THEN Province_Code=2;
ELSE IF Province='NS' THEN Province_Code=3;
ELSE IF Province='ON' THEN Province_Code=4;
ELSE IF Province='QC' THEN Province_Code=5;
ELSE Province_Code=.;
IF DealerType='A1' THEN DealCode=1;
ELSE IF DealerType='A2' THEN DealCode=2;
ELSE IF DealerType='B1' THEN DealCode=3;
ELSE IF DealerType='C1' THEN DealCode=4;
ELSE DealCode=.;
RUN;

ODS RTF FILE='C:\Users\Administrator\Desktop\KatiSAS\Mini Project\Q1\RFTFiles6.rtf';
PROC PRINT DATA=Wireless_New (OBS=10);
RUN;
PROC MEANS DATA=Wireless_New N NMISS MIN MAX MEAN MAXDEC=2;
  CLASS active;
  VAR tenure;
RUN;
ODS RTF CLOSE;


/* 1.4.2 Calculate the number of accounts deactivated for each year month.*/
ODS RTF FILE='C:\Users\Administrator\Desktop\KatiSAS\Mini Project\Q1\RFTFiles16.rtf';
DATA Wireless_Deact;
SET Wireless_New;
IF Active=0;
Month=MONTH(Deactdt);
Year=YEAR(Deactdt);
RUN;
PROC SORT DATA=Wireless_Deact;
BY Year Month;
RUN;
PROC FORMAT;
VALUE MonthF 1='January' 2='Febuary' 3='March' 4='April' 5='May' 6='June' 
			 7='July' 8='August' 9='September' 10='October' 11='November' 12='December';
			 RUN;
PROC SQL;
SELECT Year, Month FORMAT=MonthF. , COUNT(Acctno) AS Total_of_Deactive
	FROM Wireless_Deact
	GROUP BY Year, Month;
QUIT;
ODS RTF CLOSE;


/* 1.4.3.Segment the account, first by account status �Active� and �Deactivated�, then by
Tenure: < 30 days, 31---60 days, 61 days--- one year, over one year. Report the
number of accounts of percent of all for each segment. */

PROC FORMAT;
VALUE TenureF
    0-31 ='<=30 days'
	31-61 ='31-60 days'
	61-366 ='61-365 days'
	366-High ='Over one year'
	;
RUN;
ODS RTF FILE='C:\Users\Administrator\Desktop\KatiSAS\Mini Project\Q1\RFTFiles17.rtf';
PROC TABULATE DATA=Wireless_New MISSING NOSEPS;
  CLASS Active Tenure;
  VAR AccChar;
  FORMAT Tenure TenureF.;
  TABLE  Active=' ' ALL='Total', Tenure=' '*AccChar=' '*(N='Qty'*FORMAT=COMMA6.0 PCTSUM<Tenure>='Row%');
RUN;
PROC FREQ DATA=Wireless_New;
  TABLE Active * Tenure/MISSING;
  FORMAT Tenure TenureF.;
RUN;
ODS RTF CLOSE;

TITLE;

/*1.4.4 Test the general association between the tenure segments and �Good Credit�
�RatePlan � and �DealerType.� */

PROC FREQ DATA=Wireless_New (WHERE=(Active=0));
TABLE DealerType/MISSING LIST;
TABLE GoodCredit/MISSING LIST;
TABLE RatePlan/MISSING LIST;
RUN;
PROC FREQ DATA=Wireless_New (WHERE=(Active=1));
TABLE DealerType/MISSING LIST;
TABLE GoodCredit/MISSING LIST;
TABLE RatePlan/MISSING LIST;
RUN;


ODS RTF FILE='C:\Users\Administrator\Desktop\KatiSAS\Mini Project\Q1\RFTFiles18.rtf';
PROC TABULATE DATA=Wireless_new(WHERE=(Active=0)) MISSING ;
  CLASS Tenure GoodCredit;
  VAR AccChar;
  FORMAT Tenure TenureF.;
  TABLE  Tenure=' ' * (N PCTSUM<tenure>='Column%'), GoodCredit * AccChar=' ' /BOX=Tenure;
PROC TABULATE DATA=Wireless_new(WHERE=(Active=0)) MISSING ;
  CLASS Tenure RatePlan;
  VAR AccChar;
  FORMAT Tenure TenureF.;
  TABLE  Tenure=' ' * (N PCTSUM<tenure>='Column%'), RatePlan * AccChar=' ' /BOX=Tenure;
PROC TABULATE DATA=Wireless_new(WHERE=(Active=0)) MISSING ;
  CLASS Tenure DealerType;
  VAR AccChar;
  FORMAT Tenure TenureF.;
  TABLE  Tenure=' ' * (N PCTSUM<tenure>='Column%'), DealerType * AccChar=' ' /BOX=Tenure;
RUN;
PROC TABULATE DATA=Wireless_new(WHERE=(Active=0)) MISSING ;
  CLASS Tenure GoodCredit RatePlan DealerType;
  VAR AccChar;
  FORMAT Tenure TenureF.;
  TABLE  Tenure=' ' * (N PCTSUM<tenure>='Column%'), GoodCredit * AccChar=' ' 
  RatePlan * AccChar=' '  DealerType * AccChar=' ' /BOX=Tenure;
  RUN;
  PROC TABULATE DATA=Wireless_new(WHERE=(Active=1)) MISSING ;
  CLASS Tenure GoodCredit RatePlan DealerType;
  VAR AccChar;
  FORMAT Tenure TenureF.;
  TABLE  Tenure=' ' * (N PCTSUM<tenure>='Column%'), GoodCredit * AccChar=' ' 
  RatePlan * AccChar=' '  DealerType * AccChar=' ' /BOX=Tenure;
  RUN;
ODS RTF CLOSE;


/* 1.4.5 Is there any association between the account status and the tenure segments? */
ODS RTF FILE='C:\Users\Administrator\Desktop\KatiSAS\Mini Project\Q1\RFTFiles19.rtf';
PROC FREQ DATA=Wireless_New;
  TABLE Active*Tenure / MISSING CHISQ ;
  FORMAT Tenure TenureF.;
RUN;
PROC REG DATA=Wireless_New;
MODEL Tenure= Active Sales DealCode RatePlan GoodCredit Age Province_Code;
RUN;
PROC REG DATA=Wireless_New;
MODEL Tenure= Active DealCode RatePlan GoodCredit;
RUN;
ODS RTF CLOSE;


/* 1.4.6 Does Sales amount differ among different account status, GoodCredit, and
customer age segments? */
ODS RTF FILE='C:\Users\Administrator\Desktop\KatiSAS\Mini Project\Q1\RFTFiles20.rtf';
PROC TABULATE DATA=Wireless_New MISSING NOSEPS;
  CLASS Active Age GoodCredit;
  VAR Sales;
  FORMAT Age AgeGrp.;
  TABLE  Active * Age=' ', GoodCredit * Sales=' '*(N NMISS MEAN MAX MIN STDDEV);
  RUN;
PROC FREQ DATA=Wireless_New;
  TABLE Active*Age/ CHISQ;
  FORMAT Age AgeGrp.;
RUN;
PROC FREQ DATA=Wireless_New;
  TABLE Active*GoodCredit/ CHISQ;
RUN;
ODS RTF CLOSE;





DATA Phase2;
SET Wireless;
IF Province ^= ' ' AND Sales ^=. ;
RUN;
PROC SORT DATA= Phase2;
BY DESCENDING Sales;
RUN;
PROC RANK DATA=Phase2 (KEEP=Province Sales) DESCENDING
GROUPS=10
OUT=GROUP_10;
RANKS rank;
VAR Sales;
RUN;
PROC TABULATE DATA=Group_10 FORMAT=DOLLAR12.;
CLASS rank;
VAR Sales;
TABLE rank,
Sales *(N*Format= COMMA6.0 MIN MEAN MAX SUM)/ BOX= _PAGE_;
Footnote 'Sales Distribution by rank';
RUN;

TITLE;
ODS GRAPHICS ON;
PROC SGPLOT DATA=Wireless_New;
VBOX Tenure / CATEGORY=Active;
RUN;
PROC SGPLOT DATA=Wireless_New;
VBOX Tenure / CATEGORY=DealerType;
RUN;
PROC SGPLOT DATA=Wireless_New;
VBOX Sales / CATEGORY=GoodCredit;
RUN;
PROC SGPLOT DATA=Wireless_New;
HISTOGRAM Sales / SHOWBINS SCALE=COUNT;
DENSITY Sales /  TYPE=KERNEL;
RUN;
ODS GRAPHICS OFF;

PROC ANOVA DATA=Wireless_New;
CLASS GoodCredit Active DealerType RatePlan Age;
FORMAT Age AgeGrp.;
MODEL Sales=GoodCredit Active DealerType RatePlan Age;
RUN;

ODS GRAPHICS ON;
PROC TTEST DATA=Wireless_New COCHRAN CI=equal umpu;
CLASS Active;
VAR Sales;
RUN;
ODS GRAPHICS OFF;

ODS GRAPHICS ON;
PROC TTEST DATA=Wireless_New COCHRAN CI=equal umpu;
CLASS GoodCredit;
VAR Sales;
RUN;
ODS GRAPHICS OFF;



