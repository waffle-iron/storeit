extern crate time;
extern crate hyper;

use std;
use std::sync::{RwLock, RwLockReadGuard};
use std::collections::HashMap;
use self::time::Tm;

use database;
use serialize;
use user;

pub struct User {
    pub ip : std::net::SocketAddr,
    pub database_id : i32,
    pub username : String,
    pub last_ping : Tm,
    pub root: serialize::File,
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
    pub users_map : RwLock<HashMap<String, User>>,
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

    pub fn remove(&self, username: &str) {

        let mut guard = self.users_map.write().unwrap();

        (*guard).remove(username);
    }

    pub fn exists(&self, username: &str) -> bool {
        let guard = self.get_read_guard();

        match (*guard).get(username) {
            None => false,
            Some(_) => true,
        }
    }

    pub fn get_read_guard(&self)
        -> RwLockReadGuard<HashMap<String, User>> {

            self.users_map.read().unwrap()
        }

    /* TODO: succeed this someday 
    pub fn get(&self, name: &str) -> Option<&'a User> {

        let mut guard : RwLockReadGuard<'a, _> = self.get_read_guard();

        let gotten = (*guard).get(name);
        gotten
    }
    */
}

pub fn make_new_user_from_db(request: &hyper::server::Request,
                             username: &str) -> Option<User> {

    let user: database::User = match database::get_user(username) {
        Some(u) => u,
        None => return None
    };

    Some(User {
        ip: request.remote_addr,
        database_id: 42,
        username: username.to_string(),
        last_ping: self::time::now(),
        root: serialize::decode_tree(user.file_tree.as_ref()).unwrap(),
    })
}

pub fn credentials(request: &hyper::server::Request, users: &user::Users)
    -> Option<String> {

    let auth_option
        : Option<&hyper::header::Authorization<hyper::header::Basic>>
        = request.headers.get();

    let (username, password) = match auth_option {
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

    if users.exists(username) {
        return Some(String::from(username));
    }

    match database::get_user(username) {
        // TODO: check for password
        Some(_) => Some(String::from(username)),
        None => {
            println!("user {} doesn't exists in database", username);
            None
        }
    }
}
