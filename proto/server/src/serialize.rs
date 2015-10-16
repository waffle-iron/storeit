use rustc_serialize::json;

/*
 * The json datastructures involved in the requests
 */
#[derive(RustcDecodable, RustcEncodable)]
#[derive(Debug)]
pub struct File {
    pub path : String,
    pub unique_hash : String,
    pub kind : String,
    pub chunks_hashes : Vec<String>,
    pub files : Option<Vec<File>>,
    pub id_indir : u32,
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
