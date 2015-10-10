CREATE TABLE client (
    id int,
    username varchar(255),
    passwd_hash varchar(255),
    file_tree text
);

INSERT INTO client VALUES(0, 'sevauk', 'zulu', '[    \"file_list\": [ \
    { \
    \"path\": \"sample path\", \
    \"metadata\": \"sample metadata\", \
    \"full_hash\": \"sample full_hash\", \
    \"kind\": \"1\", \
    \"chunks_hashes\": [ \
    \"sample chunks_hashes\" \
    ] \
    } \
    ]}');

