use std::collections::{HashMap, LinkedList};

use user;

pub struct Chunks {
	chunk_map : HashMap<String, Vec<String>>,
}

impl Chunks {
    pub fn new() -> Chunks {
        Chunks {
            chunk_map: HashMap::new()
        }
    }

    pub fn add_user(& mut self, username : String, hash_vec : Vec<String>) {

   	for hash in hash_vec{
    		if (!self.chunk_map.contains_key(&hash)){
			self.chunk_map.insert(hash, Vec::new());
    		}
    		else {
    		    self.chunk_map.get_mut(&hash).unwrap().push(username.clone());
    		}
    	}
    }

    pub fn get_chunk_owners(& mut self, chunk : String) -> Option<Vec<String>>{
    	match self.chunk_map.get(&chunk) {
    		Some(c) => Some(c.to_owned()),
    		None => None
    	}
    }
}
