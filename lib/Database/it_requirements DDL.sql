SQLite DB

/** the database and tables will be created automatically by sqlite **/

create table usuarios
(
	id INTEGER
		primary key autoincrement,
	nome TEXT not null
		unique,
	senha TEXT not null
);

create table projetos
(
	id INTEGER
		primary key autoincrement,
	nome TEXT not null,
	dt_inicial NUMBER not null,
	dt_final NUMBER not null
);

-- will not be used this time
-- CREATE TABLE `proj_req` (
--      `id_proj` varchar(20) NOT NULL,
--      `id_req` int(11) NOT NULL,
-- ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1

create table requisitos
(
    id                INTEGER
        primary key autoincrement,
    nome              TEXT    not null,
    descricao         TEXT,
    dt_registro       DATE    not null,
    duracao_estimada  TEXT    not null,
    duracao_realizada TEXT    not null,
    prioridade        REAL    not null,
    dificuldade       REAL    not null,
    localizacao       TEXT    not null,
    requisito_imagem1 TEXT    not null,
    requisito_imagem2 TEXT    not null,
    ref_projeto       INTEGER not null
        references projetos
);