Coalescing an array or shifting left sparse columns

I have updated github with an elegant solution by Akrun.

R one liner (see below)

github
https://tinyurl.com/y84cz283
https://github.com/rogerjdeangelis/utl_coalescing_an_array_or_shifting_left_sparse_columns

  I renamed the colums to make the solution easier to understand.
  Easy to rename back.

  Two solutions

     1. SAS/WPS base
     2. WPS/Proc R or IML/R
     3. Improved WPS/Proc R or IML/R  ** new solution from

          https://tinyurl.com/y7xf49kw
          https://stackoverflow.com/questions/49079789/using-r-to-shift-values-to-the-left-of-data-frame

          Akrun profile
          https://stackoverflow.com/users/3732271/akrun

     (this is an indexing problem but I could not see the 'index' mapping solution)
     ( thought about peek, poke and adr)
see
https://communities.sas.com/t5/SAS-Procedures/Data-replacing/m-p/441152

INPUT
=====

 RULE

   Shift let omitting missing values


  SD1.HAVE total obs=40

  REGADJUSTED       V1      V2        V3     V4       V5       V6      V7     V8      V9      V10      V11     V12

   AA49919        1871     2111       81    2152       .        .      .       .       .        .       .       .
   AA50059         135     2173        .       .       .    21712      .       .       .        .       .       .
   AA50067        1625     2138        .       .       .        .      .       .       .        .       .       .
   AA50074        1526     2139        .       .     149     2147    145    2148       .        .       .       .
   AA50085          15     2116        .       .       .        .      .       .       .        .       .       .
   AA50114          27     2111        .       .       .        .      .       .       .        .       .       .
   AA50221         387     2111        .       .       .        .      .       .       .        .       .       .
   AA50235          27    21211        .       .       .        .      .       .       .        .       .       .

  EXAMPLE OUTPUT

  WORK.HAVXPOXPO total obs=40

   REGADJUSTED      COL1     COL2     COL3    COL4    COL5    COL6    COL7 ...

     AA49919        1871     2111       81    2152       .       .       . ...
     AA50059         135     2173    21712       .       .       .       . ...
     AA50067        1625     2138        .       .       .       .       . ...
     AA50074        1526     2139      149    2147     145    2148       . ...
     AA50085          15     2116        .       .       .       .       . ...
     AA50114          27     2111        .       .       .       .       . ...
     AA50221         387     2111        .       .       .       .       . ...
     AA50235          27    21211        .       .       .       .       . ...


PROCESS
=======

  1. SAS/WPS Base

     proc transpose data=sd1.have out=havxpo(drop=_name_);
       by regadjusted;
       var _numeric_;
     run;quit;

     proc transpose data=havXpo(where=(col1 ne .)) out=havXpoXpo(drop=_name_);
       by regadjusted;
       var _numeric_;
     run;quit;


  2. WPS/PROC R - IML/R (WORKING ODE)

     want <- matrix(NA, nrow = nrow(have), ncol = ncol(have));
     for (i in 1:nrow(have)) {
        hav<-as.numeric(have[i,]);
        res<-hav[ !is.na( hav ) ];    * res has just the non-missinh;
        want[i,1:length(res)]<-res;   * overwrite mat;
     };

  3. IMPROVED WPS/PROC R OR IML/R

     * apply put the consecutive not missing first and the missings after;
     * very elegant;

     want <-  t(apply(have, 1, function(x) c(x[!is.na(x)], x[is.na(x)])));

OUTPUT
======

  BASE WPS/SAS

   REGADJUSTED      COL1     COL2     COL3    COL4    COL5    COL6    COL7 ...

     AA49919        1871     2111       81    2152       .       .       . ...
     AA50059         135     2173    21712       .       .       .       . ...
     AA50067        1625     2138        .       .       .       .       . ...
     AA50074        1526     2139      149    2147     145    2148       . ...
     AA50085          15     2116        .       .       .       .       . ...
     AA50114          27     2111        .       .       .       .       . ...
     AA50221         387     2111        .       .       .       .       . ...
     AA50235          27    21211        .       .       .       .       . ...
    ...

  R  (leavit to the OD to add REGADJUSTED)

   WORK.WANT total obs=40

        V1      V2        V3     V4      V5      V6      V7

      1871     2111       81    2152       .       .       .
       135     2173    21712       .       .       .       .
      1625     2138        .       .       .       .       .
      1526     2139      149    2147     145    2148       .
        15     2116        .       .       .       .       .
        27     2111        .       .       .       .       .
       387     2111        .       .       .       .       .
        27    21211        .       .       .       .       .
       965     2161        .       .       .       .       .

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have( rename=(
   MEAN_OBJECTPRICE_MONTH2 = v1
   REGPERIOD2              = v2
   MEAN_OBJECTPRICE_MONTH3 = v3
   REGPERIOD3              = v4
   MEAN_OBJECTPRICE_MONTH4 = v5
   REGPERIOD4              = v6
   MEAN_OBJECTPRICE_MONTH5 = v7
   REGPERIOD5              = v8
   MEAN_OBJECTPRICE_MONTH6 = v9
   REGPERIOD6              = v10
   MEAN_OBJECTPRICE_MONTH7 = v11
   REGPERIOD7              = v12
 ));
 input
   REGADJUSTED$
   MEAN_OBJECTPRICE_MONTH2
   REGPERIOD2
   MEAN_OBJECTPRICE_MONTH3
   REGPERIOD3
   MEAN_OBJECTPRICE_MONTH4
   REGPERIOD4
   MEAN_OBJECTPRICE_MONTH5
   REGPERIOD5
   MEAN_OBJECTPRICE_MONTH6
   REGPERIOD6
   MEAN_OBJECTPRICE_MONTH7
   REGPERIOD7
   ;
cards4;
AA49919 1871 2111 81 2152 . . . . . . . .
AA50059 135 2173 . . . 21712 . . . . . .
AA50067 1625 2138 . . . . . . . . . .
AA50074 1526 2139 . . 149 2147 145 2148 . . . .
AA50085 15 2116 . . . . . . . . . .
AA50114 27 2111 . . . . . . . . . .
AA50221 387 2111 . . . . . . . . . .
AA50235 27 21211 . . . . . . . . . .
AA50237 965 2161 . . . . . . . . . .
AA50262 64535 2146 75 2162 . . . . . . . .
AA50291 39 2173 . . . . . . . . . .
AA50457 2435 2148 . . . . . . . . . .
AA50497 158 212 158 212 . . . . . . . .
AA50506 79 2131 . . . . . . . . . .
AA50644 49977 2141 . . . . . . . . . .
AA50689 29998 2131 . . . . . . . . . .
AA50768 16 2173 . . . . . . . . . .
AA50828 69977 2166 . . . . . . . . . .
AA50830 155 2158 . . . . . . . . . .
AA50840 118 2142 . . . . . . . . . .
AA50856 . 2118 . . . . . . . . . .
AA50949 125 2137 . . . . . . . . . .
AA51050 95 21612 . . . . . . . . . .
AA51061 . . 14495 2117 . . . . . . . .
AA51137 65 2127 . . . . . . . . . .
AA51151 189 2179 . . . . . . . . . .
AA51167 89 2131 . . . . . . . . . .
AA51194 326438 2142 3 2144 19 2149 . . 2145 21411 2999 2151
AA51223 45 2116 45 2116 . . . . . . . .
AA51272 1795 2159 . . . . . . . . . .
AA51285 35 2167 . . . . . . . . . .
AA51296 131 2145 . . . . . . . . . .
AA51358 8535 2153 . . . . . . . . . .
AA51388 285 21512 28 2165 . . . . . . . .
AA51392 14 21211 . . . . . . . . . .
AA51404 31 2171 . . . . . . . . . .
AA51447 273 2151 . . . . . . . . . .
AA51466 84977 2148 67 2171 . . . . . . . .
AA51479 4 21711 . . . . . . . . . .
AA51563 28 2121 1295 2165 1295 2165 125 2168 . . . .
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/

;


* SAS;
proc transpose data=sd1.have out=havxpo(drop=_name_);
  by regadjusted;
  var _numeric_;
run;quit;

proc transpose data=havXpo(where=(col1 ne .)) out=havXpoXpo(drop=_name_);
  by regadjusted;
  var _numeric_;
run;quit;

* WPS;

%utl_submit_wps64('
libname sd1 "d:/sd1";
libname wrk "%sysfunc(pathname(work))";

proc transpose data=sd1.have out=havxpo(drop=_name_);
  by regadjusted;
  var _numeric_;
run;quit;

proc transpose data=havXpo(where=(col1 ne .)) out=wrk.havXpoXpo(drop=_name_);
  by regadjusted;
  var _numeric_;
run;quit;
');

* R;

%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
have<-read_sas("d:/sd1/have.sas7bdat");
want <- matrix(NA, nrow = nrow(have), ncol = ncol(have));
for (i in 1:nrow(have)) {
   hav<-as.numeric(have[i,]);
   res<-hav[ !is.na( hav ) ];
   want[i,1:length(res)]<-res;
};
endsubmit;
import r=want data=wrk.want;
run;quit;
');

* Improved R solution;

%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk "%sysfunc(pathname(work))";
libname hlp "C:\Program Files\SASHome\SASFoundation\9.4\core\sashelp";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
have <-read_sas("d:/sd1/have.sas7bdat");
want <-  t(apply(have, 1, function(x) c(x[!is.na(x)], x[is.na(x)])));
endsubmit;
import r=want data=wrk.want_df;
run;quit;
');

