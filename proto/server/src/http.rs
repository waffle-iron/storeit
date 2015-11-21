extern crate hyper;
extern crate std;

use hyper::client::Response;
use hyper::header::Connection;
use hyper::error::Error;

use std::io::Read;
use user;
use api;
use serialize;

static URL : &'static str = "http://localhost:7642";

// time between each ping sent to a user in seconds
static PING_TIME : i8 = 1;

pub fn get(client: &hyper::Client, path: &str)
    -> Result<Response, Error> {

    let url = URL.to_string() + path;

    client.get(&url)
          .header(Connection::close())
          .send()
}

#[allow(dead_code)]
pub fn post(client: &hyper::Client, body_content: &str)
-> Result<Response, Error> {

    client.post(URL)
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
                Ok(r) => {
                    api::connect_user(username, &users,
                                      &request, &r);
                }

            }
        }
        other     => println!("Request has bad or unimplemented API url: {}", other),
    }
}
