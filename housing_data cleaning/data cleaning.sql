
-- Change Y and N to Yes and No in "Sold as Vacant" field
UPDATE real_estate_data
SET SoldAsVacant = CASE
                     WHEN SoldAsVacant = 'Y' THEN 'Yes'
                     WHEN SoldAsVacant = 'N' THEN 'No'
                     ELSE SoldAsVacant
                   END;
                   
SELECT * FROM real_estate_data;

-- pupulate Null data in Property adress
SELECT *
FROM real_estate_data
WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress, b.PropertyAddress) AS UpdatedAddress
FROM real_estate_data a
JOIN real_estate_data b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE real_estate_data a
JOIN real_estate_data b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- breaking out adress' into different individual columns
ALTER TABLE real_estate_data
ADD COLUMN Property_Address VARCHAR(255),
ADD COLUMN City VARCHAR(255);

UPDATE real_estate_data
SET Property_Address = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    City = SUBSTRING_INDEX(PropertyAddress, ',', -1);

-- check result 
SELECT * FROM real_estate_data;

-- Drop the existing PropertyAddress column if needed
ALTER TABLE real_estate_data
DROP COLUMN PropertyAddress;

ALTER TABLE real_estate_data
ADD COLUMN Owner_Address VARCHAR(255),
ADD COLUMN Owner_City VARCHAR(255),
ADD COLUMN Owner_State VARCHAR(255);

UPDATE real_estate_data
SET 
    Owner_Address = SUBSTRING_INDEX(OwnerAddress, ',', 1),
    Owner_City = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1),
    Owner_State = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

-- Optionally, you can drop the existing OwnerAddress column if it's no longer needed
ALTER TABLE real_estate_data
DROP COLUMN OwnerAddress;

-- check result 
SELECT * FROM real_estate_data;

-- Identifying duplicates
WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, Property_Address, SalePrice, SaleDate, LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM real_estate_data
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY Property_Address;

-- Deleting duplicates
WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, Property_Address, SalePrice, SaleDate, LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM real_estate_data
)
DELETE FROM real_estate_data
WHERE UniqueID IN (
    SELECT UniqueID
    FROM RowNumCTE
    WHERE row_num > 1
);



