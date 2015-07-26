use std::env;
use std::net::{TcpStream, TcpListener};
extern crate threadpool;
use threadpool::ThreadPool;
use std::sync::mpsc;

fn new_client(stream: TcpStream, pool: &ThreadPool) {

    let (tx, _) : (_, mpsc::Receiver<i32>) = mpsc::channel();

    let tx = tx.clone();
    pool.execute(move|| {
        println!("new client");
    });
}

fn listen(port: &str) {

    let pool = ThreadPool::new(16);

    let address : &str = &("127.0.0.1:".to_string() + port); // TODO: use as_str()
    let tcp_l = TcpListener::bind(address).unwrap();

    for client in tcp_l.incoming() {
        match client {
            Ok(stream) => new_client(stream, &pool),
            Err(e)     => println!("cannot connect client: {}", e),
        }
    }
}


fn main() {

    let mut arg = env::args();
    match arg.nth(1) {
        Some(ref s)           => listen(s),
        None if arg.len() > 2 => println!("Usage: ./prototype [port]"),
        None                  => listen("7641"),
    }
}
