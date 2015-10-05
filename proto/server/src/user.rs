extern crate hyper;

use std;
use std::sync::RwLock;

pub struct User {
    pub ip : std::net::SocketAddr,
    pub database_id : i32,
    pub username : String,
}

impl User {
    pub fn compute_tree(&self) {
    }
}

pub struct Users {
    pub users_vec : RwLock<Vec<User>>,
}

impl Users {

    pub fn new() -> Users {
        Users {
            users_vec: RwLock::new(vec!())
        }
    }

    //pub fn do_on_users<F>(&self, action: F) where F: Fn(Vec<User>) -> () {
    //    //action();
    //}

    pub fn add(&self, user: User) {

        // don't unwrap in the future
        let mut guard = self.users_vec.write().unwrap();
        (*guard).push(user);
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
        username: username.to_string(),
    })
}
