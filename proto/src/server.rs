extern crate hyper;

use std::env;
use hyper::Server;
use hyper::server::Request;
use hyper::server::Response;
use hyper::net::Fresh;


fn hello(_: Request, res: Response<Fresh>) {
        res.send(b"Hello World!").unwrap();
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
