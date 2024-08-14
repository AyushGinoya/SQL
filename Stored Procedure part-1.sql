-- Procedure to select all records from the CUSTOMER table

-- The procedure does not take any parameters and simply selects all columns 
-- from the CUSTOMER table that are relevant for the user.
CREATE PROCEDURE CUSTOMER_SELECTALL
AS
BEGIN
    -- Select specific columns from the CUSTOMER table
    SELECT
        CUST_CODE, 
        CUST_NAME, 
        CUST_CITY, 
        WORKING_AREA, 
        CUST_COUNTRY, 
        GRADE, 
        OPENING_AMT, 
        RECEIVE_AMT, 
        PAYMENT_AMT, 
        OUTSTANDING_AMT, 
        PHONE_NO
    FROM CUSTOMER;
END;

-- Execute the procedure to view all customer records
EXEC CUSTOMER_SELECTALL;
-- You can also use: EXECUTE CUSTOMER_SELECTALL;

---------------------------------------------------------------------

-- Procedure to get details of a specific customer based on their CUST_CODE

-- The procedure takes a single parameter @CustomerID to filter the results.
CREATE PROCEDURE GetCustomerDetails
    @CustomerID VARCHAR(6)  
AS  
BEGIN
    -- Select specific columns where the CUST_CODE matches the provided CustomerID
    SELECT 
        CUST_CODE, 
        CUST_NAME, 
        CUST_CITY
    FROM CUSTOMER
    WHERE CUST_CODE = CAST(@CustomerID AS VARCHAR(6));
END;

-- Execute the procedure by passing the customer ID as a parameter
EXEC GetCustomerDetails @CustomerID = 'C00001';
-- Alternative syntax: EXEC GetCustomerDetails 'C00001';

---------------------------------------------------------------------

-- Procedure to insert a new customer record into the CUSTOMER table

-- The procedure takes multiple parameters corresponding to the columns in the CUSTOMER table.
CREATE PROCEDURE InsertCustomer
    @CUST_CODE VARCHAR(10),
    @CUST_NAME VARCHAR(50),
    @CUST_CITY VARCHAR(50),
    @WORKING_AREA VARCHAR(50),
    @CUST_COUNTRY VARCHAR(50),
    @GRADE INT,
    @OPENING_AMT DECIMAL(18, 2),
    @RECEIVE_AMT DECIMAL(18, 2),
    @PAYMENT_AMT DECIMAL(18, 2),
    @OUTSTANDING_AMT DECIMAL(18, 2),
    @PHONE_NO VARCHAR(15)
AS
BEGIN
    -- Insert the provided values into the CUSTOMER table
    INSERT INTO CUSTOMER (
        CUST_CODE, 
        CUST_NAME, 
        CUST_CITY, 
        WORKING_AREA, 
        CUST_COUNTRY, 
        GRADE, 
        OPENING_AMT, 
        RECEIVE_AMT, 
        PAYMENT_AMT, 
        OUTSTANDING_AMT, 
        PHONE_NO
    )
    VALUES (
        @CUST_CODE, 
        @CUST_NAME, 
        @CUST_CITY, 
        @WORKING_AREA, 
        @CUST_COUNTRY, 
        @GRADE, 
        @OPENING_AMT, 
        @RECEIVE_AMT, 
        @PAYMENT_AMT, 
        @OUTSTANDING_AMT, 
        @PHONE_NO
    );
END;

-- Execute the procedure to insert a new customer record
EXEC InsertCustomer 
    @CUST_CODE = 'C00222', 
    @CUST_NAME = 'JAYUSH GINOYA', 
    @CUST_CITY = 'JAMANGAR', 
    @WORKING_AREA = 'Manhattan', 
    @CUST_COUNTRY = 'USA', 
    @GRADE = 2, 
    @OPENING_AMT = 500.00, 
    @RECEIVE_AMT = 300.00, 
    @PAYMENT_AMT = 200.00, 
    @OUTSTANDING_AMT = 100.00, 
    @PHONE_NO = '555-1234';

-- View all customer records again to confirm the insertion
EXEC CUSTOMER_SELECTALL;

---------------------------------------------------------------------

-- Procedure to delete a customer record from the CUSTOMER table

-- The procedure takes a single parameter @CUST_CODE to identify which customer to delete.
CREATE PROCEDURE DeleteCustomer
    @CUST_CODE VARCHAR(6)
AS
BEGIN
    -- Check if the customer exists before attempting to delete
    IF EXISTS (
        SELECT 1 FROM CUSTOMER WHERE CUST_CODE = @CUST_CODE
    )
    BEGIN
        -- If the customer exists, delete the record
        DELETE FROM CUSTOMER
        WHERE CUST_CODE = @CUST_CODE;
        
        -- Print a success message
        PRINT 'Customer deleted successfully.';
    END
    ELSE
    BEGIN
        -- If the customer does not exist, raise an error
        RAISERROR ('Customer code does not exist.', 16, 1);
    END
END;

-- Execute the procedure to delete a customer with the specified CUST_CODE
EXEC DeleteCustomer @CUST_CODE = 'C00222';

---------------------------------------------------------------------

-- Procedure to update a customer record in the CUSTOMER table

-- The procedure takes multiple parameters, but each is optional (default is NULL).
-- Only non-NULL parameters will be used to update the corresponding columns.
CREATE PROCEDURE UpdateCustomer
    @CUST_CODE VARCHAR(10),
    @CUST_NAME VARCHAR(50) = NULL,
    @CUST_CITY VARCHAR(50) = NULL,
    @WORKING_AREA VARCHAR(50) = NULL,
    @CUST_COUNTRY VARCHAR(50) = NULL,
    @GRADE INT = NULL,
    @OPENING_AMT DECIMAL(18, 2) = NULL,
    @RECEIVE_AMT DECIMAL(18, 2) = NULL,
    @PAYMENT_AMT DECIMAL(18, 2) = NULL,
    @OUTSTANDING_AMT DECIMAL(18, 2) = NULL,
    @PHONE_NO VARCHAR(15) = NULL
AS
BEGIN
    -- Check if the customer exists before attempting to update
    IF EXISTS (
        SELECT 1 FROM dbo.CUSTOMER WHERE CUST_CODE = @CUST_CODE
    )
    BEGIN
        -- If the customer exists, update the relevant columns
        UPDATE dbo.CUSTOMER
        SET 
            CUST_NAME = ISNULL(@CUST_NAME, CUST_NAME),
            CUST_CITY = ISNULL(@CUST_CITY, CUST_CITY),
            WORKING_AREA = ISNULL(@WORKING_AREA, WORKING_AREA),
            CUST_COUNTRY = ISNULL(@CUST_COUNTRY, CUST_COUNTRY),
            GRADE = ISNULL(@GRADE, GRADE),
            OPENING_AMT = ISNULL(@OPENING_AMT, OPENING_AMT),
            RECEIVE_AMT = ISNULL(@RECEIVE_AMT, RECEIVE_AMT),
            PAYMENT_AMT = ISNULL(@PAYMENT_AMT, PAYMENT_AMT),
            OUTSTANDING_AMT = ISNULL(@OUTSTANDING_AMT, OUTSTANDING_AMT),
            PHONE_NO = ISNULL(@PHONE_NO, PHONE_NO)
        WHERE CUST_CODE = @CUST_CODE;
        
        -- Print a success message
        PRINT 'Customer updated successfully.';
    END
    ELSE
    BEGIN
        -- If the customer does not exist, raise an error
        RAISERROR ('Customer code does not exist.', 16, 1);
    END
END;

-- Execute the procedure to update a customer's details
EXEC UpdateCustomer 
    @CUST_CODE = 'C00002', 
    @CUST_NAME = 'DEEP', 
    @CUST_CITY = 'RAJLOT',
    @PHONE_NO = '555-5678';
