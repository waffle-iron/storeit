extern crate hyper;

use hyper::client::Response;
use hyper::header::Connection;
use hyper::error::Error;

static URL : &'static str = "http://localhost:7641";

pub fn http_get(client: &hyper::Client) -> Result<Response, Error> {
    client.get(URL)
        .header(Connection::close())
        .send()
}

pub fn http_post(client: &hyper::Client, body_content: &str)
    -> Result<Response, Error> {

        client.post(URL)
            .body(body_content)
            .send()
}
