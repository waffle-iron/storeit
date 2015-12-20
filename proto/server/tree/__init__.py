import json
import engine

class Tree:

    raw_tree = dict()

    def __init__(self, json_str: str):
        self.raw_tree = json.loads(json_str)

    def __str__(self):
        return str(self.raw_tree)

    def get_most_recent(ufile, sfile):
        if ufile['metadata'] == sfile['metadata']:
            return 'client', ufile, sfile
        else:
            return 'server', sfile, ufile

    def process_subtree(client, user_tree: dict, server_tree: dict):
        
        ufiles = user_tree['files']
        sfiles = server_tree['files']

        #TODO: do more pythonic than a for loop
        for file_name, ufile in ufiles.items():

            if file_name in sfiles:
                
                sfile = sfiles[file_name]

                if ufile['unique_hash'] != sfile['unique_hash']:

                    if ufile['kind'] == sfile['kind'] == 0:
                        #TODO: handle the case where a directory
                        #has been transformed into a file
                        Tree.process_subtree(client, ufile, sfile)

                    who_new, file_new, file_old = Tree.get_most_recent(ufile, sfile)

                    client = client if who_new == 'client' else None
                    
                    engine.FUPDATE(file_new, file_old, client)

            else:
                print('fadd fo {}'.format(file_name))
                engine.FADD(sfiles, file_name, ufile)

        for  file_name, sfile in sfiles.items():
            if file_name not in ufiles:
                print('fadd for {}'.format(file_name))
                engine.FADD(ufiles, file_name, sfile, client)
