extern crate hyper;
extern crate rustc_serialize;

mod http;
mod serialize;
mod user;
mod api;
mod database;
mod file;
mod chunks;

use std::env;
use hyper::Server;
use hyper::server::Request;
use hyper::server::Response;
use hyper::net::Fresh;
use hyper::method::Method;
use hyper::status::StatusCode;
use std::sync::Arc;

struct RequestHandler {
    users : Arc<user::Users>,
}

impl hyper::server::Handler for RequestHandler {

    fn handle(&self, request: Request, mut response: Response<Fresh>) {

        let username =
            match user::credentials(&request, &*self.users) {
                Some(username) => username,
                None    => return,
            };

        println!("credentials ok for {}", username);

        match request.method {
            Method::Get  => response.send(b"Hello World!").unwrap(),
            Method::Post => http::parse_post(request, &username, &*self.users),
            _            =>
                *response.status_mut() = StatusCode::MethodNotAllowed,
        }

    }
}

fn listen(port: &str) {

    let addr : &str = &("127.0.0.1:".to_string() + port);

    let users = Arc::new(user::Users::new());

    let ping_thread = api::handle_ping(users.clone());

    let http_handler = RequestHandler {
        users: users.clone(),
    };

    let code = Server::http(addr).unwrap().handle(http_handler);

    println!("{:?}", code);

    let res = ping_thread.join();
    println!("child ended with {:?}", res);
}

fn main() {

    let mut chunks_manager = chunks::Chunks::new();


    chunks_manager.add_user("louis".to_string(), vec!["123456789".to_string(), "1234a56".to_string()].clone());
    chunks_manager.add_user("adrien".to_string(), vec!["123456789".to_string(), "789ez0".to_string()].clone());
    chunks_manager.add_user("romain".to_string(), vec!["123456789".to_string(), "787dsd851".to_string()].clone());
    chunks_manager.add_user("alex".to_string(), vec!["123456789".to_string(), "5641azesd2".to_string()].clone());    

    match chunks_manager.get_chunk_owners("123456789".to_string()) {
        Some(chunks) => {
            for c in chunks {
                println!("{}", c);
            }
        },
        None => {
            println!("No chunks...");
        }
    }

    match chunks_manager.get_chunk_owners("trololol".to_string()) {
        Some(chunks) => {
            for c in chunks {
                println!("{}", c);
            }
        },
        None => {
            println!("No chunks...");
        }        
    }

    chunks_manager.add_chunk_for_user("louis".to_string(), "trololol".to_string());

    match chunks_manager.get_chunk_owners("trololol".to_string()) {
        Some(chunks) => {
            for c in chunks {
                println!("{}", c);
            }
        },
        None => {
            println!("No chunks...");
        }        
    }    

    let mut arg = env::args();
    match arg.nth(1) {
        Some(ref s)           => listen(s),
        None if arg.len() > 2 => println!("Usage: ./prototype [port]"),
        None                  => listen("7641"),
    }
}
