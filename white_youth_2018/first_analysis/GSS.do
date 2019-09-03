#delimit ;

   infix
      year     1 - 20
      workwhts 21 - 40
      racwork  41 - 60
      goveqinc 61 - 80
      marhomo  81 - 100
      meovrwrk 101 - 120
      realrinc 121 - 140
      ethnic   141 - 160
      racecen1 161 - 180
      uscitzn  181 - 200
      wlthwhts 201 - 220
      helppoor 221 - 240
      racdif3  241 - 260
      id_      261 - 280
      age      281 - 300
      sex      301 - 320
      race     321 - 340
      partyid  341 - 360
      raclive  361 - 380
      fepol    381 - 400
      owngun   401 - 420
      racdif1  421 - 440
      ballot   441 - 460
using GSS.dat;

label variable year     "Gss year for this respondent                       ";
label variable workwhts "Hard working - lazy";
label variable racwork  "Racial makeup of workplace";
label variable goveqinc "Govmnt should reduce inc differentials";
label variable marhomo  "Homosexuals should have right to marry";
label variable meovrwrk "Men hurt family when focus on work too much";
label variable realrinc "Rs income in constant $";
label variable ethnic   "Country of family origin ";
label variable racecen1 "What is rs race 1st mention";
label variable uscitzn  "Is r us citizen";
label variable wlthwhts "Rich - poor";
label variable helppoor "Should govt improve standard of living?";
label variable racdif3  "Differences due to lack of education";
label variable id_      "Respondent id number";
label variable age      "Age of respondent";
label variable sex      "Respondents sex";
label variable race     "Race of respondent";
label variable partyid  "Political party affiliation";
label variable raclive  "Any opp. race in neighborhood";
label variable fepol    "Women not suited for politics";
label variable owngun   "Have gun in home";
label variable racdif1  "Differences due to discrimination";
label variable ballot   "Ballot used for interview";


label define gsp001x
   9        "No answer"
   8        "Dont know"
   7        "Lazy"
   1        "Hardworking"
   0        "Not applicable"
;
label define gsp002x
   9        "No answer"
   8        "Don't know"
   6        "Works alone"
   5        "All black"
   4        "Mostly black"
   3        "Half white-black"
   2        "Mostly white"
   1        "All white"
   0        "Not applicable"
;
label define gsp003x
   9        "No answer"
   8        "Cant choose"
   5        "Strongly disagree"
   4        "Disagree"
   3        "Neither"
   2        "Agree"
   1        "Strongly agree"
   0        "Not applicable"
;
label define gsp004x
   9        "No answer"
   8        "Cant choose"
   5        "Strongly disagree"
   4        "Disagree"
   3        "Neither agree nor disagree"
   2        "Agree"
   1        "Strongly agree"
   0        "Not applicable"
;
label define gsp005x
   9        "No answer"
   8        "Can't choose"
   5        "Strongly disagree"
   4        "Disagree"
   3        "Neither agree nor disagree"
   2        "Agree"
   1        "Strongly agree"
   0        "Not applicable"
;
label define gsp006x
   999999   "No answer"
   999998   "Dont know"
   0        "Not applicable"
;
label define gsp007x
   99       "No answer"
   98       "No eth mentioned"
   97       "American only"
   41       "Other european"
   40       "Other asian"
   39       "Non-span windies"
   38       "Other spanish"
   37       "Arabic"
   36       "Belgium"
   35       "Rumania"
   34       "Yugoslavia"
   33       "Lithuania"
   32       "Portugal"
   31       "India"
   30       "American indian"
   29       "Other"
   28       "West indies"
   27       "Switzerland"
   26       "Sweden"
   25       "Spain"
   24       "Scotland"
   23       "Russia"
   22       "Puerto rico"
   21       "Poland"
   20       "Philippines"
   19       "Norway"
   18       "Netherlands"
   17       "Mexico"
   16       "Japan"
   15       "Italy"
   14       "Ireland"
   13       "Hungary"
   12       "Greece"
   11       "Germany"
   10       "France"
   9        "Finland"
   8        "England & wales"
   7        "Denmark"
   6        "Czechoslovakia"
   5        "China"
   4        "Other canada"
   3        "French canada"
   2        "Austria"
   1        "Africa"
   0        "Uncodeable & iap"
;
label define gsp008x
   99       "No answer"
   98       "Don't know"
   16       "Hispanic"
   15       "Some other race"
   14       "Other pacific islander"
   13       "Samoan"
   12       "Guamanian or chamorro"
   11       "Native hawaiian"
   10       "Other asian"
   9        "Vietnamese"
   8        "Korean"
   7        "Japanese"
   6        "Filipino"
   5        "Chinese"
   4        "Asian indian"
   3        "American indian or alaska native"
   2        "Black or african american"
   1        "White"
   0        "Not applicable"
;
label define gsp009x
   9        "No answer"
   8        "Dont know"
   4        "Born outside of the united states to parents who were u.s citizens at that time (if volunteered)"
   3        "A u.s. citizen born in puerto rico, the u.s. virgin islands, or the northern marianas islands"
   2        "Not a u.s. citizen"
   1        "A u.s. citizen"
   0        "Not applicable"
;
label define gsp010x
   9        "No answer"
   8        "Dont know"
   7        "Poor"
   1        "Rich"
   0        "Not applicable"
;
label define gsp011x
   9        "No answer"
   8        "Don't know"
   5        "People help selves"
   3        "Agree with both"
   1        "Govt action"
   0        "Not applicable"
;
label define gsp012x
   9        "No answer"
   8        "Don't know"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
label define gsp013x
   99       "No answer"
   98       "Don't know"
   89       "89 or older"
;
label define gsp014x
   2        "Female"
   1        "Male"
;
label define gsp015x
   3        "Other"
   2        "Black"
   1        "White"
   0        "Not applicable"
;
label define gsp016x
   9        "No answer"
   8        "Don't know"
   7        "Other party"
   6        "Strong republican"
   5        "Not str republican"
   4        "Ind,near rep"
   3        "Independent"
   2        "Ind,near dem"
   1        "Not str democrat"
   0        "Strong democrat"
;
label define gsp017x
   9        "No answer"
   8        "Don't know"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
label define gsp018x
   9        "No answer"
   8        "Not sure"
   2        "Disagree"
   1        "Agree"
   0        "Not applicable"
;
label define gsp019x
   9        "No answer"
   8        "Don't know"
   3        "Refused"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
label define gsp020x
   9        "No answer"
   8        "Don't know"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
label define gsp021x
   4        "Ballot d"
   3        "Ballot c"
   2        "Ballot b"
   1        "Ballot a"
   0        "Not applicable"
;


label values workwhts gsp001x;
label values racwork  gsp002x;
label values goveqinc gsp003x;
label values marhomo  gsp004x;
label values meovrwrk gsp005x;
label values realrinc gsp006x;
label values ethnic   gsp007x;
label values racecen1 gsp008x;
label values uscitzn  gsp009x;
label values wlthwhts gsp010x;
label values helppoor gsp011x;
label values racdif3  gsp012x;
label values age      gsp013x;
label values sex      gsp014x;
label values race     gsp015x;
label values partyid  gsp016x;
label values raclive  gsp017x;
label values fepol    gsp018x;
label values owngun   gsp019x;
label values racdif1  gsp020x;
label values ballot   gsp021x;


