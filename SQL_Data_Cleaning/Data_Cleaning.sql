Q28.Find a list of Male patients whose age is more than 60 whose, BMI is more than 18.5, and whose height
 is more than e 1.5 M.

SELECT CONCAT("Firstname", ' ', "Lastname") AS "MalePatients",a."Age",a."BMI",a."Height"
FROM public."Patients" AS a INNER JOIN public."Gender" AS b ON a."Gender_ID"=b."Gender_ID"
where b."Gender"='Male' and a."Age">60 and a."BMI">18.5 and a."Height">1.5;

Q21.Create a trigger to raise notice and prevent the deletion of a record from a view.

Create view for patient table
CREATE VIEW PatientsView
AS 
SELECT pnt."Patient_ID",pnt."Firstname", pnt."Lastname", pnt."Visit_Date",pnt."Age", pnt."Height", pnt."BMI",
grp."Group",gnr."Gender",race."Race",bp."24Hr_Day_SBP",bp."24Hr_Day_DBP",bp."24Hr_Day_HR",
opt."Diabetic_Retinopathy", opt."Macular_Edema", lr."Lipid_ID", lr."Lab_ID"
FROM public."Patients" AS pnt 
INNER JOIN public."Group" AS grp ON pnt."Group_ID" = grp."Group_ID"
INNER JOIN public."Gender" AS gnr ON pnt."Gender_ID" = gnr."Gender_ID"
INNER JOIN public."Race" AS race ON pnt."Race_ID" = race."Race_ID"
INNER JOIN public."Blood_Pressure" AS bp ON pnt."BP_ID" = bp."BP_ID"
INNER JOIN public."Opthalmology" AS opt ON pnt."Opthal_ID" = opt."Opthal_ID"
INNER JOIN public."Link_Reference" AS lr ON pnt."Link_Reference_ID" = lr."Link_Reference_ID"
Create trigger to prevent delete record from view
CREATE TRIGGER TG_PATIENT_PREVENT_DELETE
INSTEAD OF DELETE
ON PatientsView
FOR EACH ROW
EXECUTE PROCEDURE patient_prevent_delete();
CREATE FUNCTION patient_prevent_delete()
RETURNS TRIGGER
AS $$
BEGIN
RAISE EXCEPTION 'You cannot delete records from View';
END;
$$
LANGUAGE plpgsql;
--Test Delete record operation--
delete from patientsview where "Patient_ID"='S0030';

Q24. Identify the patient count by Gender and Race combination.

SELECT gnr."Gender",race."Race", count(pnt."Patient_ID")
FROM public."Patients" AS pnt 
INNER JOIN public."Gender" AS gnr ON pnt."Gender_ID" = gnr."Gender_ID"
INNER JOIN public."Race" AS race ON pnt."Race_ID" = race."Race_ID"
group by gnr."Gender",race."Race" order by gnr."Gender",race."Race";

Q25.Get the number of patients in the year 2005 in each of the Genesis and Cultivate labs.

SELECT lv."Lab_names", count(pnt."Patient_ID")
FROM public."Patients" pnt
INNER JOIN public."Link_Reference" lr ON pnt."Link_Reference_ID" = lr."Link_Reference_ID"
INNER JOIN public."Lab_Visit" as lv ON lr."Lab_visit_ID" = lv."Lab_visit_ID"
AND "Lab_names" IN ('Cultivate Lab','Genesis Lab')
AND date_part('year', "Lab_Visit_Date")::integer = '2005'
group by "Lab_names";

Q26.Write a query to get a list of patient IDs' and their Fasting Cholesterol in February 2006.

SELECT pnt."Patient_ID", llt."Fasting_Cholestrol"
  FROM public."Patients" pnt
  INNER JOIN public."Link_Reference" lr ON pnt."Link_Reference_ID" = lr."Link_Reference_ID"
   INNER JOIN public."Lipid_Lab_Test" as llt ON lr."Lipid_ID" = llt."Lipid_ID"
   INNER JOIN public."Lab_Visit" as lv ON lr."Lab_visit_ID" = lv."Lab_visit_ID"
   AND to_char("Lab_Visit_Date", 'YYYY-MM') = '2006-02';

Q27.Write a query to get a list of patients whose first names is starting with the letter T

SELECT "Firstname" FROM public."Patients" where "Firstname" ~* '^t';

Q29.Display the patient names and ages whose age is more than 60 years.

SELECT CONCAT ("Firstname", ' ', "Lastname") AS "Fullname","Age"
FROM public."Patients" WHERE "Age">60;

Q39.  Find out the tables where column Patient_ID is present. (Display column position number with respective table also)

SELECT ORDINAL_POSITION AS column_position,tables.table_name
FROM information_schema.tables AS tables
JOIN information_schema.columns AS columns
ON columns.table_name = tables.table_name
AND columns.table_schema = tables.table_schema
WHERE columns.column_name = 'Patient_ID' 
ORDER BY tables.table_name;

Q73. Write a query to the get number of Patient_IDs who visited between March 2005 and March 2006

select count("Patient_ID")Patients_visited_btw_mar05_mar06  from public."Patients"
WHERE "Visit_Date" BETWEEN '2005-03-01' AND '2006-03-31';



