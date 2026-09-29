
USE Hospital;
GO

-- Q1
SELECT w.Name AS WardName,
       COUNT(p.Id) AS CountOfPatients
FROM Patients p
INNER JOIN Wards w ON w.Id = p.WardId
GROUP BY w.Name;

-- Q2
SELECT AVG(Salary) AS AverageSalary
FROM Consultants;

-- Q3
SELECT MIN(Salary) AS MinSalary,
       MAX(Salary) AS MaxSalary,
       AVG(Salary) AS AverageSalary,
       SUM(Salary) AS TotalSalary
FROM Consultants;

-- Q4
SELECT p.WardId,
       COUNT(p.Id) AS NumberOfPatients
FROM Patients p
INNER JOIN Wards w ON w.Id = p.WardId
GROUP BY p.WardId
ORDER BY NumberOfPatients DESC;

-- Q5
SELECT p.Id AS PatientId,
       COALESCE(SUM(da.Quantity), 0) AS TotalQuantity
FROM Patients p
LEFT JOIN DrugAdministrations da ON da.PatientId = p.Id
GROUP BY p.Id;

-- Q6
SELECT PatientId,
       COUNT(*) AS NumOfDrugs
FROM DrugAdministrations
GROUP BY PatientId;

-- Q7
SELECT w.Name AS WardName,
       COUNT(p.Id) AS NumOfPatients
FROM Wards w
LEFT JOIN Patients p ON w.Id = p.WardId
GROUP BY w.Id, w.Name;

-- Q8
SELECT w.Name AS WardName,
       AVG(n.Salary) AS AverageSalary
FROM Wards w
LEFT JOIN Nurses n ON w.Id = n.ServesInWardId
GROUP BY w.Id, w.Name;

-- Q9
SELECT w.Name AS WardName,
       COUNT(p.Id) AS NumOfPatients
FROM Wards w
INNER JOIN Patients p ON w.Id = p.WardId
GROUP BY w.Id, w.Name
HAVING COUNT(p.Id) > 3;

-- Q10
SELECT p.Id,
       p.Name,
       COUNT(*) AS NumOfTimes
FROM Patients p
INNER JOIN DrugAdministrations da ON p.Id = da.PatientId
GROUP BY p.Id, p.Name
HAVING COUNT(*) > 5;

-- Q11
SELECT Name, Salary
FROM Consultants
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Consultants
);

-- Q12
SELECT Name, Salary
FROM Nurses
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Nurses
);

-- Q13
;WITH WardCounts AS (
    SELECT WardId, COUNT(*) AS PatientCount
    FROM Patients
    WHERE WardId IS NOT NULL
    GROUP BY WardId
)
SELECT p.Name, p.Id, p.WardId
FROM Patients p
INNER JOIN WardCounts wc ON wc.WardId = p.WardId
WHERE wc.PatientCount = (
    SELECT MAX(PatientCount)
    FROM WardCounts
);

-- Q14
SELECT Name, Salary
FROM Consultants
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Consultants
);

-- Q15
SELECT p.Id AS PatientId,
       p.Name
FROM Patients p
WHERE EXISTS (
    SELECT 1
    FROM DrugAdministrations da
    WHERE da.PatientId = p.Id
);

-- Q16
SELECT p.Id AS PatientId,
       p.Name
FROM Patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM DrugAdministrations da
    WHERE da.PatientId = p.Id
);

-- Q17
SELECT p.Id,
       p.Name,
       COUNT(da.PatientId) AS NumberOfAdministrations
FROM Patients p
LEFT JOIN DrugAdministrations da ON p.Id = da.PatientId
GROUP BY p.Id, p.Name;

-- Q18
SELECT p.Id,
       p.Name,
       COALESCE(SUM(da.Quantity), 0) AS TotalQuantity
FROM Patients p
LEFT JOIN DrugAdministrations da ON p.Id = da.PatientId
GROUP BY p.Id, p.Name;

-- Q19
SELECT c.Id, c.Name, c.Salary
FROM Consultants c
CROSS JOIN (
    SELECT AVG(Salary) AS AverageSalary
    FROM Consultants
) AS AverageTable
WHERE c.Salary > AverageTable.AverageSalary;

-- Q20
;WITH PatientTotals AS (
    SELECT PatientId,
           SUM(Quantity) AS TotalQuantity
    FROM DrugAdministrations
    GROUP BY PatientId
)
SELECT p.PatientId, p.TotalQuantity
FROM PatientTotals p
WHERE p.TotalQuantity > (
    SELECT AVG(CAST(TotalQuantity AS DECIMAL(18,2)))
    FROM PatientTotals
);

-- Q21
SELECT *
INTO PatientCopy
FROM Patients;

-- Q22
SELECT Id, Name, DOB
INTO PatientCopy1
FROM Patients;

-- Q23
SELECT Id, Name, Salary
INTO ConsultantCopy
FROM Consultants;

-- Q24
SELECT p.Name AS PatientName,
       w.Name AS WardName
INTO PatientWardCopy
FROM Patients p
INNER JOIN Wards w ON w.Id = p.WardId;

-- Q25
SELECT p.Name AS PatientName,
       c.Name AS ConsultantName
INTO PatientConsultantCopy
FROM Patients p
INNER JOIN PatientExaminations pe ON p.Id = pe.PatientId
INNER JOIN Consultants c ON c.Id = pe.ConsultantId;

-- Q26
SELECT Name, Salary
INTO ConsultantCopy1
FROM Consultants
WHERE Salary > 50000;

-- Q27
SELECT Id, Name, DOB
INTO PatientCopy3
FROM Patients
WHERE DOB > '2000-01-01';

-- Q28
SELECT n.Name AS NurseName,
       w.Name AS WardName,
       n.Salary
INTO NurseCopy
FROM Nurses n
INNER JOIN Wards w ON w.Id = n.ServesInWardId
WHERE n.Salary > 30000;

-- Q29
SELECT w.Id AS WardId,
       w.Name AS WardName,
       COUNT(p.Id) AS PatientCount
INTO PatientWardCopy1
FROM Wards w
LEFT JOIN Patients p ON p.WardId = w.Id
GROUP BY w.Id, w.Name;

-- Q30
SELECT p.Id AS PatientId,
       COALESCE(SUM(da.Quantity), 0) AS TotalQuantity
INTO DACopy
FROM Patients p
LEFT JOIN DrugAdministrations da ON p.Id = da.PatientId
GROUP BY p.Id;

-- Q31
GO
CREATE FUNCTION dbo.CalculateAge
(
    @DateOfBirth DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;

    SET @Age = DATEDIFF(YEAR, @DateOfBirth, GETDATE())
        - CASE
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, @DateOfBirth, GETDATE()),
                         @DateOfBirth) > GETDATE()
            THEN 1
            ELSE 0
          END;

    RETURN @Age;
END;
GO

-- Q32
CREATE FUNCTION dbo.CalculateAnnualSalary
(
    @Salary DECIMAL(8,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN @Salary * 12;
END;
GO

-- Q33
CREATE FUNCTION dbo.TotalCost
(
    @Quantity INT,
    @UnitPrice DECIMAL(8,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN @Quantity * @UnitPrice;
END;
GO

-- Q34
CREATE FUNCTION dbo.GetPatientsByWard
(
    @WardId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Patients
    WHERE WardId = @WardId
);
GO

-- Q35
CREATE FUNCTION dbo.GetConsultantsByMinimumSalary
(
    @MinimumSalary DECIMAL(18,2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT Id, Name, Salary
    FROM Consultants
    WHERE Salary >= @MinimumSalary
);
GO

-- Q36
CREATE FUNCTION dbo.GetPatientsWithWard
(
    @WardId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT p.Id AS PatientId,
           p.Name AS PatientName,
           w.Name AS WardName
    FROM Patients p
    INNER JOIN Wards w ON w.Id = p.WardId
    WHERE w.Id = @WardId
);
GO

-- Q37
CREATE FUNCTION dbo.GetPatientsWithAge
(
    @MinimumAge INT
)
RETURNS @Patients TABLE
(
    PatientId INT,
    PatientName NVARCHAR(255),
    DOB DATE,
    Age INT
)
AS
BEGIN
    INSERT INTO @Patients
    SELECT p.Id,
           p.Name,
           p.DOB,
           dbo.CalculateAge(p.DOB)
    FROM Patients p
    WHERE dbo.CalculateAge(p.DOB) >= @MinimumAge;

    RETURN;
END;
GO

-- Q38
CREATE FUNCTION dbo.GetPatientMedicationSummary
(
    @PatientId INT
)
RETURNS @MedicationSummary TABLE
(
    PatientId INT,
    TotalQuantity INT,
    NumberOfAdministrations INT
)
AS
BEGIN
    INSERT INTO @MedicationSummary
    SELECT @PatientId,
           COALESCE(SUM(Quantity), 0),
           COUNT(*)
    FROM DrugAdministrations
    WHERE PatientId = @PatientId;

    RETURN;
END;
GO

-- Q39
CREATE FUNCTION dbo.ClassifyConsultantSalaries
(
    @MinimumSalary DECIMAL(18,2)
)
RETURNS @Consultants TABLE
(
    ConsultantId INT,
    ConsultantName NVARCHAR(255),
    Salary DECIMAL(18,2),
    SalaryClassification NVARCHAR(30)
)
AS
BEGIN
    INSERT INTO @Consultants
    SELECT Id,
           Name,
           Salary,
           CASE
               WHEN Salary >= @MinimumSalary THEN 'Meets Minimum'
               ELSE 'Below Minimum'
           END
    FROM Consultants;

    RETURN;
END;
GO

-- Q40
SELECT p.Id AS PatientId,
       p.Name AS PatientName,
       COUNT(da.PatientId) AS NumberOfAdministrations,
       COALESCE(SUM(da.Quantity), 0) AS TotalQuantity,
       AVG(CAST(da.Quantity AS DECIMAL(18,2))) AS AverageQuantity
FROM Patients p
LEFT JOIN DrugAdministrations da ON p.Id = da.PatientId
GROUP BY p.Id, p.Name;

-- Q41
;WITH WardCounts AS (
    SELECT w.Id,
           w.Name,
           COUNT(p.Id) AS PatientCount
    FROM Wards w
    LEFT JOIN Patients p ON p.WardId = w.Id
    GROUP BY w.Id, w.Name
)
SELECT Id AS WardId,
       Name AS WardName,
       PatientCount
FROM WardCounts
WHERE PatientCount > (
    SELECT AVG(CAST(PatientCount AS DECIMAL(18,2)))
    FROM WardCounts
);

-- Q42
SELECT p.Id,
       p.Name
INTO PatientsMoreThan5
FROM Patients p
INNER JOIN DrugAdministrations da ON p.Id = da.PatientId
GROUP BY p.Id, p.Name
HAVING COUNT(*) > 5;

-- Q43
SELECT Name,
       Salary AS MonthlySalary,
       dbo.CalculateAnnualSalary(Salary) AS AnnualSalary
INTO ConsultantSalaries
FROM Consultants;

-- Q44
SELECT Id, Name, Salary
FROM dbo.GetConsultantsByMinimumSalary(50000)
WHERE Name LIKE 'A%';

-- Q45
SELECT PatientId, PatientName, DOB, Age
FROM dbo.GetPatientsWithAge(30)
ORDER BY Age DESC;

-- Q46
SELECT p.Id AS PatientId,
       p.Name AS PatientName,
       w.Name AS WardName,
       dbo.CalculateAge(p.DOB) AS PatientAge,
       COUNT(da.PatientId) AS NumberOfAdministrations,
       COALESCE(SUM(da.Quantity), 0) AS TotalQuantity
FROM Patients p
LEFT JOIN Wards w ON w.Id = p.WardId
LEFT JOIN DrugAdministrations da ON da.PatientId = p.Id
GROUP BY p.Id, p.Name, p.DOB, w.Name;