USE stack;

if object_id('stack.dbo.OrderItems') is not null
   drop table stack.dbo.OrderItems;
go

if object_id('stack.dbo.Orders') is not null
   drop table stack.dbo.Orders;
go

-- Заказы
create table stack.dbo.Orders
(
   row_id int identity not null,
   parent_id int,                         -- row_id родительской группы
   is_group int,                          -- признак того, что запись является
                                          -- группой заказов (1) или заказом (0)
   customer nvarchar(max) not null,       -- наименование заказчика

   constraint PK_Orders
      primary key nonclustered (row_id),
   constraint FK_Orders_Folder 
      foreign key (parent_id) 
      references stack.dbo.Orders(row_id)
      on delete no action
      on update no action
);
go

-- Позиции заказов
create table stack.dbo.OrderItems
(
   row_id int identity not null,
   order_id int not null,                 -- row_id заказа
   name nvarchar(max) not null,           -- наименование позиции
   price int not null,                    -- стоимость позиции в рублях

   constraint PK_OrderItems
      primary key nonclustered (row_id),
   constraint FK_OrderItems_Orders
      foreign key (order_id) 
      references stack.dbo.Orders(row_id)
      on delete cascade
      on update cascade
);
go

insert into stack.dbo.Orders(parent_id, is_group, customer)             -- 1
values (null, 1, N'Все заказы');

   insert into stack.dbo.Orders(parent_id, is_group, customer)          -- 2
   values (1, 1, N'Частные лица');

      insert into stack.dbo.Orders(parent_id, is_group, customer)       -- 3
      values (2, 1, N'Оргтехника');

         insert into stack.dbo.Orders(parent_id, is_group, customer)    -- 4
         values (3, 0, N'Иванов');

         insert into stack.dbo.Orders(parent_id, is_group, customer)    -- 5
         values (3, 0, N'Петров');

      insert into stack.dbo.Orders(parent_id, is_group, customer)       -- 6
      values (2, 1, N'Канцелярия');

         insert into stack.dbo.Orders(parent_id, is_group, customer)    -- 7
         values (6, 0, N'Сидоров');

   insert into stack.dbo.Orders(parent_id, is_group, customer)          -- 8
   values (1, 1, N'Юридические лица');

      insert into stack.dbo.Orders(parent_id, is_group, customer)       -- 9
      values (8, 0, N'ИП Федоров');


insert into stack.dbo.OrderItems(order_id, name, price)
values (4, N'Принтер', 30);
insert into stack.dbo.OrderItems(order_id, name, price)
values (4, N'Копировальный аппарат', 50);
insert into stack.dbo.OrderItems(order_id, name, price)
values (4, N'Факс', 20);


insert into stack.dbo.OrderItems(order_id, name, price)
values (5, N'Принтер', 50);
insert into stack.dbo.OrderItems(order_id, name, price)
values (5, N'Факс', 30);
insert into stack.dbo.OrderItems(order_id, name, price)
values (5, N'Факс', 30);


insert into stack.dbo.OrderItems(order_id, name, price)
values (7, N'Бумага', 2);
insert into stack.dbo.OrderItems(order_id, name, price)
values (7, N'Ручки', 1);


insert into stack.dbo.OrderItems(order_id, name, price)
values (9, N'Кулер', 100);
insert into stack.dbo.OrderItems(order_id, name, price)
values (9, N'Стулья', 70);
insert into stack.dbo.OrderItems(order_id, name, price)
values (9, N'Факс', 20);
go