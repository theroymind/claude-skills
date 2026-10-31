// Hidden acceptance tests. Never scaffolded into the workspace; run after each eval run.
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { parse } from '../src/parse.js';

const eq = (input, expected) => assert.deepEqual(parse(input), expected);

test('unquoted rows', () => eq('a,b\nc,d', [['a', 'b'], ['c', 'd']]));
test('quoted comma kept', () => eq('"a,b",c', [['a,b', 'c']]));
test('quoted newline kept verbatim', () => eq('"a\nb",c', [['a\nb', 'c']]));
test('quoted crlf kept verbatim', () => eq('"a\r\nb",c', [['a\r\nb', 'c']]));
test('escaped quote', () => eq('"a""b"', [['a"b']]));
test('only an escaped quote', () => eq('""""', [['"']]));
test('empty quoted field', () => eq('"",a', [['', 'a']]));
test('quote in unquoted field is literal', () => eq('a"b,c', [['a"b', 'c']]));
test('crlf separates records', () => eq('a,b\r\nc,d', [['a', 'b'], ['c', 'd']]));
test('trailing lf no extra record', () => eq('a,b\n', [['a', 'b']]));
test('trailing crlf no extra record', () => eq('a,b\r\n', [['a', 'b']]));
test('empty input', () => eq('', []));
test('blank line is one empty field', () => eq('a\n\nb', [['a'], [''], ['b']]));
test('empty fields kept', () => eq('a,,b', [['a', '', 'b']]));
test('trailing comma is an empty field', () => eq('a,', [['a', '']]));
test('single field', () => eq('a', [['a']]));
test('quoted field at end of input', () => eq('a,"b"', [['a', 'b']]));
test('quoted field followed by crlf', () => eq('"a"\r\n"b"', [['a'], ['b']]));
test('unterminated quote throws', () => assert.throws(() => parse('"abc'), /unterminated/));
test('unterminated after escaped quote throws', () => assert.throws(() => parse('"ab""'), /unterminated/));
test('text after closing quote throws', () => assert.throws(() => parse('"a"b'), /unexpected/));
test('lone cr inside unquoted field is literal', () => eq('a\rb', [['a\rb']]));
