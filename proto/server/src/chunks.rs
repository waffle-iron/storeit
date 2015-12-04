use std::collections::HashMap;

// table de hash  : clef chunk-> value list<client>
// table de hash  : clef client -> value list<chunk>

pub struct Chunks {
    chunk_map : HashMap<String, Vec<String>>,
    user_map: HashMap<String, Vec<String>>
}

impl Chunks {
    pub fn new() -> Chunks {
        Chunks {
            chunk_map: HashMap::new(),
            user_map: HashMap::new()
        }
    }

    pub fn add_user(& mut self, username : String, hash_vec : Vec<String>) {


        if !self.user_map.contains_key(&username){ // If user doesn't exist create blank vec
            self.user_map.insert(username.clone(), hash_vec.clone());
        }
        else {
        *self.user_map.get_mut(&username).unwrap() = hash_vec.clone(); // else copy all the hashes
        }


        for hash in hash_vec{

            let h = hash.clone();
            if !self.chunk_map.contains_key(&hash) {  // If chunk map doesn't contain the current hash, create empty vec
                   self.chunk_map.insert(hash, Vec::new());
            }
            self.chunk_map.get_mut(&h).unwrap().push(username.clone()); // Add the user for this hash
        }
    }

    pub fn get_chunk_owners(& mut self, chunk : String) -> Option<Vec<String>>{
        match self.chunk_map.get(&chunk) {
            Some(c) => Some(c.to_owned()),
            None => None
        }
    }

    pub fn add_chunk_for_user(& mut self, username : String, chunk : String) {
        if !self.chunk_map.contains_key(&chunk) { // chunk isn't already registered, add it
            self.chunk_map.insert(chunk.clone(), Vec::new());
        }
        self.chunk_map.get_mut(&chunk).unwrap().push(username.clone()); // Add user to chunk
        self.user_map.get_mut(&username).unwrap().push(chunk.clone()); // Add chunk to user
    }

    pub fn remove_chunk_for_user(& mut self, username: String, chunk : String){

    }

    pub fn remove_user(&mut self, username: String){
        if self.user_map.contains_key(&username)
        {
            {
                let chunk_vec = self.user_map.get(&username).unwrap(); // Get list of chunk for user

                for chunk in chunk_vec {
                    let index = self.chunk_map.get(chunk).unwrap().iter().position(|usr| *usr == username).unwrap(); // Get the index of the chunk in the list of chunk
                        self.chunk_map.get_mut(chunk).unwrap().remove(index); // Remove the chunk thanks to the index

                        if self.chunk_map.get(chunk).unwrap().is_empty() { // If the user was the last owner, remove the chunk from the chunk map
                            self.chunk_map.remove(chunk);                   
                        }
                }
            }
                self.user_map.remove(&username); // Remove user from user map
            }
        }

    pub fn remove_chunk(& mut self, chunk: String){
        if self.chunk_map.contains_key(&chunk){
            {
                let user_vec = self.chunk_map.get(&chunk).unwrap(); // Get list of chunk owners

                for user in user_vec {
                    let index = self.user_map.get(user).unwrap().iter().position(|c| *c == chunk).unwrap(); // Get the index of the user in the list of users
                    self.user_map.get_mut(user).unwrap().remove(index); // Remove the user

                    if self.user_map.get(user).unwrap().is_empty() { // if the user doesn't have anymore chunk, delete it
                        self.user_map.remove(user);
                    }
                }
            }
            self.chunk_map.remove(&chunk); // Remove chunk from chunk map
        }
    }
}


// Todo : create a test module with a test directory

#[test]
fn test_chunk_manager() {

    let mut chunks_manager = Chunks::new();

    chunks_manager.add_user("adrien".to_string(), vec!["123456789".to_string(), "789ez0".to_string()].clone());
    chunks_manager.add_user("romain".to_string(), vec!["123456789".to_string(), "787dsd851".to_string()].clone());
    chunks_manager.add_user("alex".to_string(), vec!["123456789".to_string(), "5641azesd2".to_string()].clone());    
    chunks_manager.add_user("louis".to_string(), vec!["123456789".to_string(), "1234a56".to_string()].clone());
  

      match chunks_manager.get_chunk_owners("123456789".to_string()) {
        Some(chunks) => {
            print!("owners of [123456789] : ");
            for c in chunks {
                println!("{}", c);
            }
        },
        None => {
            println!("No chunks...");
        }
    }

    chunks_manager.add_chunk_for_user("louis".to_string(), "trololol".to_string());
    match chunks_manager.get_chunk_owners("trololol".to_string()) {
        Some(chunks) => {

            for c in chunks {
                println!("{}", c);
            }
        },
        None => {
            println!("No chunks...");
        }        
    }

    chunks_manager.remove_user("louis".to_string());
    match chunks_manager.get_chunk_owners("trololol".to_string()) {
        Some(chunks) => {
            for c in chunks {
                println!("ici {}", c);
            }
        },
        None => {
            println!("No chunks...");
        }        
    }  
  
    chunks_manager.remove_chunk("123456789".to_string());
    match chunks_manager.get_chunk_owners("123456789".to_string()) {
        Some(chunks) => {
            println!("la");
            for c in chunks {
                println!("ici {}", c);
            }
        },
        None => {
            println!("No chunks...");
        }        
    }
}