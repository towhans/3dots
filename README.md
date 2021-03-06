3dots
=====

Simple JSON schema

## Why

Because other JSON schemas are

* too complicated - too much syntax to remember
* not powerfull enough - try writing a JSON schema for the example bellow and you'll see

When writing a 3dots schema you start with an example and replace repeating parts with "..." operator. Plus 2 built in types String and Int. You can substitute `,` with pipe `|`. Pipe means OR. The opearands are PMS (previous meaningful section) and the following meaningful section.

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
		{"name": String}|
		{"price": Int},
		...
	],
	"lookup" : {
		String : String,
		...
	},
	"coordinates" : [
		[ Int, Int, {String : String} ],
		...
	]
}

```
## Try

```
git clone https://github.com/towhans/3dots.git
cd 3dots
perl generate.pl
```

## Status

This is a POC. It can only generate example data from schemas. Validation is on the TODO list. Comments are welcome.
