
CREATE FUNCTION select_orders_by_item_name (@name nvarchar(max))
RETURNS TABLE 
AS
RETURN
(
SELECT Orders.row_id, Orders.customer, COUNT(OrderItems.row_id) items_count 
FROM Orders 
LEFT JOIN OrderItems on orders.row_id = orderItems.order_id
WHERE OrderItems.name = @name AND Orders.is_group=0
GROUP BY Orders.row_id, Orders.customer
);

