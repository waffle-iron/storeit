extern crate time;
extern crate hyper;

use std;
use std::sync::{Arc, RwLock};
use std::collections::HashMap;
use self::time::Tm;

pub struct User {
    pub ip : std::net::SocketAddr,
    pub database_id : i32,
    pub username : Arc<String>,
    pub last_ping : Tm,
}

impl User {
    pub fn compute_tree(&self) {
    }

    pub fn refresh_timestamp(&mut self) {
        println!("updating user {}'s timestamp", self.username);
        self.last_ping = time::now();
    }
}

pub struct Users {
    pub users_map : RwLock<HashMap<Arc<String>, User>>,
}

impl Users {

    pub fn new() -> Users {
        Users {
            users_map: RwLock::new(HashMap::new())
        }
    }

    pub fn add(&self, user: User) {

        // don't unwrap in the future
        let mut guard = self.users_map.write().unwrap();

        // try maybe to use lifetimes instead of allocating a new string as key
        (*guard).insert(user.username.clone(), user);
    }

    pub fn remove(&self, username: &Arc<String>) {

        let mut guard = self.users_map.write().unwrap();

        (*guard).remove(username);
    }
}

pub fn authenticate(request: &hyper::server::Request) -> Option<User> {

    let auth_option : Option<&hyper::header::Authorization<hyper::header::Basic>> = request.headers.get();
    let (username, password) : (&str, &str) = match auth_option {
        None => {
            println!("User has not authentication in http header");
            return None;
        }
        Some(ref header) => {
            let password : &str = match header.password {
                None => {
                    println!("User {} has not entered a password", header.username);
                    return None;
                }
                Some(ref pass) => pass
            };
            (header.username.as_ref(), password)
        }
    };

    println!("{}, {}", username, password);
    // TODO: check if the credentials are correct, and get user from database
 
    Some(User {
        ip: request.remote_addr,
        database_id: 42,
        username: Arc::new(username.to_string()),
        last_ping: self::time::now(),
    })
}
