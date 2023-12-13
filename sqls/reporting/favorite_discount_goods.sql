SELECT DISTINCT
  favorite_shops.users_id
  , favorite_shops.shops_id
  , distount_goods.goods_id
  , distount_goods.rate AS discount_rate
FROM
  `project.staging.favorite_shops` AS favorite_shops
  INNER JOIN `project.staging.discount_goods` AS distount_goods
    ON favorite_shops.shops_id = distount_goods.shops_id;
