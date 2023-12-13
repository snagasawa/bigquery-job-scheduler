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
