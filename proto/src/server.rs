extern crate hyper;
extern crate threadpool;

use std::env;
use std::net::{TcpStream, TcpListener};
use threadpool::ThreadPool;
use std::sync::mpsc;
use std::io::Write;
use hyper::Server;
use hyper::server::Request;
use hyper::server::Response;
use hyper::net::Fresh;


fn hello(_: Request, res: Response<Fresh>) {
        res.send(b"Hello World!").unwrap();
}


fn new_client(pool: &ThreadPool) {

    let (tx, _) : (_, mpsc::Receiver<i32>) = mpsc::channel();

    let tx = tx.clone();

    pool.execute(move|| {
        println!("new client");
    });
}

fn listen(port: &str) {

    let pool = ThreadPool::new(16);
    Server::http("127.0.0.1:3000").unwrap().handle(hello);
}

fn main() {

    let mut arg = env::args();
    match arg.nth(1) {
        Some(ref s)           => listen(s),
        None if arg.len() > 2 => println!("Usage: ./prototype [port]"),
        None                  => listen("7641"),
    }
}
