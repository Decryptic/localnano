# Local Nano

A marketplace built on top of Nano currency & created with Flutter.

## Screenshots
![Alt text](/screenshots/localnano.png?raw=true "Local Nano")

## About
LocalNano is a layer 2 marketplace developed on top of the Nano
distributed ledger. Sign up is simple, the app will generate 
a private key for each new user, and the key never leaves the
device unless the user does so. Every LocalNano account will
be a new account on the block lattice; that is, existing Nano
accounts cannot register on LocalNano. Users will also have the
option to import an existing LocalNano account.

## Security
If your application binary was compiled from this official
repository, then this app is 100% safe to use, as long as the
user does not compromise their keys themselves. The private key
is stored on the device, but the app will never broadcast the
private key in the background, not even to the server. When a
user sends or receives a payment in the app, the app itself
generates a signed send/receive block and submits that transaction to
the server for broadcasting. An asymmetric SHA256 hash of the
private key is used for authentication, but this does not expose
the private key.
