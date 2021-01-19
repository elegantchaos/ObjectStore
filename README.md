# ObjectStore

A very simple object store protocol, which works with Swift's `Codable` protocol.

Provides three basic operations:

- save some objects 
- load some objects
- remove some objects

Objects are stored and retrieved using identifiers. 

Ideally these can be anything conforming to the `Identifiable` protocol, although currently some parts of the API require them to be `String`.

Objects can be encoded/decoded in any way that the implementation chooses.

An basic implementation is provided which:

- stores each object as a separate file.
- uses the identifier of the object to name the file
- stores a `Data` object as the content of the file
- uses a helper `ObjectCoder` object to encode/decode the objects to/from `Data`



