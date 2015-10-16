DROP TABLE client;

CREATE TABLE client (
    id int,
    username varchar(255),
    passwd_hash varchar(255),
    file_tree text
);

INSERT INTO client VALUES(0, 'sevauk', 'zulu', '{
    "path": "/",
    "unique_hash": "sample full_hash",
    "kind": "1", 
    "chunks_hashes": [
        "sample chunks_hashes"
    ],
    "id_indir": "0"
    }');
