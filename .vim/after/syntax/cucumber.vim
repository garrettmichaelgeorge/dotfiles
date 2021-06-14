" Allows quotation marks in step bodies
syn region cucumberGivenString start=/"/ skip=/\\"/ end=/"/ contained containedin=cucumberGivenRegion,cucumberGivenAndRegion,cucumberGivenButRegion
syn region cucumberWhenString start=/"/ skip=/\\"/ end=/"/ contained containedin=cucumberWhenRegion,cucumberWhenAndRegion,cucumberWhenButRegion
syn region cucumberThenString start=/"/ skip=/\\"/ end=/"/ contained containedin=cucumberThenRegion,cucumberThenAndRegion,cucumberThenButRegion

" Add Gherkin 8+ syntax keywords in English
" Note: This is a hack and breaks the multilingual function
" for these syntax groups in tpope's official syntax file
syn match cucumberScenario          /\%(^\s*\)\@<=\(Example\|Scenario\):/
syn match cucumberScenarioOutline   /\%(^\s*\)\@<=\(Scenario Outline\|Scenario Template\|Rule\):/

hi def link cucumberGivenString cucumberString
hi def link cucumberWhenString cucumberString
hi def link cucumberThenString cucumberString
