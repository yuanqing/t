# t [![Version](https://img.shields.io/badge/version-v0.1.0-orange.svg?style=flat)](https://github.com/yuanqing/t/releases) [![Build Status](https://img.shields.io/travis/yuanqing/t.svg?branch=master&style=flat)](https://travis-ci.org/yuanqing/t)

> A Bash utility for testing Java programs that read from `stdin` and write to `stdout`.

## Usage

The following directory structure is required:

```
$ ls
Reverse.java  input         output
$ ls input
reverse1.in   reverse2.in   reverse3.in
$ ls output
reverse1.out  reverse2.out  reverse3.out
```

In this example, [`Reverse.java`](https://github.com/yuanqing/t/blob/master/example/Reverse.java) is a program that reads lines from `stdin`, reverses the characters of each line, and prints the result to `stdout`.

### Feeding the program an input

To feed the program a particular input file (say, [`input/reverse1.in`](https://github.com/yuanqing/t/blob/master/example/input/reverse1.in)), invoke `t` with a single numeric argument:

```
$ t 1
oof
```

The above command is equivalent to:

```
$ javac Reverse.java && java Reverse < input/reverse1.in
oof
```

### Running tests

To feed the program all the input files (from the `input` directory), and compare the program&rsquo;s actual output with the corresponding expected output files (in the `output` directory), invoke `t` without any arguments:

```
$ t

   1 ✔
   2 ✔
   3 ✔

   3 / 3

```

- A `✔` means that the actual and expected outputs are identical.
- A `✗` means that a runtime error had occurred, or that the actual and expected outputs are different.
- The last line indicates the number of passes out of the total number of test cases.

A broken implementation of our example program might produce the following output when tested with `t`:

```
$ t

   1 ✔
   2 ✗ java: Exception in thread "main" java.lang.NullPointerException
         at Reverse.main(Reverse.java:8)
   3 ✗ cmp: output/reverse3.out - differ: char 1, line 1

   1 / 3

```

## Tests

You need [Bats](https://github.com/sstephenson/bats) to run the tests:

```
$ git clone https://github.com/yuanqing/t
$ cd t/test
$ bats *.bats
```

## Installation

To install `t` into `/usr/local/bin`, simply do:

```
$ curl -k -L -o /usr/local/bin/t https://raw.github.com/yuanqing/t/master/t
$ chmod +x /usr/local/bin/t
```

## Changelog

- 0.1.0
  - Initial release

## License

[MIT](https://github.com/yuanqing/t/blob/master/LICENSE)
