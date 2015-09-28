use rustc_serialize::json;

#[derive(RustcDecodable, RustcEncodable)]
pub struct LoginData  {
    file_list: Vec<String>
}

pub fn decode_login(json: &str) -> LoginData {
    json::decode(json).unwrap()
}
