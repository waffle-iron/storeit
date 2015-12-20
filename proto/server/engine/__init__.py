import protocol

def FADD(directory, filename, tree, client = None):

    if client is not None:
        protocol.FADD(tree, client)
    directory[filename] = tree

def FUPDATE(new_tree, old_tree, client = None):
    
    if client is not None:
        protocol.FUPDATE(new_tree, client)

    old_tree['unique_hash'] = new_tree['unique_hash']

