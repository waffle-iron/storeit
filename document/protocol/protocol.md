StoreIt Protocol v0.4
=====================
---

#### 1. Introduction

Hello, this is the documentation for the StoreIt protocol. It is used to com- municate with our server. We will be implementing this protocol on top of WEBSOCKETS to enjoy its messaging model.
Everything should be JSON objects.

#### 2. The JSON data structures

##### 2.1 Command

```javascript
{
	"uid": unique_command_id,
	"command": command_name,
	"parameters": {
		"parameter1Name": parameter1,
		"parameter2Name": parameter2,
	}
}
```

##### 2.2 Response

```javascript
{
	"code": code,
	"text": response_message,
	"commandUid": command_id,
	"command": "RESP",
	(optional) "parameters": {
		...
	}
}
```
TODO: document possible errors.

##### 2.3 Commands

###### JOIN

From a client to the server.
This is the first request to make whenever a client wants to get online.

```javascript
{
	"uid": 263,
	"command": "JOIN",
	"parameters": {
		"authType": "fb",
		"accessToken": "34j8b4jhb343hbKJH54",
	}
}
```

The response will contain a FILE object named "home". Example :

```javascript
{
	"code": 0,
	"text": "welcome",
	"commandUid": 42,
	"command": "JOIN",
	"parameters": {
		"home": FILEObject
	}
}
```

##### FDEL

From a client or the server.
Delete a file/directory.

```javascript
{
	"uid": 765,
	"command": "FDEL",
	"parameters": {
		"files": [FILEObject, ...]
	}
}
```

###### FADD

From a client or a server.
Add a file to the user three.

```javascript
{
	"uid": 766,
	"command": "FADD",
	"parameters": {
		"files": [FILEObject, ...]
	}
}
```

###### FUPT

From a client or a server.
Update a file.

```javascript
{
	"uid": 767,
	"command": "FUPT",
	"parameters": {
		"files": [FILEObject, ...]
	}
}
```

##### 2.4 FILE object

This object describe a file or a directory.

```javascript
{
	"path": "/foo/bar",
	"metadata": metadata,
	"IPFSHash": "IPFS hash of all the data in the file",
	"isDir": true,
	"files": {
		"foo.txt": FILEObject,
		"someDirectory": FILEObject,
	}
}```