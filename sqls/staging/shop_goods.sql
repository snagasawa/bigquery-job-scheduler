SELECT
  shop_goods.shops_id
  , shop_goods.goods_id
FROM
  `project.sources.shop_goods` AS shop_goods
  INNER JOIN `project.sources.shops` AS shops
    ON shop_goods.shops_id = shops.id
  INNER JOIN `project.sources.goods` AS goods
    ON shop_goods.goods_id = goods.id;
