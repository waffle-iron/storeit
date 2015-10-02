extern crate hyper;
extern crate rustc_serialize;

mod http;
mod serialize;
mod user;

use std::env;
use hyper::Server;
use hyper::server::Request;
use hyper::server::Response;
use hyper::net::Fresh;
use hyper::method::Method;
use hyper::status::StatusCode;

fn handle_request(mut request: Request, mut response: Response<Fresh>) {

    let user = match user::authenticate(&request) {
        None => { return; }
        Some(u) => u
    };

    match request.method {
        Method::Get  => response.send(b"Hello World!").unwrap(),
        Method::Post => http::parse_post(request, user),
        _            => *response.status_mut() = StatusCode::MethodNotAllowed,
    }
}


fn listen(port: &str) {

    let addr : &str = &("127.0.0.1:".to_string() + port);

    let code = Server::http(addr).unwrap().handle(handle_request);
    println!("{:?}", code);
}

fn main() {

    let mut arg = env::args();
    match arg.nth(1) {
        Some(ref s)           => listen(s),
        None if arg.len() > 2 => println!("Usage: ./prototype [port]"),
        None                  => listen("7641"),
    }
}
