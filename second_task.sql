/*markdown
# Task 2
*/

/*markdown
### Part 1 (singleSales)
*/

/*markdown
**1.** Рассчитать выручку компании в разрезе: Год – Месяц – Выручка компании. Представленные данные отсортировать: Год, Месяц
*/

SELECT TOP(5)
    companyName,
    YEAR(dateId) AS год,
    MONTH(dateId) AS месяц,
    SUM(salesRub) AS выручка
FROM
    distributor.singleSales
GROUP BY
    companyName,
    YEAR(dateId),
    MONTH(dateId)
ORDER BY
    YEAR(dateId),
    MONTH(dateId);

/*markdown
**2.** Рассчитать выручку компании в разрезе: Дата начало месяца – Выручка компании. Представление данных отсортировать: Дата начало месяца. В чем ключевое отличие от задачи №1?
*/

SELECT TOP(5)
    companyName,
    YEAR(dateId) AS год,
    MONTH(dateId) AS месяц,
    SUM(salesRub) AS выручка
FROM
    distributor.singleSales
WHERE
    DAY(dateId) = 1
GROUP BY
    companyName,
    YEAR(dateId),
    MONTH(dateId)
ORDER BY
    YEAR(dateId),
    MONTH(dateId);

/*markdown
**3.** Для каждой компании рассчитать среднее время между покупками, отдельно показать результат в днях и в месяцах.
*/

WITH temp(company, mn, mx, num) AS (
    SELECT
        companyName,
        min(dateId),
        max(dateId),
        count(distinct checkId)
    FROM
        distributor.singleSales
    WHERE
        companyName IS NOT NULL
    GROUP BY
        companyName
)
SELECT TOP(5)
    company,
    (datediff(month, mn, mx) / (num - 1)) AS 'months',
    (datediff(day, mn, mx) / (num - 1)) AS 'days'
FROM
    temp
where
    num - 1 != 0
ORDER BY
    months desc,
    days desc

/*markdown
**4.** Вывести результат задачи №2 только для 2013 года с наложением на столбец «Дата начало месяц» формат месяц. Т. е. я ожидаю увидеть в нем не даты, а январь, февраль, март и т. д.
*/

SELECT TOP(5)
    companyName,
    DateName(
        month,
        DateAdd(
            month,
            month(dateId) - 1,
            '1900-01-01'
        )
    ),
    SUM(salesRub) AS 'sales'
FROM
    distributor.singleSales
WHERE
    DAY(dateId) = 1
GROUP BY
    companyName,
    MONTH(dateId)
ORDER BY
    MONTH(dateId);

/*markdown
**5.** Разделить все компании на три сегмента:
- Очень давно не покупали – не было покупок более 365 дней от текущей даты
- Давно не покупали – не было покупок более 180 дней от текущей даты
- Не покупали – не было покупок более 90 дней от текущей даты
Текущею дату задать следующим образом: система должна брать существующею сегодня дату и смещать ее на 8 лет назад.
*/

DECLARE @start datetime;
SET @start = (
    SELECT
        DateAdd(
            year,
            -10,
            GETDATE()
        )
);
DECLARE @start365 datetime;
SET @start365 = (
    SELECT
        DateAdd(
            day,
            -365,
            @start
        )
);
DECLARE @start180 datetime;
SET @start180 = (
    SELECT
        DateAdd(
            day,
            -180,
            @start
        )
);
DECLARE @start90 datetime;
SET @start90 = (
    SELECT
        DateAdd(
            day,
            -90,
            @start
        )
);
WITH temp(company, mx) AS (
    SELECT
        companyName,
        max(dateId)
    FROM
        distributor.singleSales
    WHERE
        dateId < @start
    GROUP BY
        companyName
)
SELECT TOP(10)
    company,
    iif(
        (mx < @start365),
        'category 1',
        iif(
            (mx < @start180),
            'category 2',
            iif(
                (mx < @start90),
                'category 3',
                'They bought recently.'
            )
        )
    ) AS 'category'
FROM
    temp

/*markdown
**6.** Рассчитать выручку компании в разрезе: Год – Квартал – Выручка компании. Представленные данные отсортировать: Год, Квартал.
*/

SELECT TOP(5)
    companyName,
    YEAR(dateId) AS 'year',
    DATEPART(QUARTER, dateId) AS 'q',
    SUM(salesRub) AS 'sales'
FROM
    distributor.singleSales
GROUP BY
    companyName,
    YEAR(dateId),
    DATEPART(QUARTER, dateId)
ORDER BY
    YEAR(dateId),
    DATEPART(QUARTER, dateId)

/*markdown
**7.** Необходимо проверить существование сезонной выручки внутри недели, для этого необходимо рассчитать выручку компании в разрезе: Год – День Недели – выручка компании. Представленные данные отсортировать: Год, день недели.
*/

SELECT TOP(5)
    companyName,
    YEAR(dateId) AS 'year',
    DATEPART(weekday, dateId) AS 'day',
    SUM(salesRub) AS 'sales'
FROM
    distributor.singleSales
GROUP BY
    companyName,
    YEAR(dateId),
    DATEPART(weekday, dateId)
ORDER BY
    YEAR(dateId),
    DATEPART(weekday, dateId)

/*markdown
**8.** Найдите все компании, у которых в наименование есть «ООО», без учета регистра.
*/

SELECT TOP(5)
    companyName
FROM
    distributor.singleSales
WHERE
    lower(companyName) like '%ооо%'
    -- OR companyName like '%ооо%'

/*markdown
**9.** Найдите все компании, у которых в наименование в начале стоит «ООО», без учета регистра и пробелов вначале.
*/

SELECT
    'No regex support in t-sql'

/*markdown
**10.** Необходимо разделить ФИ, что записаны в столбеце «fullName» на три столбца, выделив отдельно фамилию, имя и фамилия И.
*/

SELECT
    DISTINCT TOP(5) fullname,
    SUBSTRING(
        fullname,
        1,
        CHARINDEX(' ', fullname) - 1
    ) AS 'surname',
    SUBSTRING(
        fullname,
        CHARINDEX(' ', fullname) + 1,
        LEN(fullname) - CHARINDEX(' ', fullname)
    ) AS 'name',
    SUBSTRING(
        fullname,
        1,
        CHARINDEX(' ', fullname) + 1
    ) + '.' AS 'surnameWithInitial'
FROM
    distributor.singleSales
WHERE
    fullname IS NOT Null

/*markdown
### Part 2 (sales)
*/

/*markdown
**1.** Рассчитать выручку компании в разрезе: Год – Месяц – Филиал – Выручка компании. Представленные данные отсортировать: Филиал, Год, Месяц.
*/

SELECT TOP(5)
    branchName,
    year(dateId) AS 'year',
    month(dateId) AS 'month',
    sum(salesRub)
FROM
    distributor.sales
INNER JOIN
    distributor.branch
    ON branch.branchId = sales.branchId
GROUP BY
    year(dateId),
    month(dateId),
    branchName
ORDER BY
    branchName,
    'year',
    'month'

/*markdown
**2.** Рассчитать выручку компании в разрезе: Филиал - Дата начало месяца – Выручка компании. Представление данных отсортировать: Филиал, Дата начало месяца.
*/

SELECT
    branchId AS "Филиал",
    dateId AS "Первое число месяца",
    sum(salesRub) AS "Выручка"
FROM
    distributor.sales
WHERE
    day(dateId) = 01
    AND branchId IS NOT Null
GROUP BY
    branchId,
    dateId
ORDER BY
    branchId,
    dateId

/*markdown
**3.** Рассчитать выручку компании в разрезе: Филиал – Дата начало месяца – Товарная категория – выручка компании. Представление данных отсортировать: Филиал, Дата начало месяца, Товарная категория.
*/

SELECT
    branchName AS "Филиал",
    dateId AS "Первое число месяца",
    sum(salesRub) AS "Выручка",
    category
FROM
    distributor.singleSales
WHERE
    DAY(dateId) = 01
    AND branchName IS NOT Null
    AND Category IS NOT Null
GROUP BY
    branchName,
    dateId,
    category
ORDER BY
    branchName,
    dateId,
    category

/*markdown
**4.** Рассчитать выручку компании в разрезе: Филиал – Дата начало месяца – Бренд – выручка компании. Представление данных отсортировать: Филиал, Дата начало месяца, Бренд.
*/

SELECT
    branchName AS "Филиал",
    dateId AS "Первое число месяца",
    sum(salesRub) AS "Выручка",
    brand
FROM
    distributor.singleSales
WHERE
    DAY(dateId) = 01
    AND branchName IS NOT Null
    AND brand IS NOT Null
GROUP BY
    branchName,
    dateId,
    brand
ORDER BY
    branchName,
    dateId,
    brand

/*markdown
**5.** Написать запрос, сравнивающий общую сумму задачи №4 и Задачи№2. Объяснить расхождения, если они есть. Написать запрос, выявляющий все транзакции влияющие на расхождения выручки в задаче №4.
*/

SELECT DISTINCT TOP(3)
    brand AS "Бренд",
    SUM(salesRub) AS "Наибольший вклад"
FROM
    distributor.singleSales
GROUP BY
    brand
ORDER BY
    "Наибольший вклад" DESC

/*markdown
**6.** Определить топ 3 бренда, дающий наибольший вклад в выручку компании за 2013 год.
*/

SELECT DISTINCT TOP(3)
    brand AS "Бренд",
    SUM(salesRub) AS "Наибольший вклад"
FROM
    distributor.singleSales
GROUP BY
    brand
ORDER BY
    "Наибольший вклад" DESC

/*markdown
**7.** Рассчитать выручку компании в разрезе: Менеджер – Бренд – выручка компании. Представленные данные отсортировать: Менеджер, Бренд.
*/

SELECT
    fullname AS "Менеджер",
    brand AS "Бренд",
    SUM(salesRub) AS "Выручка"
FROM
    distributor.singleSales
WHERE
    fullname IS NOT Null
    AND brand IS NOT Null
GROUP BY
    fullname,
    brand
ORDER BY
    fullname,
    brand

/*markdown
**8.** Рассчитать кол-во компаний приходятся на менеджера в течение каждого года. Фактически я ожидаю увидеть таблицу: Год – Менеджер – Кол-во компаний.
*/

SELECT
    DISTINCT fullname AS "Менеджер",
    YEAR(dateId) AS "Год",
    count(companyName) AS "Кол-во компаний"
FROM
    distributor.singleSales
WHERE
    fullname IS NOT null
GROUP BY
    dateId,
    fullname,
    companyName

/*markdown
**9.** Рассчитать транзакционную выручку компании по годам. Незабудке, что себестоимость в разных валютах и надо использовать курс валюты для пересчета. Если себестоимость представлена и в рублях, и в долларах, то у рублей приоритет.
*/

SELECT
    YEAR(dateId) AS "Год",
    companyName AS "Компания",
    (sum(salesRub) - basePricePurchase) AS "Выручка"
FROM
    distributor.sales,
    distributor.ddp
WHERE
    companyName IS NOT Null
GROUP BY
    companyName,
    dateId

/*markdown
**11.** В таблицу: distributor.remains представлена информация об остатках, как : Филиал – Артикул товара – Дата – Остаток – СвободныйОстаток. Особенность заполнения данной таблицы, что если остаток на какую-то дату нулевой (для товара и филиала), то в таблицу он не заноситься, например: 2020-01-01 – 10шт., 2020-01-02 – 7шт. 2020-01-04 – 15 шт. Необходимо, восстановить пропуски в данной таблицы и дописать пропущенные значения. Из нашего примера: 2020-01-03 – 0 шт. Учтите, что даты складирования товара – филиала своя.
*/

SELECT TOP(10)
    *
FROM
    distributor.remains
WHERE
    remains = 0

/*markdown
**12.** Найти объём неликвидного товара в сравнение со всем товаром в шт. под неликвидом считается товар, который не продавался более 180 дней от текущей даты. Точку отсчета текущей даты взять за 2014-01-01.
*/

DECLARE @start datetime;
SET @start = '2014-01-01';
DECLARE @start180 datetime;
SET @start180 = (
    SELECT
        DateAdd(
            day,
            -180,
            @start
        )
);
WITH temp(itemId, mostRecentDateWhenItemWasSold) AS (
    SELECT
        itemId,
        max(dateId)
    FROM
        distributor.sales
    WHERE
        dateId < @start
    GROUP BY
        itemId
),
temp2(itemId, liquidity) AS (
    SELECT
        itemId,
        iif(
            mostRecentDateWhenItemWasSold < @start180,
            'non liquid',
            'liquid'
        )
    FROM
        temp
)
SELECT
    count(*) AS 'Number of all items',
    (
        SELECT
            count(*)
        FROM
            temp2
        WHERE
            liquidity = 'non liquid'
    ) AS 'Number of non-liquid items'
FROM
    temp

/*markdown
**13.** Определить топ 3 лучших товаров по выручки для каждого Бренда без учета времени, т. е. за всю историю работы компании.
*/

SELECT TOP(3)
    brand,
    itemName,
    sum(salesRub)
FROM
    distributor.sales
INNER JOIN
    distributor.item
    ON (sales.itemId = item.itemId)
GROUP BY
    brand,
    itemName
ORDER BY
    sum(salesRub) desc

/*markdown
**14.** Определить топ 3 лучших товаров по выручке для каждого бренда с учетом временного интервала год.
*/

SELECT TOP(3)
    brand,
    left(itemName, 40) AS 'item',
    sum(salesRub) AS 'sum',
    year(dateID) AS 'year'
FROM
    distributor.sales
INNER JOIN
    distributor.item
    ON (sales.itemId = item.itemId)
GROUP BY
    brand,
    itemName,
    year(dateId)
ORDER BY
    'sum' desc

/*markdown
**15.** Определить долю вклада Топ 3 брендов в выручку компании без учета времени, т. е. за всю историю работы компании.
*/

WITH temp(brand, brandSales, brandRank) AS (
    SELECT
        brand,
        sum(salesRub),
        RANK() OVER (ORDER BY sum(salesRub) DESC) brandRank
    FROM
        distributor.sales
    INNER JOIN
        distributor.item
        ON (sales.itemId = item.itemId)
    WHERE
        companyId = 7322
    GROUP BY
        brand
)
SELECT
    sum(brandSales) / (
        SELECT
            sum(brandSales)
        FROM
            temp
    )
FROM
    temp
WHERE
    brandRank <= 3

/*markdown
**16.** Определить долю вклада Топ 3 брендов в выручку компании для каждого года и месяца.
*/

WITH topThreeBrands(year, month, topThreeSum) AS (
    SELECT
        temp.year,
        temp.month,
        sum(temp.sum)
    FROM
        (
            SELECT
                year(dateId) AS 'year',
                month(dateId) AS 'month',
                brand,
                sum(salesRub) AS 'sum',
                row_number() OVER (
                    partition by
                        year(dateId),
                        month(dateId)
                    ORDER BY
                        sum(salesRub) DESC
                ) AS 'brandRank'
            FROM
                distributor.sales
            INNER JOIN
                distributor.item ON (sales.itemId = item.itemId)
            WHERE
                companyId = 7322
            GROUP BY
                year(dateId),
                month(dateId),
                brand
        ) AS temp
    WHERE
        temp.brandRank <= 3
    GROUP BY
        temp.year,
        temp.month
),
allBrands(year, month, allSales) AS (
    SELECT
        year(dateId),
        month(dateId),
        sum(salesRub)
    FROM
        distributor.sales
    INNER JOIN
        distributor.item ON (sales.itemId = item.itemId)
    WHERE
        companyId = 7322
    GROUP BY
        year(dateId),
        month(dateId)
)
SELECT TOP(10)
    allBrands.year,
    allBrands.month,
    allSales,
    topThreeSum,
    topThreeSum / allSales AS ratio
FROM
    allBrands
INNER JOIN
    topThreeBrands ON (
        allBrands.year = topThreeBrands.year AND
        allBrands.month = topThreeBrands.month
    )
WHERE
    allSales != 0

/*markdown
**18.** Вывести топ 2 лучших менеджеров для каждого филиала в динамике. Под динамикой я хочу увидеть лучших менеджеров для каждого месяца – года. И отдельно только по годам.
*/

-- WITH base(year, month, managerRank) AS (
--     SELECT
--         year(dateId) AS 'year',
--         month(dateId) AS 'month',
--         row_number() OVER (
--             partition by
--                 year(dateId),
--                 month(dateId)
--             ORDER BY
--                 sum(salesRub) DESC
--         ) AS 'managerRank'
--     FROM
--         distributor.sales
--     INNER JOIN
--         distributor.salesManager
--         ON sales.salesManagerId = salesManager.salesManagerId
--     GROUP BY
--         year(dateId),
--         month(dateId)
-- )
-- SELECT TOP(10)
--     base.year,
--     base.month,
--     base.managerRank
-- FROM
--     base
-- WHERE
--     base.managerRank <= 2

/*markdown
**19.** Вывести среднюю месячную динамику продаж, по выручке за предыдущие три месяца по менеджерам, для периода год – месяц и отдельно «Дата начало месяца». Т. е. если сейчас 2013-01-01, то я хочу видеть среднюю выручку по менеджерам за 2012-10-01, 2012-11-01,2012-12-01.
*/

SELECT TOP(10)
    s.salesManagerId,
    format(s.dateId, 'MM.yyyy'),
    sum(s.salesRub) AS month_revenue
FROM
    distributor.sales s
INNER JOIN
    distributor.salesManager sM
    ON s.salesManagerId = sM.salesManagerId
GROUP BY
    s.salesManagerId,
    format(s.dateId, 'MM.yyyy')
ORDER BY
    s.salesManagerId,
    format(s.dateId, 'MM.yyyy');

/*markdown
**20.** Вывести среднюю месячную динамику продаж, по среднему чеку за предыдущие три месяца по менеджерам, для периода год – месяц и отдельно «Дата начало месяца». Т. е. если сейчас 2013-01-01 то я хочу видеть средний чек по менеджерам за 2012-10-01, 2012-11-01,2012-12-01
*/

WITH temp AS (
    SELECT TOP(20)
        s.salesManagerId AS sm_id,
        format(s.dateId, 'MM.yyyy') AS my_date,
        avg(s.salesRub) AS month_avg_price
    FROM
        distributor.sales s
    INNER JOIN
        distributor.salesManager sM
        ON s.salesManagerId = sM.salesManagerId
    GROUP BY
        s.salesManagerId, format(s.dateId, 'MM.yyyy')
    ORDER BY
        s.salesManagerId, format(s.dateId, 'MM.yyyy')
)
SELECT
    sm_id,
    my_date,
    month_avg_price,
    avg(month_avg_price) OVER(
        partition by
            sm_id
        ORDER BY
            my_date rows between 3 preceding AND current row
    ) AS revenue
FROM
    temp
GROUP BY
    sm_id,
    my_date,
    month_avg_price
ORDER BY
    sm_id, my_date,
    month_avg_price

/*markdown
**23.** Рассчитать долю загрузки складов для каждого года – месяца.
*/

/*markdown
**Решение.** Будем работать так: sum(remains of 1 branchiD)/size of branch for every branch (GROUP BY year - month)
*/

SELECT
    cast(sum(remains * ai.volume) AS float) / sizeBranch AS dolya,
    b.branchId
FROM
    distributor.remains r
INNER JOIN
    distributor.branch b
    ON r.branchId=b.branchId
INNER JOIN
    distributor.attributesItem ai
    ON r.itemId=ai.itemId
WHERE
    ai.volume IS NOT null
GROUP BY
    year(dateId),
    month(dateId),
    b.branchiD, sizeBranch;

/*markdown
**24.** Рассчитайте стоимость складских запасов на основе себестоимости товара на каждом филиале для каждого разреза год – месяц (или дата начало месяца).
  Рассчитать так же и на основе альтернативной себестоимости, стоимость складских запасов. (basePrice из таблицы DDP)
*/

/*markdown
**Решение.** Думаю, что стоимость складских запасов в данном случае = себестоимость(DDP) * количество товара boxPacking (в разрезе, да) для каждого филиала.
  А во втором случае все то же самое, но надо юзать basePrice и просуммировать для всех филиалов
  будем  юзать distributor.attributesItem INNER JOIN distributor.ddp ON itemId
*/

SELECT 
    count(itemId),
    count(distinct itemId)
FROM
    distributor.attributesItem

SELECT top(100)
    *
FROM
    distributor.ddp


SELECT
    count(*)
    -- d.DDP * ai.boxPacking AS sebestoimost
FROM
    distributor.attributesItem ai
INNER JOIN
    distributor.ddp d
    ON d.itemId=ai.itemId
WHERE
    ai.boxPacking IS NOT NULL
    AND d.DDP IS NOT NULL
-- GROUP BY
--     yearId,
--     monthId,
--     d.DDP,
--     ai.boxPacking

WITH temp(sebestoimosti)  AS (
    SELECT
        d.basePrice * ai.boxPacking AS sebestoimost
    FROM
        distributor.attributesItem ai
    INNER JOIN
        distributor.ddp d
        ON d.itemId=ai.itemId
    WHERE
        ai.boxPacking IS NOT NULL
        AND d.DDP IS NOT NULL
    GROUP BY
        yearId,
        monthId,
        d.basePrice,
        ai.boxPacking
)
SELECT sum(sebestoimosti) FROM temp;

/*markdown
**25.** Рассчитать коэффициенты месячных сезонностей отдельно по штукам и деньгам для категории: Обои
  Пояснение: посчитать продажи в штуках(рублях) в месяц/ продажи в штуках(рублях) за год
Будем делать рассчеты на основе таблицы singleSales(потому что там все что нужно:) ) из схемы distributor, db demo
*/

DECLARE @year_sales AS INT = (
    SELECT sum(sales)
    FROM distributor.singleSales ss
    WHERE category=N'Обои'
)
DECLARE @year_sales_rub AS INT = (
    SELECT sum(salesRub)
    FROM distributor.singleSales ss
    WHERE category=N'Обои'
)
PRINT @year_sales; -- 2708989
PRINT @year_sales_rub; -- 1882817500
SELECT
    sum(sales) / @year_sales AS month_koef_in_units,
    sum(salesRub) / @year_sales_rub AS month_koef_in_rub
FROM
    distributor.singleSales
WHERE
    category=N'Обои'
GROUP BY
    year(distributor.singleSales.dateId),
    month(distributor.singleSales.dateId);

/*markdown
**26.** Вывести долю занимающих в продажах, различных фабрик.
  Если в товаре фабрика не указана, сделать замену на «иные» и так же вывести в долях.
  Нужно вывести как за весь период, так и в разрезе Год – Месяц (или дата начало месяца)
*/

-- For the whole time
WITH doli(dolya_item, fabrica) AS (
    SELECT
        sum(quantity) AS dolya_item,
        fabrica
    FROM
        (
            SELECT
                s.itemId,
                count(s.itemId) AS quantity,
                fabrica
            FROM
                distributor.item i
            INNER JOIN
                distributor.sales s ON i.itemId = s.itemId
            GROUP BY
                fabrica,
                s.itemId
        ) AS tmp
    GROUP BY fabrica
)
SELECT TOP(10)
    cast(dolya_item AS float) / cast(
        (
            SELECT
                sum(dolya_item)
            FROM
                doli
        ) AS float
    ) AS dolya,
    fabrica
FROM
    doli
GROUP BY
    dolya_item,
    fabrica

-- This is for Year/Month
WITH doli(dolya_item, fabrica, year, month) AS (
    SELECT
        sum(quantity) AS dolya_item,
        fabrica,
        year,
        month
    FROM
        (
            SELECT
                year(s.dateId) AS year,
                month(s.dateId) AS month,
                s.itemId,
                count(s.itemId) AS quantity,
                fabrica
            FROM
                distributor.item i
            INNER JOIN
                distributor.sales s
                ON i.itemId = s.itemId
            GROUP BY
                year(s.dateId),
                month(s.dateId),
                fabrica,
                s.itemId
        ) AS tmp
    GROUP BY
        year,
        month,
        fabrica
)
SELECT TOP(10)
    cast(dolya_item AS float) / cast(
        (SELECT sum(dolya_item) FROM doli) AS float
    ) AS dolya,
    fabrica
FROM
    doli
GROUP BY
    year,
    month,
    dolya_item,
    fabrica;

/*markdown
**27.**
*/

WITH temp1(month, sales) AS (
    SELECT
        month(distributor.singleSales.dateId) AS month,
        count(distributor.singleSales.itemId)
    FROM
        distributor.singleSales
    INNER JOIN
        distributor.item i
        ON singleSales.itemId = i.itemId
    WHERE
        i.exclusive = 'Да' AND
        singleSales.category = 'Обои'
    GROUP BY
        year(distributor.singleSales.dateId),
        month(distributor.singleSales.dateId)
),
temp2(month, sales) AS (
    SELECT
        month(distributor.singleSales.dateId),
        count(distributor.singleSales.itemId)
    FROM
        distributor.singleSales
    INNER JOIN
        distributor.item i
        ON singleSales.itemId = i.itemId
    WHERE
        singleSales.category = 'Обои'
    GROUP BY
        year(distributor.singleSales.dateId),
        month(distributor.singleSales.dateId)
)
SELECT TOP(5)
    (cast(temp1.sales AS float) / cast(temp2.sales AS float)) AS boom
FROM
    temp1
INNER JOIN
    temp2
    ON temp1.month = temp2.month

/*markdown
*recursive cte's*
*/

WITH cte as (
    SELECT 
        2 AS n
    UNION ALL
    SELECT
        n * 2
    FROM
        cte
    WHERE
        n < 100
)
SELECT
    n
FROM
    cte
OPTION 
    (MAXRECURSION 32767)