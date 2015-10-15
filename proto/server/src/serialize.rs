use rustc_serialize::json;

/*
 * The json datastructures involved in the requests
 */
#[derive(RustcDecodable, RustcEncodable)]
#[derive(Debug)]
pub struct File {
    path : String,
    metadata : String,
    unique_hash : String,
    kind : String,
    chunks_hashes : Vec<String>,
    files : Option<Vec<File>>,
}

#[derive(Debug)]
pub enum RequestData {
    Tree(File),
}

pub fn decode_tree(json: &str) -> Result<File, json::DecoderError> {
    json::decode(json)
}

pub fn decode_login(json: &str) -> Result<RequestData, json::DecoderError> {

    let tree = try!(decode_tree(json));
    Ok(RequestData::Tree(tree))
}
