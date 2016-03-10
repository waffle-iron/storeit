class Hash:
    """chunk data hashes."""

    hsh = '0'

    def __init__(self, hsh):
        self.hsh = hsh

    def __str__(self):
        return self.hsh

    def pretty(self):
        hsh_size = 4
        return self.hsh[:hsh_size] + '...' + self.hsh[-hsh_size:]
