use rustc_serialize::json;

/*
 * The json datastructures involved in the requests
 */
#[derive(RustcDecodable, RustcEncodable)]
#[derive(Debug)]
pub struct File {
    pub path : String,
    pub metadata : String,
    pub unique_hash : String,
    pub kind : i16,
    pub chunks_hashes : Option<Vec<String>>,
    pub files : Option<Vec<File>>,
}

pub fn decode_tree(json: &str) -> Result<File, json::DecoderError> {
    json::decode(json)
}
