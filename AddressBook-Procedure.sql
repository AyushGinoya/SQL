CREATE PROCEDURE [dbo].[PR_SelectAllCity]
AS
SELECT 
	[dbo].[City].[CityID],
	[dbo].[City].[CityName],
	[dbo].[City].[PinCode],
	[dbo].[City].[StateID],
	[dbo].[City].[STDCode]
FROM
[dbo].[City]


CREATE PROCEDURE [dbo].[PR_SelectAllState]
AS
SELECT 
	[dbo].[State].[CountryID],
	[dbo].[State].[StateID],
	[dbo].[State].[StateName],
	[dbo].[State].[StateCode]
FROM
[dbo].[State]


CREATE PROCEDURE [dbo].[PR_SelectAllContact]
AS
BEGIN
    SELECT 
        [ContactID],
        [ContactCategoryID],
        [CountryID],
        [StateID],
        [CityID],
        [Name],
        [Gender],
        [MobileNo1],
        [WhatsAppNo],
        [Email],
        [Age],
        [Address],
        [FacebookID],
        [LinkedID],
        [BirthDate],
        [BloodGroup]
    FROM 
        [dbo].[Contact];
END;



CREATE PROCEDURE [dbo].[PR_SelectAllContactCategory]
AS
BEGIN
    SELECT 
        [ContactCategoryID],
        [ContactCategoryName],
        [CreationDate]
    FROM 
        [dbo].[ContactCategory];
END;
