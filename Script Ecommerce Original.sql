-- criação do banco de dados para o cenário de E-commerce
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Adress varchar(30),
    constraint unique_cpf_client unique (CPF)
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

-- para ser continuado no desafio: termine de implementar a tabela e crie a conexão com as tabelas necessárias
-- além disso, reflita essa modificação no diagrama do esquema relacional
-- criar constraints relacionadas ao pagamento
create table payments(
	idClient int,
    idPayment int,
    typePayment enum('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable float,
    primary key(idClient, idPayment)
);

-- criar tabela pedido
create table orders(
	idPedido int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
    -- idPayment int,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
		on update cascade
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
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
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

insert into Clients (Fname, Minit, Lname, CPF, Adress)
	values('Maria', 'M', 'Silva', 123456789, 'rua silva de prata 29, Carangola - Cidade das Flores'),
		  ('Matheus', 'O', 'Pimentel', 987654321, 'rua alemeda 289, Centro - Cidade das Flores'),
          ('Ricardo', 'F', 'Silva', 456789123, 'avenida alemeda vinha 1009, Centro - Cidade das Flores'),
          ('Julia', 'S', 'França', 789123456, 'rua larangeiras 861, Centro - Cidade das Flores'),
          ('Roberta', 'G', 'Assis', 98745631, 'ravenida koller 19, Centro - Cidade das Flores'),
          ('Isabela', 'M', 'Cruz', 654789123, 'rua alemeda das flores 28, Centro - Cidade das Flores');
          
insert into product (Pname, classification_kids, Category, Avaliação, size) values
	('Fone de Ouvido', false, 'Eletrônico', '4', null),
    ('Barbie', true, 'Brinquedos', '3', null),
    ('Body Carters', true, 'Vestimenta', '5', null),
    ('Microfone Vedo - Youtuber', false, 'Eletrônico', '4', null);
    
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
	(1, default, 'compra via aplicativo', null, 1),
    (2, default, 'compra via aplicativo', 50, 0),
    (3, 'Confirmado', null, null, 1),
    (4, default, 'compra via web site', 150, 0);
    
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
	(1, 5, 2, null),
    (2, 5, 1, null),
    (3, 6, 1, null);
    
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
     
select * from seller;
     
insert into productSeller (idPseller, idPproduct, prodQuantity) values
	(4, 1, 80),
    (5, 2, 10);