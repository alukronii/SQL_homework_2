-- x 1. Создать базу данных northwind
-- x 2. Исполнить этот запрос https://github.com/pthom/northwind_psql/blob/master/northwind.sql
-- x 3. Необходимо составить отчет для менеджеров (отправить ссылку на гитхаб с запросами):

-- Используемые таблицы:
-- orders - заказы
-- order_details - детали заказа 
-- products - продукты
-- employees - сотрудники

-- x 3.1. Посчитать количество заказов за все время. Смотри таблицу orders. Вывод: количество заказов.
SELECT
	COUNT(*) AS "Количество всех заказов"
FROM orders;

-- x 3.2. Посчитать сумму денег по всем заказам за все время (учитывая скидки).
-- Смотри таблицу order_details. Вывод: id заказа, итоговый чек (сумма стоимостей всех продуктов со скидкой)
SELECT 
	order_id AS "Номер заказа",
	ROUND(CAST(SUM(quantity * (unit_price - unit_price * discount)) AS NUMERIC), 3) AS "Итоговая сумма со скидкой"
FROM order_details
GROUP BY order_id
ORDER BY "Номер заказа" ASC;

-- x 3.3. Показать сколько сотрудников работает в каждом городе. Смотри таблицу employee.
-- Вывод: наименование города и количество сотрудников
SELECT
	city AS "Город",
	COUNT(city) AS "Количество сотрудников"
FROM employees
GROUP BY city
ORDER BY "Количество сотрудников" DESC;

-- x 3.4. Показать фио сотрудника (одна колонка) и сумму всех его заказов 
SELECT
	e.title_of_courtesy || ' ' ||
	e.last_name || ' ' ||
	e.first_name AS "Полное имя сотрудника",
	ROUND(CAST(SUM(sum_price) AS NUMERIC), 3) AS "Cумма всех заказов сотрудника"
FROM (
	SELECT
		o.order_id,
		employee_id,
		sum_price
	FROM (
		SELECT 
			order_id,
			SUM(quantity * (unit_price - unit_price * discount)) AS sum_price
		FROM order_details
		GROUP BY order_id
	) d INNER JOIN orders o ON o.order_id = d.order_id
) o INNER JOIN employees e ON e.employee_id = o.employee_id
GROUP BY e.employee_id
ORDER BY "Cумма всех заказов сотрудника" DESC;

-- 3.5. Показать перечень товаров от самых продаваемых до самых непродаваемых (в штуках).
-- - Вывести наименование продукта и количество проданных штук.
SELECT
	product_name AS "Наименование товара",
	o.quantity AS "Количество проданного товара"
FROM (
	SELECT
		product_id,
		SUM(quantity) AS quantity
	FROM order_details
	GROUP BY product_id
) o INNER JOIN products p ON p.product_id = o.product_id
ORDER BY "Количество проданного товара" DESC;
