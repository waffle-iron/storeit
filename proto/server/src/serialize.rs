use rustc_serialize::json;
use http;

pub fn decode_login(json: &str) -> Result<http::RequestData, &'static str> {
    let data = match json::decode(json) {
        Err(e) => {
            println!("{:?}", e);
            return Err("Json Decoder Error");
        }
        Ok(dat) => dat
    };

    Ok(http::RequestData::Tree(data))
}
