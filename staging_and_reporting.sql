CREATE SCHEMA IF NOT EXISTS `project.staging`;
CREATE SCHEMA IF NOT EXISTS `project.reporting`;

CREATE OR REPLACE TABLE `project.staging.favorite_shops` AS
SELECT
  favorite_shops.users_id
  , favorite_shops.shops_id
FROM
  `project.sources.favorite_shops` AS favorite_shops
  INNER JOIN `project.sources.users` AS users
    ON favorite_shops.users_id = users.id
  INNER JOIN `project.sources.shops` AS shops
    ON favorite_shops.users_id = users.id;

CREATE OR REPLACE TABLE `project.staging.shop_goods` AS
SELECT
  shop_goods.shops_id
  , shop_goods.goods_id
FROM
  `project.sources.shop_goods` AS shop_goods
  INNER JOIN `project.sources.shops` AS shops
    ON shop_goods.shops_id = shops.id
  INNER JOIN `project.sources.goods` AS goods
    ON shop_goods.goods_id = goods.id;

CREATE OR REPLACE TABLE `project.staging.shop_goods_with_stocks` AS
SELECT
  shop_goods.shops_id
  , shop_goods.goods_id
FROM
  `project.staging.shop_goods` AS shop_goods
  INNER JOIN `project.sources.stocks` AS stocks
    ON shop_goods.goods_id = stocks.goods_id
WHERE
  stocks.quantity > 0;

CREATE OR REPLACE TABLE `project.staging.distount_goods` AS
SELECT
  shop_goods_with_stocks.shops_id
  , discounts.goods_id
  , discounts.rate
FROM
  `project.sources.discounts` AS discounts
  INNER JOIN `project.staging.shop_goods_with_stocks` AS shop_goods_with_stocks
    ON discounts.goods_id = shop_goods_with_stocks.goods_id
WHERE
  discounts.rate >= 20;

CREATE OR REPLACE TABLE `project.reporting.favorite_distount_goods` AS
SELECT DISTINCT
  favorite_shops.users_id
  , favorite_shops.shops_id
  , distount_goods.goods_id
  , distount_goods.rate AS discount_rate
FROM
  `project.staging.favorite_shops` AS favorite_shops
  INNER JOIN `project.staging.distount_goods` AS distount_goods
    ON favorite_shops.shops_id = distount_goods.shops_id;
