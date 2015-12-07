extern crate hyper;
extern crate rustc_serialize;

#[macro_use]
extern crate log;
extern crate env_logger; 

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

        info!("credentials are ok for {}", username);

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

    match Server::http(addr).unwrap().handle(http_handler) {
        Ok(l) => info!("server runs on port"), // {}", l.socket.port());
        Err(_) => error!("server could not start")
    }

    let res = ping_thread.join();
    debug!("child ended with {:?}", res);
}

fn main() {

    env_logger::init().unwrap();

    let mut arg = env::args();
    match arg.nth(1) {
        Some(ref s)           => listen(s),
        None if arg.len() > 2 => error!("Usage: ./prototype [port]"),
        None                  => listen("7641"),
    }
}
