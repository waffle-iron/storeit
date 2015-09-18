extern crate hyper;
extern crate common;

use std::io::Read;

fn send_login(client: &hyper::Client) -> Option<&'static str> {

    let json = "[ \
    { \
        \"File list\": [ \
        { \
            \"path\": \"sample path\", \
            \"file metadata\": \"sample file metadata\", \
            \"file content hash\": \"sample file content hash\", \
            \"file type\": \"1\", \
            \"hashes of the file content\": [ \
                \"sample hashes of the file content\" \
                ] \
        } \
        ] \
    } \
    ]";

    let mut res = common::http_post(client, json)
        .ok()
        .expect("Cannot do http request");

    match res.status {
        hyper::status::StatusCode::Ok => {
            let mut body = String::new();
            res.read_to_string(&mut body).unwrap();
            println!("=> {};", body);
        }
        _ => println!("http response was not 200")
    }

    None
}

fn request(client: &hyper::Client) {

    match send_login(client) {
        Some(s) => println!("Error: {}", s),
        None    => ()
    }
}

fn main() {

    let client = hyper::Client::new();

    request(&client);
}
