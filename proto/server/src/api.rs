extern crate std;
extern crate hyper;
extern crate time;

use user;
use http;

use hyper::Client;
use std::thread;
use std::sync::Arc;
use std::vec::Vec;

/* user opening a session */
pub fn connect_user(user: user::User, users: &user::Users) {
    user.compute_tree();
    users.add(user);
}

fn ping_failure(user: &user::User, dead: &mut Vec<Arc<String>> ) {

    println!("{} failed the ping test", user.username);
    dead.push(user.username.clone());
}

fn send_ping(users: &user::Users) {


    let mut dead_users = vec!();

    {
        // please don't unwrap this
        // in the future, optimise by only reading first, and then writing
        let mut guard = users.users_map.write().unwrap();

        for user_tuple in &mut *guard {
            println!("sending ping to user: {}", user_tuple.0);
            match http::get(&Client::new(), "/session/ping") {
                Err(_)      =>
                    ping_failure(&user_tuple.1, &mut dead_users),
                Ok(res) =>
                    if res.status != hyper::status::StatusCode::Ok {
                        ping_failure(&user_tuple.1, &mut dead_users);
                    } else {
                        user_tuple.1.refresh_timestamp();
                    }
            }
        }
    }


    for name in dead_users {
        users.remove(&name);
        println!("{} was disconnected", name);
    }
}

pub fn handle_ping(users: Arc<user::Users>) -> thread::JoinHandle<()> {

    let child = thread::spawn(move || {

        loop {

            // is a copy of users done here ?
            send_ping(&*users);
            std::thread::sleep_ms(1000);
        }
    });

    return child;
}

