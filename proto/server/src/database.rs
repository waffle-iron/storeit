extern crate postgres;

use self::postgres::{Connection, SslMode};

pub struct User {
    pub username: String,
    pub passwd_hash: String,
    pub file_tree: String,
}


pub fn get_user(name: &str) -> Option<User> {

    // TODO: don't open the connection each time
    let conn = Connection::connect("postgres://Sevauk@localhost/storeit", &SslMode::None)
        .unwrap();

    let stmt = conn.prepare("SELECT * FROM client WHERE username = $1").unwrap();

    for res in stmt.query(&[&name]).unwrap() {

        return Some(User {
            username: String::from("sevauk"),
            passwd_hash: String::from("lol"),
            file_tree: res.get("file_tree"),
        });
    }
    None
}
