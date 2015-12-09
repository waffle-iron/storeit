use rustc_serialize::json;
use std::sync::Arc;
use user;
use chunks;

/*
 * The json datastructures involved in the requests
 */
#[derive(RustcDecodable, RustcEncodable, Clone)]
#[derive(Debug)]
pub struct File {
    pub path : String,
    pub metadata : String,
    pub unique_hash : String,
    pub kind : i16,
    pub chunks_hashes : Option<Vec<String>>,
    pub files : Option<Vec<File>>,
}

// TODO: put in main
pub struct ServerData {
    pub users : Arc<user::Users>,
    pub chunks : chunks::Chunks,
}

pub fn decode_tree(json: &str) -> Result<File, json::DecoderError> {
    json::decode(json)
}

pub fn tree_to_json(tree: &File) -> Result<String, json::EncoderError> {
    json::encode(tree)
}

