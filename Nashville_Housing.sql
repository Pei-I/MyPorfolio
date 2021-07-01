
/*
Cleaning Data in SQL Queries
*/

SELECT *
FROM 
  MyPortfolio..Nashville_Housing

--------------------------------------------------------------------------------------------------------------------------

-- Change the datatype of 'SaleDate' column from datetime to date

SELECT 
  SaleDate
From 
  MyPortfolio..Nashville_Housing

ALTER TABLE Nashville_Housing  
ALTER COLUMN SaleDate DATE --MySQL: MODIFY COLUMN 

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data (Using ISNULL, self join)

SELECT *
FROM 
  MyPortfolio..Nashville_Housing
WHERE 
  PropertyAddress is NULL

SELECT *
FROM 
  MyPortfolio..Nashville_Housing
ORDER BY 
  ParcelID --Checking if there are same ParcelID

SELECT 
  A.ParcelID, 
  A.PropertyAddress, 
  B.ParcelID, 
  B.PropertyAddress
From 
  MyPortfolio..Nashville_Housing A
JOIN 
  MyPortfolio..Nashville_Housing B
  ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

SELECT 
  A.ParcelID, 
  A.PropertyAddress, 
  B.ParcelID, 
  B.PropertyAddress,
  ISNULL(A.PropertyAddress, B.PropertyAddress) 
  --Adding ISNULL function  ISNULL(Column shows NULL, Alternative column) 
  --My SQL --> IFNULL or COALESCE
From 
  MyPortfolio..Nashville_Housing A
JOIN 
  MyPortfolio..Nashville_Housing B
  ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A --Populate Address (Update)
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress) 
From 
  MyPortfolio..Nashville_Housing A
JOIN 
  MyPortfolio..Nashville_Housing B
  ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out PropertyAddress into Individual Columns (Address, City, State)

SELECT 
  PropertyAddress
FROM 
  MyPortfolio..Nashville_Housing

--The CHARINDEX() function searches for a substring in a string, and returns the position.
 --If the substring is not found, this function returns 0.
--Syntax: CHARINDEX(substring, string, start) 

--SUBSTRING()
--Syntax: SUBSTRING(string, start, length)

--LEN()
--Syntax: LEN(string)


--Extracting "Address"  from PropertyAddress
 SELECT--Using SUBSTRING() and CHARINDEX()
   SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address   
   --- '-1' Means the returned position minus 1. In order to get rid of comma 
FROM 
   MyPortfolio..Nashville_Housing

---Extracting "City" from PropertyAddress
 SELECT--Using SUBSTRING() , CHARINDEX() , LEN() 
   SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)-CHARINDEX(',',PropertyAddress)) AS City
   --                                                           Total length-length from the head to comma = length of City
FROM 
   MyPortfolio..Nashville_Housing

--Update the table-- Add column of "PropertySplitAddress" and "PropertySplitity"
ALTER TABLE    
  MyPortfolio..Nashville_Housing
ADD 
  PropertySplitAddress NVARCHAR(255)

UPDATE    
  MyPortfolio..Nashville_Housing
SET PropertySplitAddress = 
      SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)    

ALTER TABLE    
  MyPortfolio..Nashville_Housing
ADD 
  PropertySplitCity NVARCHAR(255)

UPDATE    
  MyPortfolio..Nashville_Housing
SET PropertySplitCity = 
    SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)-CHARINDEX(',',PropertyAddress)) 

--Checking again
SELECT *
FROM MyPortfolio..Nashville_Housing

--------------------------------------------------------------------------------------------------------------------------
--Split "Owner Address" to Address, City, and State
--Using PARSNAME() and REPLACE()

--1. PARSNAME()
--Returns the specified part of an object name. The parts of an object that can be retrieved are the object name, schema name, database name, and server name.
--Syntax: PARSENAME ('object_name' , object_piece )  **Only recognize '.' ¥yÂI

--2. REPLACE()
--replaces all occurrences of a substring within a string, with a new substring.
--Syntax: REPLACE(string, old_string, new_string)

SELECT 
  OwnerAddress
FROM 
  MyPortfolio..Nashville_Housing


SELECT
  REPLACE(OwnerAddress, ',','.') --Replacing comma to dot
FROM MyPortfolio..Nashville_Housing


SELECT
  PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
  PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
	PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM 
  MyPortfolio..Nashville_Housing

--Update the table-- Add column of "OwnerSplitAddress" , "OwnerSplitity" ,"OwnerSplitState"
ALTER TABLE    
  MyPortfolio..Nashville_Housing
ADD 
  OwnerSplitAddress NVARCHAR(255)

UPDATE    
  MyPortfolio..Nashville_Housing
SET OwnerSplitAddress = 
       PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE    
  MyPortfolio..Nashville_Housing
ADD 
  OwnerSplitCity NVARCHAR(255)

UPDATE    
  MyPortfolio..Nashville_Housing
SET OwnerSplitCity = 
       PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE    
  MyPortfolio..Nashville_Housing
ADD 
  OwnerSplitState NVARCHAR(255)

UPDATE    
  MyPortfolio..Nashville_Housing
SET OwnerSplitState = 
       PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT *  --Checking
FROM
  MyPortfolio..Nashville_Housing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


SELECT SoldAsVacant 
FROM
  MyPortfolio..Nashville_Housing
WHERE SoldAsVacant ='N'

UPDATE 
  MyPortfolio..Nashville_Housing
SET 
  SoldAsVacant ='Yes'
WHERE SoldAsVacant ='Y'

UPDATE 
  MyPortfolio..Nashville_Housing
SET 
  SoldAsVacant ='No'
WHERE SoldAsVacant ='N'
  
---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


ALTER TABLE  MyPortfolio..Nashville_Housing
DROP COLUMN OwnerAddress,PropertyAddress



