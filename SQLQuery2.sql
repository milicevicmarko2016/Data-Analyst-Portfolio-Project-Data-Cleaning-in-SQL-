/*
Celaning Data in SQL Queries 
*/

Select * 
From [SQL Tutorial].dbo.NashvilleHousing
------------------------------------

-- Standardize Date Format

Select saleDateConverted, CONVERT(date,SaleDate)
From [SQL Tutorial].dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing 
SET saleDateConverted = CONVERT(date,SaleDate)

-------------------------------------------------------

-- Populate Property Address data

Select *
From [SQL Tutorial].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQL Tutorial].dbo.NashvilleHousing a
JOIN [SQL Tutorial].dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<> b.[UniqueID ]
 Where a.PropertyAddress is null

 Update a 
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 From [SQL Tutorial].dbo.NashvilleHousing a
JOIN [SQL Tutorial].dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<> b.[UniqueID ]
 Where a.PropertyAddress is null



 ------------------------------------------------------------------------------------


 -- Breaking out Address into Individual Columns (Address, City, State) 


 Select PropertyAddress
From [SQL Tutorial].dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress)+1 , LEN (PropertyAddress)) as Address

--CHARINDEX (',', PropertyAddress)
From [SQL Tutorial].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing 
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing 
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress)+1 , LEN (PropertyAddress))

select *
From [SQL Tutorial].dbo.NashvilleHousing


select OwnerAddress
From [SQL Tutorial].dbo.NashvilleHousing


Select 
PARSENAME(REPLACE (OwnerAddress, ',', '.'),3)
, PARSENAME(REPLACE (OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE (OwnerAddress, ',', '.'),1)
from [SQL Tutorial].dbo.NashvilleHousing





ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE (OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE (OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE (OwnerAddress, ',', '.'),1)



select *
From [SQL Tutorial].dbo.NashvilleHousing

---------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [SQL Tutorial].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From [SQL Tutorial].dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

---------------------------------------------------
-- Remove Duplicates 

WITH rowNumCTE AS(
Select *,
ROW_NUMBER () OVER(
PARTITION BY ParcelID, 
             PropertyAddress, 
			 SalePrice, 
			 SaleDate, 
			 LegalReference
			 ORDER BY
			    UniqueId
				) row_num


From [SQL Tutorial].dbo.NashvilleHousing
--order by ParcelID
)

Select *
From rowNumCTE
Where row_num>1
Order by PropertyAddress

-------------------------------------

-- Delete Unused Columns

select *
From [SQL Tutorial].dbo.NashvilleHousing

ALTER TABLE [SQL Tutorial].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [SQL Tutorial].dbo.NashvilleHousing
DROP COLUMN SaleDate