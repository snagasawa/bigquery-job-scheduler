SELECT
  favorite_shops.users_id
  , favorite_shops.shops_id
FROM
  `project.sources.favorite_shops` AS favorite_shops
  INNER JOIN `project.sources.users` AS users
    ON favorite_shops.users_id = users.id
  INNER JOIN `project.sources.shops` AS shops
    ON favorite_shops.users_id = users.id;
