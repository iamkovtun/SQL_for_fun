DROP TABLE IF EXISTS real_estate_data;

CREATE TABLE real_estate_data (
    UniqueID INT,
    ParcelID VARCHAR(20),
    LandUse VARCHAR(50),
    PropertyAddress VARCHAR(255),
    SaleDate DATE,
    SalePrice VARCHAR(50),
    LegalReference VARCHAR(255),
    SoldAsVacant VARCHAR(3),
    OwnerName VARCHAR(255),
    OwnerAddress VARCHAR(255),
    Acreage FLOAT,
    TaxDistrict VARCHAR(50),
    LandValue INT,
    BuildingValue INT,
    TotalValue INT,
    YearBuilt INT,
    Bedrooms INT,
    FullBath INT,
    HalfBath VARCHAR(10)
);

LOAD DATA INFILE 'C:/housing.csv'
INTO TABLE real_estate_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' -- Add this if your values are enclosed by double quotes
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @UniqueID,
    @ParcelID,
    @LandUse,
    @PropertyAddress,
    @SaleDate,
    @SalePrice,
    @LegalReference,
    @SoldAsVacant,
    @OwnerName,
    @OwnerAddress,
    @Acreage,
    @TaxDistrict,
    @LandValue,
    @BuildingValue,
    @TotalValue,
    @YearBuilt,
    @Bedrooms,
    @FullBath,
    @HalfBath
)
SET
    UniqueID = NULLIF(@UniqueID, ''),
    ParcelID = NULLIF(@ParcelID, ''),
    LandUse = NULLIF(@LandUse, ''),
    PropertyAddress = NULLIF(@PropertyAddress, ''),
    SaleDate = STR_TO_DATE(NULLIF(@SaleDate, ''), '%M %d, %Y'), -- Date conversion
    SalePrice = NULLIF(@SalePrice, ''),
    LegalReference = NULLIF(@LegalReference, ''),
    SoldAsVacant = NULLIF(@SoldAsVacant, ''),
    OwnerName = NULLIF(@OwnerName, ''),
    OwnerAddress = NULLIF(@OwnerAddress, ''),
    Acreage = NULLIF(@Acreage, ''),
    TaxDistrict = NULLIF(@TaxDistrict, ''),
    LandValue = NULLIF(@LandValue, ''),
    BuildingValue = NULLIF(@BuildingValue, ''),
    TotalValue = NULLIF(@TotalValue, ''),
    YearBuilt = NULLIF(@YearBuilt, ''),
    Bedrooms = NULLIF(@Bedrooms, ''),
    FullBath = NULLIF(@FullBath, ''),
    HalfBath = NULLIF(@HalfBath, '');
