/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject.dbo.NashvilleHousing;


-- 1.	Standardize Date Format

BEGIN TRANSACTION;
Alter Table PortfolioProject.dbo.NashvilleHousing
Alter Column SaleDate Date
Select SaleDate
From PortfolioProject.dbo.NashvilleHousing;

COMMIT;



-- 2. Populate property address data

Select *
From PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID;

	--create 2 tables side by side showing just parcelid and propertyaddress

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]  -- <> means not equal to
where a.PropertyAddress is null;

	--update the table

BEGIN TRANSACTION;
UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]  -- <> means not equal to
where a.PropertyAddress is null;

	-- CHECK CHANGES
	Select * From PortfolioProject.dbo.NashvilleHousing where PropertyAddress is null;

COMMIT;


-- 3.	Breaking out address into individual columns (Address, City, State)

	--Starting with Property Address

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing;

	-- SPLITTING THE ADDRESS USING SUBSTRING

Select PropertyAddress,
	SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 ) as Address,
	SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, len(PropertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing;


	-- create 2 columns for each part of the splitted address

BEGIN TRANSACTION;
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress nvarchar(255), 
	PropertySplitCity nvarchar(255);

		-- confirm 
select * from PortfolioProject.dbo.NashvilleHousing;

COMMIT;

	-- populate the created columns with their values

BEGIN TRANSACTION;
UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 ), 
	PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, len(PropertyAddress));

		-- confirm
select * from PortfolioProject.dbo.NashvilleHousing;	

COMMIT;


	-- Doing OwnerAddress
	select * from PortfolioProject.dbo.NashvilleHousing;

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing;		 
-- where OwnerAddress is null;

-- SPLITTING THE ADDRESS USING PARSENAME

select 
PARSENAME( REPLACE(OwnerAddress, ',', '.') ,3)	as Address,	-- 1. Parsename only searches for '.'	 2. Parcename starts the count from right to left.	3. Replace all ',' with '.'
PARSENAME( REPLACE(OwnerAddress, ',', '.') , 2)	as City,
PARSENAME( REPLACE(OwnerAddress, ',', '.') , 1) as State
from PortfolioProject.dbo.NashvilleHousing;



	-- create 3 columns for each part of the splitted address
BEGIN TRANSACTION;
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress nvarchar(255), 
	OwnerSplitCity nvarchar(255),
	OwnerSplitState nvarchar(255);

		-- confirm 
select * from PortfolioProject.dbo.NashvilleHousing;

COMMIT;


	-- populate the created columns with their values

BEGIN TRANSACTION;
UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME( REPLACE(OwnerAddress, ',', '.') ,3), 
	OwnerSplitCity = PARSENAME( REPLACE(OwnerAddress, ',', '.') ,2),
	OwnerSplitState = PARSENAME( REPLACE(OwnerAddress, ',', '.') ,1);

		-- confirm
select * from PortfolioProject.dbo.NashvilleHousing;

COMMIT;

select * from PortfolioProject.dbo.NashvilleHousing;


-- 4.	Lookking at the SoldAsVacant column

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2;


	-- Convert the Y and N to Yes and No

select SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
from PortfolioProject.dbo.NashvilleHousing;


	-- UPDATE THE TABLE

BEGIN TRANSACTION;
UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END;

		-- confirm
select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2;

COMMIT;


-- 5.	Remove Duplicates

Select *
From PortfolioProject.dbo.NashvilleHousing;

	-- USING CTE, USE ROW_NUMBER() TO SELECT ONLY THE FIRST OCCURENCE. OTHER OPTIONS DENSE_RANK(), RANK()

BEGIN TRANSACTION;
with RowNumCTE as (
	Select *,
		ROW_NUMBER() OVER (
			PARTITION BY 
			ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
			ORDER BY UniqueID) as row_num
	From PortfolioProject.dbo.NashvilleHousing)

	-- DELETE DUPLICATES
DELETE
from RowNumCTE
where row_num > 1;

	-- CONFIRM
with RowNumCTE as (
	Select *,
		DENSE_RANK() OVER (
			PARTITION BY 
			ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
			ORDER BY UniqueID) as row_num
	From PortfolioProject.dbo.NashvilleHousing)
Select row_num
from RowNumCTE
where row_num > 1;

COMMIT;




-- 6.	Delete unused Columns

select * from PortfolioProject.dbo.NashvilleHousing;

	-- SELECT COLUMNS TO DROP
BEGIN TRANSACTION;
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, 
			OwnerAddress;
			--TaxDistrict;

	-- CONFIRM
select * from PortfolioProject.dbo.NashvilleHousing;

-- ROLLBACK;

COMMIT;


-- View cleaned data


select * from PortfolioProject.dbo.NashvilleHousing;
