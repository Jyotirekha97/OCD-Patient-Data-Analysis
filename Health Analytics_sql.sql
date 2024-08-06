create database Health_Analytics;
use Health_Analytics;
CREATE TABLE PatientData (
    PatientID INT,
    Age INT,
    Gender VARCHAR(10),
    Ethnicity VARCHAR(50),
    MaritalStatus VARCHAR(50),
    EducationLevel VARCHAR(50),
    OCDDiagnosisDate DATE,
    DurationOfSymptoms INT,
    PreviousDiagnoses VARCHAR(50),
    FamilyHistoryOCD VARCHAR(10),
    ObsessionType VARCHAR(50),
    CompulsionType VARCHAR(50),
    YBOCSScoreObsessions INT,
    YBOCSScoreCompulsions INT,
    DepressionDiagnosis VARCHAR(10),
    AnxietyDiagnosis VARCHAR(10),
    Medications VARCHAR(50)
);

-- 1. Count & Pct of F vs M that have OCD & Average Obsession Score by Gender
SELECT 
    Gender,
    COUNT(*) AS count,
    AVG(YBOCSScoreObsessions) AS Avg_Obsession_Score,
    COUNT(*) * 100 / (SELECT 
            COUNT(*)
        FROM
            PatientData
        WHERE
            YBOCSScoreObsessions > 0
                AND YBOCSScoreCompulsions > 0) AS PCT
FROM
    PatientData
WHERE
    YBOCSScoreObsessions > 0
        AND YBOCSScoreCompulsions > 0
GROUP BY Gender;

###########################################################################################################################

with data as (
SELECT
Gender,
count(`PatientID`) as patient_count,
round(avg(`YBOCSScoreObsessions`),2) as avg_obs_score

FROM PatientData
Group By 1
Order by 2
)

select
	sum(case when Gender = 'Female' then patient_count else 0 end) as count_female,
	sum(case when Gender = 'Male' then patient_count else 0 end) as count_male,

	round(sum(case when Gender = 'Female' then patient_count else 0 end)/
	(sum(case when Gender = 'Female' then patient_count else 0 end)+sum(case when Gender = 'Male' then patient_count else 0 end)) *100,2)
	 as pct_female,

    round(sum(case when Gender = 'Male' then patient_count else 0 end)/
	(sum(case when Gender = 'Female' then patient_count else 0 end)+sum(case when Gender = 'Male' then patient_count else 0 end)) *100,2)
	 as pct_male

from data
;

-- 2. Count of Patients by Ethnicity and their respective Average Obsession Score

SELECT 
    Ethnicity,
    COUNT(PatientID) AS Patient,
    ROUND((YBOCSScoreObsessions), 2) AS obs_score
FROM
    PatientData
GROUP BY Ethnicity
ORDER BY Patient;  

-- 3. Number of people diagnosed with OCD MoM
SELECT 
    DATE_FORMAT(OCDDiagnosisDate, '%y-%m-01') AS Month,
    COUNT(PatientID) AS diagnosed_number
FROM
    PatientData
GROUP BY month
ORDER BY diagnosed_number;  

-- 4. What is the most common Obsession Type (Count) & it's respective Average Obsession Score

SELECT 
    ObsessionType,
    COUNT(PatientID) AS Count,
    ROUND(AVG(YBOCSScoreObsessions), 2) AS Average_Obsession_Score
FROM
    PatientData
GROUP BY ObsessionType
ORDER BY Count DESC
;  

-- 5. What is the most common Compulsion type (Count) & it's respective Average Obsession Score

SELECT 
    CompulsionType,
    COUNT(PatientID) AS count,
    ROUND(AVG(YBOCSScoreObsessions)) AS Average_Obsession_Score
FROM
    PatientData
GROUP BY CompulsionType
ORDER BY count;  


