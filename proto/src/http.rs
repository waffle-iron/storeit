extern crate hyper;

use hyper::client::Response;
use hyper::header::Connection;
use hyper::error::Error;

use serialize;

static URL : &'static str = "http://localhost:7641";

/*
 * The json datastructures involved in the requests
 */

#[derive(RustcDecodable, RustcEncodable)]
#[derive(Debug)]
pub struct File {
    path : String,
    metadata : String,
    full_hash : String,
    kind : String,
    chunks_hashes : Vec<String>,
    tree : Option<FileTree>,
}

#[derive(RustcDecodable, RustcEncodable)]
#[derive(Debug)]
pub struct FileTree {
    file_list : Vec<File>,
}

#[derive(Debug)]
pub enum RequestData {
    Tree(FileTree),
}

#[allow(dead_code)]
pub fn http_get(client: &hyper::Client) -> Result<Response, Error> {
    client.get(URL)
        .header(Connection::close())
        .send()
}

#[allow(dead_code)]
pub fn http_post(client: &hyper::Client, body_content: &str)
    -> Result<Response, Error> {

        client.post(URL)
            .body(body_content)
            .send()
}

#[allow(unused)]
pub fn parse_post(request: &str) {

    let request = "{ \
        \"file_list\": [ \
        { \
            \"path\": \"sample path\", \
            \"metadata\": \"sample metadata\", \
            \"full_hash\": \"sample full_hash\", \
            \"kind\": \"1\", \
            \"chunks_hashes\": [ \
                \"sample chunks_hashes\" \
                ] \
        } \
        ]}";

            match serialize::decode_login(request) {
        Err(e) => println!("POST request is invalid: {}", e),
        Ok(r) => println!("request succeeded : {:?}", r)
    }

}
