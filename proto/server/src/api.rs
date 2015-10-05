extern crate std;

use user;

use std::thread;
use std::sync::Arc;

/* user opening a session */
pub fn connect_user(user: user::User, users: &user::Users) {
    user.compute_tree();
    users.add(user);
}

fn send_ping(users: &user::Users) {

    // please don't unwrap this
    let guard = users.users_vec.read().unwrap();
    for user in &*guard {
        println!("sending ping to user: {}", user.username);
    }
}

// TODO: multithread this stuff
pub fn handle_ping(users: &Arc<user::Users>) -> thread::JoinHandle<()> {

    let arc = users.clone();

    let child = thread::spawn(move || {

        loop {

            // is a copy of users done here ?
            send_ping(&*arc);
            std::thread::sleep_ms(1000);
        }
    });

    return child;
}

