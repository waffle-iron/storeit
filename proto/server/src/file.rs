use serialize;
use std::rc::Rc;

pub enum Who {
    Server,
    Client,
}

pub enum FileDiff<'a> {
    FileAdded       (Who, Rc<&'a serialize::File>),
    FileRemoved     (Who, Rc<&'a serialize::File>),
    FileDataUpdated (Who, Rc<&'a serialize::File>),
    FileMetaUpdated (Who, Rc<&'a serialize::File>),
}

pub fn diff<'a>(client: Rc<&'a serialize::File>, server: Rc<&'a serialize::File>)
    -> FileDiff<'a> {
        FileDiff::FileAdded(Who::Server, client.clone())
}
