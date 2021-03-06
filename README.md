### Таблица distributor.singleSales: (таблица по продажам)
1. checkId – уникальный номер чека\документа. В рамках одного чека может быть выписано несколько товаров.
2. itemId – уникальный код товара
3. dateId – дата продажи
4. sales – продажи в шт.
5. salesRub – продажи в рублях
6. branchName – наименование филиала, и одновременно город расположения
7. region – регион где находиться филиал
8. sizeBranch – размер склада в м3
9. fullname – полная фамилия и имя менеджера
10. companyName – наименование компании
11. itemName – наименование товара
12. Brand – наименование бренда товара
13. Category – иерархическая группировка товаров, категория самый высокий уровень

### Таблица distributor.attributesItem: (информация о товаре: объем, вес и т.д.)
1. itemId – уникальный код товара
2. storageUnits – единица измерения товара, рул., шт., упаковка и т.д.
3. boxPacking – кол-во единиц товара в коробке, например, 6 – 6 рулонов в упаковке
4. netWeight – вес упаковки
5. volume – объем занимаемый упаковкой от 1 м3

### Таблица distributor.branch: (информация о филиалах)
1. branchId – уникальный номер филиала
2. branchName – наименование филиала, и одновременно город расположения
3. region – регион где находиться филиал
4. sizeBranch – размер склада в м3

### Таблица distributor.company: (информация о компаниях покупающие товар)
1. companyId – уникальный номер компании
2. companyName – наименование компании

### Таблица distributor.currency: (информация о курсе рубля по ЦБ)
1. dateId – дата на которую действовал официальный обменный курс ЦБ
2. currency – сокращенное аббревиатура валюты
3. value – значения обменного курс 1 currency – value рублей

### Таблица distributor.ddp: (информация о себестоимости товара)
1. itemId - уникальный код товара
2. monthId – месяц
3. yearId – год
4. basePricePurchase – средняя себестоимость товара без учета доставки товара до склада
5. DDP – средняя себестоимость товара с учетом доставки до склада
6. currencyPurchase – валюта себестоимости, если за один и тот же период для одного и тоже товара, есть ddp в рублях и долларах, то рубли имеют приоритет. Если валюта не указана, а ddp проставлено, то считаем это рублевые затраты.
7. basePrice – средняя себестоимость товара без учета доставки рассчитанная альтернативным методом. Стоимость доставки можно вычислить из п.4,5,6
8. Currency – валюта себестоимости, если за один и тот же период для одного и тоже товара, есть basePrice в рублях и долларах, то рубли имеют приоритет. Если валюта не указана, а basePrice проставлено, то считаем это рублевые затраты.

### Таблица distributor.item: (информация о товаре) (учесть что itemId в данном справочнике не уникален)
1. itemId – уникальный код товара, уникальность нарушена! Есть повторяющиеся ItemId.
2. itemName – наименование товара
3. headBrand – наименование головного бренда товара
4. Brand – наименование бренда товара
5. Category – иерархическая группировка товаров, категория самый высокий уровень
6. subcategory – иерархическая группировка товаров, на уровень ниже чем category
7. groupItem - иерархическая группировка товаров, на уровень ниже чем subcategory
8. fabrica – наименование фабрики где производиться данный товар
9. collection – к какой коллекции относиться товар, особенно актуально для обоев
10. typeItemId – дополнительный тип товара.
11. subTypeItem – еще один дополнительный тип товара
12. fabricaCountry – страна где расположена фабрика
13. exclusive – общий товар или выпущенный под конкретного дистрибьютора

### Таблица distributor.remains: (информация об остатках)
1. branchId – уникальный номер филиала
2. itemId - уникальный код товара
3. dateId – дата на которую приходиться информация об остатках. Вечер 23-00.
4. Remains – кол-во остатков
5. freeRemains – кол-во свободных остатков. Остатки – информация о резервах.

### Таблица distributor.sales: (информация о продажах)
1. checkId – уникальный номер чека\документа. В рамках одного чека может быть выписано несколько товаров.
2. itemId – уникальный код товара
3. branchId – уникальный номер филиала. Откуда была произведена продажа и отгрузка.
4. salesManagerId – уникальный номер менеджера
5. companyId – уникальный номер компании
6. dateId – дата продажи
7. sales – продажи в шт.
8. salesRub – продажи в рублях

### Таблица distributor.salesManager: (информация о менеджерах)
1. salesManagerId – уникальный номер менеджера
2. surname – фамилия менеджера
3. names – имя менеджера
4. fullname – полная фамилия и имя менеджера

### Таблица distributor.specification: (доп. Информация о спецификациях товара)
1. itemId – уникальный код товара
2. shade – если ли тени в товаре
3. specification1 – спецификация товара
4. detailSpecification1 - детали спецификации товара
5. и т.д. до 7 спецификации, не все могут быть заданы.
