-- This query generates an org chart, in text format (as a series of rows
-- listing employee name, department, and the name of each employee's 
-- manager. The reason for the common table expression (cte) query is to
-- generate the level of each employee in the org chart, where the person
-- at the top of the organization is at Level 0.

WITH OrgChart (EmployeeID, ManagerID, DepartmentId, FName, LName, OrgLevel)
AS
(
-- Anchor member definition
    SELECT EmployeeId, ManagerId, DepartmentId, FName, LName, 0 AS OrgLevel
    FROM tblEmployees
	WHERE ManagerId IS NULL

    UNION ALL

-- Recursive member definition
    SELECT e.EmployeeId, e.ManagerId, e.DepartmentId, e.FName, e.LName, OrgLevel + 1
    FROM tblEmployees e
    INNER JOIN OrgChart AS o
    ON e.ManagerID = o.EmployeeId
)
-- Statement that executes the CTE
SELECT o.EmployeeId, o.ManagerId, d.DepartmentName, o.FName, o.LName, o.OrgLevel
FROM OrgChart o
LEFT JOIN tblDepartments AS d
ON o.DepartmentId = d.DepartmentId
ORDER BY o.OrgLevel, d.DepartmentName, o.FName, o.LName
-- We do not need the MAXRECURSION option here -- just adding it to demonstrate the syntax
OPTION (MAXRECURSION 10)
