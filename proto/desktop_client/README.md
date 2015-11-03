Storeit Desktop Client
======================

Table des matières
------------------
1. [Description](#description)
2. [Prérequis](#prérequis)
3. [Installation](#installation)
3. [Liens utiles](#liens-utiles)

Description
------------
TODO

Prérequis
------------
* node.js & npm
* git

Configurer npm
---------------
Il est important que le dossier d'installation de npm soit un dossier sur lequel l'utilisateur à les droits en écriture. Cela a fin d'éviter de lancer npm avec des droits privilégiés (souvent npm vous engueulera si vous le lancez avec sudo).
Bref, pour connaître le dossier d'installation courant :

    npm config get prefix

Sous Windows, la configuartion par défaut est suffisante. En revanche sous Linux/OS X, le chemin par défaut est /usr/local. Pour le changer utilisez : 

    npm config set prefix <new_path>

Sans oublier d'ajouter de modifier votre PATH. Typiquement, disons que je voulez utilisez le dossier ~/.npm, il suffit de rajouter cette ligne à votre .bashrc :

    PATH=$PATH:$HOME/.npm/bin

Installation
------------
1. Après avoir cloné le dépôt
2. Depuis un terminal, rendez-vous dans le dossier "*desktop_client*"
3. Lancez l'installation

    npm link

3. Pour vérifier que l'installation c'est bien effectuée, dans votre terminal tapez

    storeit_client

4. Si la commande est introuvable, ajoutez *C:\Users\\**nom_utilisateur**\AppData\Roaming\npm* à votre PATH

Liens utiles
------------
* [API Http](http://78.192.138.139/swagger-ui/dist/)
