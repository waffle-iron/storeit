from watchdog.events import FileSystemEventHandler 
import tree
import protocol

class WatchFs(FileSystemEventHandler):
    
    def process(self, event):
        
        print(':::{}'.format(event))
        if event.event_type == 'modified':
            cmd = 'FUPDATE'
        elif event.event_type == 'created':
            cmd = 'FADD'
        elif event.event_type == 'deleted':
            protocol.send_FDELETE(event.src_path)
            return
        else:
            print('unknown event happening {}'.format(event))
            return

        if event.is_directory:
            print('directory event {}'.format(event.src_path))
            return

        concerned = tree.produce_tree(False, event.src_path)
        protocol.send_FCMD(cmd, concerned)

    def dispatch(self, event):
        print(event)
        self.process(event)
    
    def on_modified(self, event):
        self.process(event)
    
    def on_created(self, event):
        self.process(event)

    def on_moved(self, event):
        self.process(event)

    def on_deleted(self, event):
        self.process(event)
