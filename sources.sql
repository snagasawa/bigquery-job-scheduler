CREATE SCHEMA IF NOT EXISTS `project.sources`;

CREATE OR REPLACE TABLE `project.sources.users` (
  id INT64 NOT NULL,
  name STRING NOT NULL
);

CREATE OR REPLACE TABLE `project.sources.favorite_shops` (
  users_id INT64 NOT NULL,
  shops_id INT64 NOT NULL
);

CREATE OR REPLACE TABLE `project.sources.shops` (
  id INT64 NOT NULL,
  name STRING NOT NULL
);

CREATE OR REPLACE TABLE `project.sources.shop_goods` (
  shops_id INT64 NOT NULL,
  goods_id INT64 NOT NULL
);

CREATE OR REPLACE TABLE `project.sources.goods` (
  id INT64 NOT NULL,
  name STRING NOT NULL
);

CREATE OR REPLACE TABLE `project.sources.stocks` (
  id INT64 NOT NULL,
  goods_id INT64 NOT NULL,
  quantity INT64 NOT NULL,
);

CREATE OR REPLACE TABLE `project.sources.discounts` (
  id INT64 NOT NULL,
  goods_id INT64 NOT NULL,
  rate INT64 NOT NULL,
);

INSERT INTO `project.sources.users`
(id, name)
VALUES
(1, "user1"),
(2, "user2"),
(3, "user3"),
(4, "user4"),
(5, "user5");

INSERT INTO `project.sources.favorite_shops`
(users_id, shops_id)
VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 2);

INSERT INTO `project.sources.shops`
(id, name)
VALUES
(1, "shop1"),
(2, "shop2"),
(3, "shop3");

INSERT INTO `project.sources.shop_goods`
(shops_id, goods_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 3),
(2, 4),
(3, 5);

INSERT INTO `project.sources.goods`
(id, name)
VALUES
(1, "good1"),
(2, "good2"),
(3, "good3");

INSERT INTO `project.sources.stocks`
(id, goods_id, quantity)
VALUES
(1, 1, 20),
(2, 2, 30),
(3, 3, 0),
(4, 4, 5);

INSERT INTO `project.sources.discounts`
(id, goods_id, rate)
VALUES
(1, 1, 30),
(2, 2, 20),
(3, 3, 25),
(4, 4, 10);
