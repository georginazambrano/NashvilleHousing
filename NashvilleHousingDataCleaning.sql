Select *
From PortfolioProject5..NashvilleHousing

-- Standardize Date Format

Select SaleDate, CONVERT(Date, SaleDate)
From PortfolioProject5..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject5..NashvilleHousing

--Populate Property Address Data
Select *
From PortfolioProject5..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject5..NashvilleHousing a
JOIN PortfolioProject5..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject5..NashvilleHousing a
JOIN PortfolioProject5..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address Into Individual Columns (Address, City, State)
Select PropertyAddress
From PortfolioProject5..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)) as Address,
From PortfolioProject5..NashvilleHousing

--To Remove Comma 
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
From PortfolioProject5..NashvilleHousing

--Continued...
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortfolioProject5..NashvilleHousing

--"+1" is there to remove comma under the city


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

Select *
From PortfolioProject5..NashvilleHousing

Select OwnerAddress
From PortfolioProject5..NashvilleHousing

--Another way to split without substring

Select
PARSENAME(Replace (OwnerAddress, ',', '.') , 3)
,PARSENAME(Replace (OwnerAddress, ',', '.') , 2)
,PARSENAME(Replace (OwnerAddress, ',', '.') , 1)
From PortfolioProject5..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace (OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace (OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace (OwnerAddress, ',', '.') , 1)

--Change Y and N to Yes and No in 'sold as vacant' Field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject5..NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From PortfolioProject5..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
From PortfolioProject5..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order By PropertyAddress


--Delete Unused Columns
Select *
From PortfolioProject5..NashvilleHousing


ALTER TABLE PortfolioProject5..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject5..NashvilleHousing
DROP COLUMN SaleDate