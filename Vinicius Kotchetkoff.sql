Skip to content
Search or jump to…
Pull requests
Issues
Codespaces
Marketplace
Explore
 
@Vinikot 
williamdubgod
/
banco_de_dados
Public
Fork your own copy of williamdubgod/banco_de_dados
Code
Issues
Pull requests
Actions
Projects
Security
Insights
banco_de_dados/William_Banco.sql

Logon Aluno exercicios
Latest commit b9747c4 last week
 History
 0 contributors
258 lines (191 sloc)  6.91 KB

Introdução a línguagem SQL
DDL - Línguagem de definição de dados - Estrutura 
Criando tabelas
Sintaxe:
    create table nome_tabela
    (nome_coluna1 tipo_dados(tamanho) [regra],
    ......,
    nome_colunaN tipo_dados (tamanho [regra]);
    
Tipo de dados: char(n), campo alfanumérico de tamanho fixo
               varchar(n), campo alfanumérico de tamanho variável
               number(x,y), campo númerico inteiro ou real
               date, campo tipo data
n = tamanho
x = parte inteira
y = parte real casas decimais

Regras/Constraints 
Pk - primary key, campo unico, preenchimento obrigatório, relacionamento
Fk - foreign key, relacionamento lado n da cardinalidade, recebe dados 
     previamentes cadastrados na Pk
Nn - not null, campo de preenchimento obrigatório
Uk - unique, campo com restrição a dados repetidos
Ck - check, campo com lista de dados para validação

Exemplificando

1- Criando uma tabela sem regras:

create table cargo
(cd_cargo number(3),
nm_cargo varchar2(25),
salario number(8,2));

visualizando a estrutura de uma tabela
desc nome_tabela

Exemplo:
desc cargo

select object_name from user_objects where object_type = 'TABLE';

Deletado uma tabela
drop table nome_tabela

Exemplo:
drop table cargo

2- Criando uma tabela com regras, sem personalização:
create table cargo
(cd_cargo number(3) primary key,
nm_cargo varchar2(25)not null unique,
salario number(8,2));

desc cargo

Visualizando constraints
select constraint_name, constraint_type from user_constraints
where table_name = 'CARGO'

3- Criando uma tabela com regras, com personalização:

drop table cargo

create table cargo
(cd_cargo number(3) constraint cargo_cd_pk primary key,
nm_cargo varchar2(25)constraint cargo_nome_nn not null
                     constraint cargo_nome_uk unique,
salario number(8,2));

desc cargo

Visualizando constraints
select constraint_name, constraint_type from user_constraints
where table_name = 'CARGO'

criando o relacionamento

1 - 1 - Pk + FK_UK
1 - N - Pk + FK
N - N - não existe em código SQL

desc cargo

create table funcionario
(cd_fun number(3) constraint fun_cd_pk primary key,
nm_fun varchar(30) constraint fun_nm_nn not null,
dt_adm date constraint fun_dt_nn not null,
uf_fun char(2) constraint fun_uf_nn not null,
cargo_fk number(3) constraint fun_cargo_fk references cargo)

desc funcionario

create table funcionario2
(cd_fun number(3) constraint fun_cd_pk2 primary key,
nm_fun varchar(30) constraint fun_nm_nn2 not null,
dt_adm date constraint fun_dt_nn2 not null,
uf_fun char(2) constraint fun_uf_nn2 not null,
cargo_fk references cargo)

create table n_fiscal
(n_nf number(5) constraint nf_cd_pk primary key,
dt_nf date constraint nf_dt_nn not null,
total_nf number(10,2));

desc n_fiscal
select constraint_name, constraint_type from user_constraints where table_name = 'N_FISCAL'

create table produto
(cd_pro number(5) constraint prod_cd_pk primary key,
nm_prod varchar2(30) constraint prod_mn_nn not null
constraint prod_nm_uk unique,
preco number(10, 2))

select constraint_name, constraint_type from user_constraints where table_name = 'PRODUTO'

create table tem
(fk_nota number(5) constraint tem_nf_fk references n_fiscal,
fk_prod number(5) constraint tem_prod_fk references produto)

Inserindo dados 
Comando DML - Data Manipulation Language
Novas linhas:
insert into nome_tabela values
(valor1, valor2,..., valorN)

Obs: campos: char, varchar ou varchar2 e date precisam de apóstrofe

Exemplo 1
conhecendo ou visualizando a estrutura 
desc n_fiscal
inserindo uma linha
insert into n_fiscal values (1,'10-jan-00',5000);
insert into n_fiscal values (2,'10-Dec-00',5000);
verificando a inserção
select * from n_fiscal

descobrindo o padrão da data
select sysdate from dual

gravando dados fisicamente
commit;

Aula 03 - 01/03/2023

Ainda trabalhando com estruturas das tabelas

DDL

Create - Ok

Alterando ou corrigindo uma estrutura
alter table nome_tabela
opções
add column          - nova coluna
add constraint      - nova regra
modify              - modifica tipo e/ou tamanho de uma coluna
drop column         - elimina uma coluna
drop constraint     - elimina uma regra

create table tb_teste
(codigo number(2),
nome number(10));

incluindo uma nova coluna
alter table tb_teste add dt_nasc date

incluindo uma coluna com regra
alter table tb_teste add cep char(8) not null

incluindo a pk na coluna codigo
alter table tb_teste add constraint pk_cod primary key (codigo)

modificando apenas o tipo de dado
alter table tb_teste modify nome varchar(10)

modificando apenas o tamanho da coluna
alter table tb_teste modify nome varchar(50)

modificando o tamanho da coluna e o tipo ao mesmo tempo
alter table tb_teste modify nome number(10)

eliminando uma regra
alter table tb_teste drop constraint pk_cod
desc user_constraints
select constraint_name from user_constraints where table_name = 'TB_TESTE'

Eliminando uma coluna
alter table tb_teste drop column nome

Renomeando uma coluna
alter table tb_teste rename column codigo to cod_cliente

Renomeando uma constraint 
alter table tb_teste rename constraint SYS_C003509438 to fiap
select constraint_name from user_constraints where table_name = 'TB_TESTE'

eliminando uma tabela 
drop table nome_tabela
drop table tb_teste
desc cargo

create table tb_teste1
(codigo number(1) primary key)
create table tb_teste2
(codigo number(1) references tb_teste1)
insert into tb_teste1 values(1)
insert into tb_teste2 values(1)

uso do cascade permite eliminar o relacionamento e depois dropar a tabela
drop table tb_teste1 cascade constraints

Atualizando dados

Update atualiza os dados, já o alter table atualiza a tabela e suas caracteristicas

operadores: aritiméticos: + - * / ()
            relacionais: > >= < <= = != ou <>
            lógicos: and or not

update nome_tabela set nome_coluna = novo_valor

update nome_tabela set nome_coluna = novo_valor
where condição

create table produto_tb 
(cod_prod number(4) constraint prod_cod_pk primary key, 
unidade varchar2(3),descricao varchar2(20),val_unit number(10,2))

insert into produto_tb values ('25','KG','Queijo','0.97');
insert into produto_tb values ('31','BAR','Chocolate','0.87');
insert into produto_tb values ('78','L','Vinho','2.00');
insert into produto_tb values ('22','M','Linho','0.11');
insert into produto_tb values ('30','SAC','Acucar','0.30');
insert into produto_tb values ('53','M','Linha','1.80');
insert into produto_tb values ('13','G','Ouro','6.18');
insert into produto_tb values ('45','M','Madeira','0.25');
insert into produto_tb values ('87','M','Cano','1.97');
insert into produto_tb values ('77','M','Papel','1.05');
commit;

ex:

1- Atualizar em 15% o preço dos produtos de codigo maior que 30.
update produto_tb set val_unit = val_unit * 1.15
where cod_prod > 30

2- atualizar o nome do produto queijo para queijo minas.
update produto_tb set descricao = 'Queijo Minas'
where descricao = 'Queijo'

3- para os produtos Açucar, madeira e linha zerar o preço.
update produto_tb set val_unit = 0
where cod_prod = 30 or cod_prod = 45 or cod_prod = 53

select * from produto_tb order by 1

aula 4 - finalidade DML

Eliminando linha(s)

todas
delete from nome_tabela
algumas
delete from nome_tabela where condição

commit

Apagando tudo
select * from produto_tb
delete from produto_tb
rollback




create table CIDADE(
Código number(4) constraint cod_pk primary key,
Nome varchar(30) constraint nome_nn not null);

create table SOCIO(
CPF char(11) constraint cpf_pk primary key,
Nome varchar(20) constraint nome_socio_nn not null,
DataNasc date constraint dt_nasc_nn not null,
RG varchar(15) constraint rg_nn not null,
Cidade number(4) references CIDADE constraint cidade_socio_nn not null);

alter table CIDADE add Uf char(2) constraint uf_nn not null

alter table SOCIO add Fone varchar(10)
alter table SOCIO add Sexo varchar(1) constraint sexo_nn not null

alter table SOCIO modify Nome varchar(35)

create table SETOR(
Código number(3) constraint cod_setor_pk primary key,
Nome varchar(30) constraint nome_setor_nn not null);

alter table SOCIO add Setor number(3) references SETOR constraint setor_socio_nn not null

create table DEPENDENTE(
Socio char(11) references SOCIO constraint socio_depen_nn not null,
Número number(4) constraint num_depen_pk primary key,
Nome varchar(30) constraint nome_depen_nn not null,
DataNasc date constraint dt_nasc_depen_nn not null);

insert into CIDADE values ('1', 'São Paulo', 'SP')
insert into CIDADE values ('2', 'Rio de Janeiro', 'RJ')

insert into SOCIO values ('40069920629','Vinicius','25-dec-03','454448973','1','','M','1')
insert into SOCIO values ('30069920629','Jossef','05-dec-03','454448979','2','','M','2')

insert into SETOR values ('1', 'ADM')
insert into SETOR values ('2', 'BD')

insert into DEPENDENTE values('40069920629','001','Thomas','09-mar-22')
insert into DEPENDENTE values('40069920629','002','Julia','29-nov-23')

select * from DEPENDENTE






