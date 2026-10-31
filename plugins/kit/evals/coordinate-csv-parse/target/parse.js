// Reference solution: the target the hidden tests are validated against.
export function parse(text) {
  const rows = [];
  if (text === '') return rows;
  let row = [];
  let field = '';
  let state = 'start'; // start | unquoted | quoted | quoteInQuoted
  let i = 0;
  const endField = () => { row.push(field); field = ''; state = 'start'; };
  const endRow = () => { endField(); rows.push(row); row = []; };
  while (i < text.length) {
    const c = text[i];
    const next = text[i + 1];
    if (state === 'start' && c === '"') { state = 'quoted'; i++; continue; }
    if (state === 'quoted') {
      if (c === '"') { state = 'quoteInQuoted'; i++; continue; }
      field += c; i++; continue;
    }
    if (state === 'quoteInQuoted') {
      if (c === '"') { field += '"'; state = 'quoted'; i++; continue; }
      if (c === ',' || c === '\n' || c === '\r') { state = 'unquoted'; continue; }
      throw new Error(`unexpected character after closing quote at ${i}`);
    }
    // start or unquoted
    if (c === ',') { endField(); i++; continue; }
    if (c === '\n') { endRow(); i++; continue; }
    if (c === '\r' && next === '\n') { endRow(); i += 2; continue; }
    state = 'unquoted'; field += c; i++;
  }
  if (state === 'quoted') throw new Error('unterminated quoted field');
  // A trailing newline already closed the last record; only flush a record that has content pending.
  if (state !== 'start' || field !== '' || row.length > 0) endRow();
  return rows;
}
