create database better_ecommerce;
use better_ecommerce;

-- criar tabela cliente
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11),
    CNPJ CHAR(14),
    Adress VARCHAR(30),
    CONSTRAINT check_cpf_cnpj CHECK ((CPF IS NOT NULL AND CNPJ IS NULL) OR (CPF IS NULL AND CNPJ IS NOT NULL)),
    CONSTRAINT unique_cpf_cnpj UNIQUE (CPF, CNPJ)
);

-- criar tabela produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids bool default false,
    Category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    Avaliação float default 0,
    size varchar(10)
);

-- criar tabela pagamentos
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    typePayment ENUM('Boleto', 'Cartão', 'PIX'),
    paymentDate DATE,
    CONSTRAINT fk_payments_orders FOREIGN KEY (idOrder) REFERENCES orders(idPedido)
);

-- criar tabela de pagamentos por cartão
CREATE TABLE card_payments (
    idPayment INT PRIMARY KEY,
    cardNumber VARCHAR(16),
    cardHolderName VARCHAR(255),
    cardExpiryDate DATE,
    cardCVV VARCHAR(4),
    CONSTRAINT fk_card_payments_payments FOREIGN KEY (idPayment) REFERENCES payments(idPayment)
);

-- criar tabela de pagamentos por boleto
CREATE TABLE boleto_payments (
    idPayment INT PRIMARY KEY,
    boletoNumber VARCHAR(50),
    CONSTRAINT fk_boleto_payments_payments FOREIGN KEY (idPayment) REFERENCES payments(idPayment)
);

-- criar tabela de pagamentos por pix
CREATE TABLE pix_payments (
    idPayment INT PRIMARY KEY,
    pixKey VARCHAR(255),
    CONSTRAINT fk_pix_payments_payments FOREIGN KEY (idPayment) REFERENCES payments(idPayment)
);

-- criar tabela pedido
create table orders(
	idPedido int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
		on update cascade
);

-- criar tabela entrega
CREATE TABLE entrega (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT,
    statusEntrega ENUM('Processando', 'A caminho', 'Entregue'),
    codigoRastreio VARCHAR(50),
    CONSTRAINT fk_entrega_orders FOREIGN KEY (idPedido) REFERENCES orders(idPedido)
);

-- criar tabela estoque
create table productStorage(
	idProductStorage int auto_increment primary key,
    location varchar(255),
    quantity int default 0
);

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbsName varchar(255),
    CNPJ char(14),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    CONSTRAINT check_cpf_cnpj CHECK ((CPF IS NOT NULL AND CNPJ IS NULL) OR (CPF IS NULL AND CNPJ IS NOT NULL)),
    CONSTRAINT unique_cpf_cnpj UNIQUE (CPF, CNPJ)
);


-- criando tabela produto_vendedor
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

-- criando tabela produto_pedido
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idPedido)
);

-- criando tabela storage_location
create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProductStorage)
);

-- criando tabela de fornecedor produto
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
	primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier (idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product (idProduct)
);

show tables;

insert into clients (Fname, Minit, Lname, CPF, CNPJ, Adress)
	values('Ana', 'S', 'Oliveira', '11122233344', NULL, 'Rua das Flores, 123'),
		  ('Pedro', 'M', 'Santos', NULL, '12345678000190', 'Avenida Principal, 456'),
		  ('Carla', 'R', 'Ferreira', '55566677788', NULL, 'Travessa da Paz, 789'),
		  ('Lucas', 'A', 'Rodrigues', NULL, '98765432000112', 'Alameda dos Anjos, 1011'),
		  ('Mariana', 'C', 'Gomes', '99988877766', NULL, 'Estrada do Sol, 1213');
          
select * from clients;
          
insert into product (Pname, classification_kids, Category, Avaliação, size) values
	('Fone de Ouvido', false, 'Eletrônico', '4', null),
    ('Barbie', true, 'Brinquedos', '3', null),
    ('Body Carters', true, 'Vestimenta', '5', null),
    ('Microfone Vedo - Youtuber', false, 'Eletrônico', '4', null);
    
select * from product;
    
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue) values
	(1, default, 'compra via aplicativo', null),
    (2, default, 'compra via aplicativo', 50),
    (3, 'Confirmado', null, null),
    (4, default, 'compra via web site', 150);
    
select * from orders;
    
-- Pagamento com Boleto
INSERT INTO payments (idOrder, typePayment, paymentDate)
	VALUES (1, 'Boleto', '2025-12-31'),
		   (2, 'Cartão', '2025-10-28'),
           (3, 'PIX', '2025-05-10');
           
INSERT INTO card_payments (idPayment, cardNumber, cardHolderName, cardExpiryDate, cardCVV)
	VALUES (2, '1234567890123456', 'Nome do Titular', '2025-12-31', '123');
    
INSERT INTO boleto_payments (idPayment, boletoNumber)
	VALUES (1, '12345678901234567890');
    
INSERT INTO pix_payments (idPayment, pixKey)
	VALUES (3, 'chavepix@exemplo.com');
           
INSERT INTO entrega (idPedido, statusEntrega, codigoRastreio)
	VALUES (1, 'Processando', 'BR123456789BR'),
		   (2, 'A caminho', 'BR987654321BR'),
           (3, 'Entregue', 'BR112233445BR'),
           (4, 'A caminho', 'BR556677889BR');
    
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
	(1, 1, 2, null),
    (2, 2, 1, null),
    (3, 3, 1, null);
    
insert into productStorage (location, quantity) values
	('Rio de Janeiro', 1000),
    ('Rio de Janeiro', 500),
    ('São Paulo', 10),
    ('São Paulo', 100),
    ('São Paulo', 10),
    ('Brasília', 60);
    
insert into storageLocation (idLproduct, idLstorage, location) values
	(1, 2, 'RJ'),
    (2, 6, 'GO');
    
insert into supplier (SocialName, CNPJ, contact) values
	('Almeida e filhos', 123456789123456, '21985474'),
    ('Eletrônicos Silva', 987654321098765, '21985484'),
    ('Eletrônicos Valma', 567890987654321, '21975474');
    
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
	 (2, 4, 633);
     
insert into seller (SocialName, AbsName, CNPJ, CPF, location, contact) values
	('Tech eletronics', null, 345678901234567, null, 'Rio de Janeiro', 219946287),
    ('Botique Durgas', null, null, 234567890, 'Rio de Janeiro', 219567895),
    ('Kids World', null, 012345678901234, null, 'São Paulo', 1198657484);
     
insert into productSeller (idPseller, idPproduct, prodQuantity) values
	(1, 1, 80),
    (2, 2, 10);
    
-- 1. Recuperações simples com SELECT Statement:
-- Listar nomes e endereços dos clientes:
SELECT Fname, Lname, Adress FROM clients;

-- 2. Filtros com WHERE Statement:
-- Listar produtos da categoria "Eletrônico":
SELECT * FROM product WHERE Category = 'Eletrônico';

-- 3. Crie expressões para gerar atributos derivados:
-- Valor total do pedido (considerando o frete):
SELECT idPedido, sendValue, (sendValue + 10) AS Valor_Total FROM orders WHERE sendValue IS NOT NULL;

-- 4. Defina ordenações dos dados com ORDER BY:
-- Listar produtos por avaliação (do maior para o menor):
SELECT * FROM product ORDER BY Avaliação DESC;

-- 5. Condições de filtros aos grupos – HAVING Statement:
-- Quantidade de produtos em cada categoria:
SELECT Category, count(*) as Quantidade FROM product group by Category having count(*) > 1;

-- 6. Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados:
-- Listar pedidos com informações do cliente:
SELECT orders.idPedido, clients.Fname, clients.Lname FROM orders JOIN clients ON orders.idOrderClient = clients.idClient;