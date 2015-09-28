extern crate hyper;
extern crate rustc_serialize;

mod http;
mod serialize;

use std::env;
use hyper::Server;
use hyper::server::Request;
use hyper::server::Response;
use hyper::net::Fresh;
use hyper::method::Method;
use hyper::status::StatusCode;
use std::io::Read;

fn hello(mut request: Request, mut response: Response<Fresh>) {
    match request.method {
        Method::Get => response.send(b"Hello World!").unwrap(),
        Method::Post => {
            let mut body = String::new();
            request.read_to_string(&mut body);
            let LoginData = serialize::decode_login(&body);
            println!("client sent {}", body);
        }
        _ => *response.status_mut() = StatusCode::MethodNotAllowed,
    }
}


fn listen(port: &str) {

    let addr : &str = &("127.0.0.1:".to_string() + port);

    let code = Server::http(addr).unwrap().handle(hello);
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
