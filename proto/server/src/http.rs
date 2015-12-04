extern crate hyper;
extern crate std;

use hyper::client::Response;
use hyper::header::Connection;
use hyper::error::Error;

use std::io::Read;
use user;
use api;
use serialize;

// time between each ping sent to a user in seconds
static PING_TIME : i8 = 1;
static CLIENT_PORT : &'static str = ":7642";

fn build_url(ip: &str, path: &str) -> String {

    "http://".to_string() + &ip + CLIENT_PORT + path
}

pub fn get(ip: &std::net::SocketAddr, path: &str) -> Result<Response, Error> {

    let mut ip = ip.to_string();
    ip.truncate(9);

    let url = build_url(&ip, path);

    println!("url is {}", url);

    let client = hyper::Client::new();

    client.get(&url)
        .send()
}

pub fn post(ip: &std::net::SocketAddr, path: &str, body_content: &str)
-> Result<Response, Error> {


    let mut ip = ip.to_string();
    ip.truncate(9);

    let url = build_url(&ip, path);

    let client = hyper::Client::new();

    println!("posting at {}", url);

    client.post(&url)
        .body(body_content)
        .send()
}

#[allow(unused)]
pub fn parse_post(mut request: hyper::server::Request,
                  username: &str,
                  users: &user::Users) {

    let api_uri : String = match request.uri {
        hyper::uri::RequestUri::AbsolutePath(ref s) => String::from(s.as_ref()),
        _ => {
            println!("bad enum for request.uri");
            return;
        }
    };

    let mut request_body = String::new();

    match request.read_to_string(&mut request_body) {
        Ok(_) => (),
        Err(_) => {
            println!("oops, cannot read http request");
            return;
        }
    }

    match api_uri.as_ref() {
        "/session/join" => {
            match serialize::decode_tree(&request_body) {
                Err(e) => println!("POST request is invalid: {}", e),
                Ok(ref r) => {
                    api::connect_user(username, &users,
                                      &request, r);
                }

            }
        }
        other     => println!("Request has bad or unimplemented API url: {}", other),
    }
}
