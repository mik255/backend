CREATE SCHEMA IF NOT EXISTS `dart` DEFAULT CHARACTER SET utf8;
USE `dart`;

CREATE TABLE IF NOT EXISTS `dart`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `cnpj` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `is_ativo` TINYINT NULL DEFAULT 1,
  `dt_criacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `dt_autalizacao` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `dart`.`categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `isBlocked` BOOLEAN DEFAULT FALSE,
  `dt_criacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `dt_autalizacao` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `dart`.`stories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `category_id` TINYINT NULL DEFAULT 0,
  `name` VARCHAR(255) NOT NULL,
  `pix` VARCHAR(255) NOT NULL,
  `paymentType` VARCHAR(255) NULL,
  `isBlocked` TINYINT NULL DEFAULT 0,
  `totalPrice` NUMERIC NULL DEFAULT 0,
  `dt_criacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `dt_autalizacao` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

  CREATE TABLE IF NOT EXISTS `dart`.`products` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `urlImg` VARCHAR(255) NOT NULL,
  `price` NUMERIC NULL DEFAULT 0,
  `squerePrice` NUMERIC NULL DEFAULT 0,
  `count` TINYINT NULL DEFAULT 0,
  `stock` TINYINT NULL DEFAULT 0,
  `isBlocked` BOOLEAN DEFAULT FALSE,
  `dt_criacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `dt_autalizacao` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

 CREATE TABLE IF NOT EXISTS `dart`.`story_join_category` (
  story_id int NOT NULL,
  category_id int NOT NULL,
  foreign KEY (story_id) references stories(id) ON DELETE CASCADE,
  foreign KEY (category_id) references categories(id) ON DELETE CASCADE)
ENGINE = InnoDB;

 CREATE TABLE IF NOT EXISTS `dart`.`products_join_stories` (
  product_id int NOT NULL,
  story_id int NOT NULL,
  foreign KEY (story_id) references stories(id) ON DELETE CASCADE,
  foreign KEY (product_id) references products(id) ON DELETE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `dart`.`receipts` (
   PRIMARY KEY (`id`),
  `id` INT NOT NULL AUTO_INCREMENT,
  `observation` VARCHAR(255) NOT NULL,
  `category_id` int NOT NULL,
  `user_id` int NOT NULL,
  `paymentType` VARCHAR(255) NULL,
  `totalPrice` NUMERIC NULL DEFAULT 0,
  `dt_criacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `dt_autalizacao` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    foreign KEY (category_id) references categories(id) ON DELETE CASCADE,
  foreign KEY (user_id) references users(id) ON DELETE CASCADE)
ENGINE = InnoDB;

 CREATE TABLE IF NOT EXISTS `dart`.`receipts_join_stories` (
  receipt_id int NOT NULL,
  story_id int NOT NULL,
  foreign KEY (story_id) references stories(id) ON DELETE CASCADE,
  foreign KEY (receipt_id) references receipts(id) ON DELETE CASCADE)
ENGINE = InnoDB;
