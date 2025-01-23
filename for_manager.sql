-- x 1. Создать базу данных northwind
-- x 2. Исполнить этот запрос https://github.com/pthom/northwind_psql/blob/master/northwind.sql
-- x 3. Необходимо составить отчет для менеджеров (отправить ссылку на гитхаб с запросами):

-- Используемые таблицы:
-- orders - заказы
-- order_details - детали заказа 
-- products - продукты
-- employees - сотрудники

-- x 3.1. Посчитать количество заказов за все время. Смотри таблицу orders. Вывод: количество заказов.

SELECT *
FROM orders;

SELECT
	COUNT(*) AS "Количество всех заказов"
FROM orders;

-- x 3.2. Посчитать сумму денег по всем заказам за все время (учитывая скидки).
-- Смотри таблицу order_details. Вывод: id заказа, итоговый чек (сумма стоимостей всех продуктов со скидкой)

SELECT *
FROM order_details;

SELECT
	COUNT(DISTINCT order_id) AS "Количество неповторяющихся заказов"
FROM order_details;

SELECT 
	order_id AS "Номер заказа",
	SUM(quantity*(unit_price-unit_price*discount)) AS "Итоговая сумма со скидкой"
FROM order_details
GROUP BY order_id
ORDER BY order_id ASC;

-- 3.3. Показать сколько сотрудников работает в каждом городе. Смотри таблицу employee.
-- Вывод: наименование города и количество сотрудников

SELECT *
FROM employees;

SELECT
	city AS "Город",
	COUNT(city) AS "Количество сотрудников"
FROM employees
GROUP BY city
ORDER BY "Количество сотрудников" DESC;

-- 3.4. Показать фио сотрудника (одна колонка) и сумму всех его заказов 

SELECT *
FROM employees;

SELECT *
FROM orders;

SELECT
	e.title_of_courtesy || ' ' ||
	e.last_name || ' ' ||
	e.first_name AS "Полное имя сотрудника",
	sum_order AS "Количество принятых заказов"
FROM
(
	SELECT
		COUNT(order_id) AS sum_order,
		employee_id
	FROM orders
	GROUP BY employee_id
) o INNER JOIN employees e ON e.employee_id = o.employee_id
ORDER BY sum_order DESC;
	

-- 3.5. Показать перечень товаров от самых продаваемых до самых непродаваемых (в штуках).
-- - Вывести наименование продукта и количество проданных штук.

SELECT *
FROM products;

