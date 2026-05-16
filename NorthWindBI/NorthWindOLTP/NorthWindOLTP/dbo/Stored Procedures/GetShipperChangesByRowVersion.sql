CREATE PROCEDURE dbo.GetShipperChangesByRowVersion
(
    @startRow BIGINT,
    @endRow BIGINT
)
AS
BEGIN

    SELECT
        ShipperID,
        CompanyName,
        Phone,
        rowversion
    FROM Shippers
    WHERE
        rowversion > CONVERT(ROWVERSION, @startRow)
        AND rowversion <= CONVERT(ROWVERSION, @endRow);

END;
