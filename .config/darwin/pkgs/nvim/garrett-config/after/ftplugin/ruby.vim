let b:ale_linters = [
      \'rubocop',
      \'rails_best_practices'
\]

let b:ale_fixers = [
      \'remove_trailing_lines',
      \'trim_whitespace',
      \'rubocop'
\]

let b:dispatch = 'ruby %'

set path-=vendor/bundle
