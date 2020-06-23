CREATE FUNCTION calculate_total_price_from_orders_group(@group_id int)
RETURNS int
AS

BEGIN
	DECLARE @sum int;
	 WITH Recursive (row_id, parent_id, customer)
	AS
	(

		SELECT row_id, parent_id, customer
		FROM stack.dbo.Orders o
		WHERE o.row_id = @group_id
		UNION ALL
		SELECT o.row_id, o.parent_id, o.customer
		FROM stack.dbo.Orders o
			JOIN Recursive r ON o.parent_id = r.row_id
	)

	SELECT @sum = SUM(price)
	FROM Recursive r
	LEFT JOIN OrderItems on r.row_id = OrderItems.order_id
	RETURN @sum;
END;