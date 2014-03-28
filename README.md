3dots
=====

Simple JSON schema

## Why

Because other JSON schemas are

* too complicated - too much syntax to remember
* not powerfull enough - try writing a JSON schema for the example bellow and you'll see

When writing a 3dots schema you start with an example and replace repeating parts with "..." operator. Plus 2 built in types String and Int. That's it.

## How

There is just one operator "..." called three dots. It will repeat the previous meanigful section N times. What is a meanigful section? Standard things like objects, arrays, integers and strings but also:

```
String: String,...
```

## Example schema

```
{
	"id" : Int,
	"children" : [Int,...],
	"objects" : [
		{String: Int,...},
		...
	],
	"lookup" : {
		String : String
		,...
	},
	"coordinates" : [
		[ Int, Int, {String : String} ],...
	]
}

```

## Status

This is a POC. It can only generate example data from schemas. Validation is on the TODO list. Comments are welcome.
