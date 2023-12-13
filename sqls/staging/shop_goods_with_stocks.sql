SELECT
  shop_goods.shops_id
  , shop_goods.goods_id
FROM
  `project.staging.shop_goods` AS shop_goods
  INNER JOIN `project.sources.stocks` AS stocks
    ON shop_goods.goods_id = stocks.goods_id
WHERE
  stocks.quantity > 0;
